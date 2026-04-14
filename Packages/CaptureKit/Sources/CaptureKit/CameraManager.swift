import AVFoundation
import Combine

/// Manages the AVCaptureSession lifecycle and delivers sample buffers for OCR processing.
public final class CameraManager: NSObject, ObservableObject {
    @Published public var isRunning = false
    @Published public var error: CameraError?

    private let captureSession = AVCaptureSession()
    private let videoOutput = AVCaptureVideoDataOutput()
    private let processingQueue = DispatchQueue(label: "com.languagelens.camera", qos: .userInteractive)

    /// Called with each new sample buffer from the camera.
    public var onFrame: ((CMSampleBuffer) -> Void)?

    public override init() {
        super.init()
    }

    /// Request camera authorization and configure the capture session.
    public func configure() async throws {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        switch status {
        case .notDetermined:
            let granted = await AVCaptureDevice.requestAccess(for: .video)
            guard granted else { throw CameraError.notAuthorized }
        case .authorized:
            break
        default:
            throw CameraError.notAuthorized
        }

        try setupSession()
    }

    /// Start delivering frames.
    public func start() {
        guard !captureSession.isRunning else { return }
        processingQueue.async { [captureSession] in
            captureSession.startRunning()
        }
        isRunning = true
    }

    /// Stop delivering frames.
    public func stop() {
        guard captureSession.isRunning else { return }
        processingQueue.async { [captureSession] in
            captureSession.stopRunning()
        }
        isRunning = false
    }

    // MARK: - Private

    private func setupSession() throws {
        captureSession.beginConfiguration()
        defer { captureSession.commitConfiguration() }

        captureSession.sessionPreset = .high

        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
            throw CameraError.noCamera
        }

        let input = try AVCaptureDeviceInput(device: device)
        guard captureSession.canAddInput(input) else {
            throw CameraError.configurationFailed
        }
        captureSession.addInput(input)

        videoOutput.setSampleBufferDelegate(self, queue: processingQueue)
        videoOutput.alwaysDiscardsLateVideoFrames = true
        guard captureSession.canAddOutput(videoOutput) else {
            throw CameraError.configurationFailed
        }
        captureSession.addOutput(videoOutput)

        // Use portrait orientation for text recognition
        if let connection = videoOutput.connection(with: .video) {
            connection.videoRotationAngle = 90
        }
    }
}

// MARK: - AVCaptureVideoDataOutputSampleBufferDelegate

extension CameraManager: AVCaptureVideoDataOutputSampleBufferDelegate {
    public func captureOutput(
        _ output: AVCaptureOutput,
        didOutput sampleBuffer: CMSampleBuffer,
        from connection: AVCaptureConnection
    ) {
        onFrame?(sampleBuffer)
    }
}

// MARK: - Errors

public enum CameraError: LocalizedError {
    case notAuthorized
    case noCamera
    case configurationFailed

    public var errorDescription: String? {
        switch self {
        case .notAuthorized: "Camera access not authorized."
        case .noCamera: "No camera available."
        case .configurationFailed: "Failed to configure camera session."
        }
    }
}
