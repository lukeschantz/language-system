import AVFoundation
import Combine
import SharedModels

/// Orchestrates camera capture and text recognition into a stream of TextRegions.
/// This is the main public interface for the Capture subsystem.
@MainActor
public final class CaptureService: ObservableObject {
    @Published public private(set) var regions: [TextRegion] = []
    @Published public private(set) var isProcessing = false

    private let cameraManager = CameraManager()
    private let textRecognizer: TextRecognizer

    /// Throttle: minimum interval between OCR passes (seconds).
    private let recognitionInterval: TimeInterval
    private var lastRecognitionTime: Date = .distantPast

    public init(
        recognitionLanguages: [String] = ["ja", "en"],
        recognitionInterval: TimeInterval = 0.3
    ) {
        self.textRecognizer = TextRecognizer(recognitionLanguages: recognitionLanguages)
        self.recognitionInterval = recognitionInterval
        setupFrameHandler()
    }

    /// Configure and start the capture pipeline.
    public func start() async throws {
        try await cameraManager.configure()
        cameraManager.start()
    }

    /// Stop the capture pipeline.
    public func stop() {
        cameraManager.stop()
        regions = []
    }

    /// Recognize text in a still image (e.g., from photo library).
    public func recognize(image: CGImage) async throws -> [TextRegion] {
        try await textRecognizer.recognize(in: image)
    }

    // MARK: - Private

    private func setupFrameHandler() {
        cameraManager.onFrame = { [weak self] sampleBuffer in
            guard let self else { return }

            let now = Date()
            guard now.timeIntervalSince(self.lastRecognitionTime) >= self.recognitionInterval else { return }
            self.lastRecognitionTime = now

            guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }

            Task { @MainActor in
                self.isProcessing = true
                do {
                    let newRegions = try await self.textRecognizer.recognize(in: pixelBuffer)
                    self.regions = newRegions
                } catch {
                    // Silently drop recognition errors for individual frames
                }
                self.isProcessing = false
            }
        }
    }
}
