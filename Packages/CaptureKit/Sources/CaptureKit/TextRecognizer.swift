import Vision
import CoreImage
import SharedModels

/// Performs on-device text recognition using Apple Vision framework.
/// Supports both live camera buffers and still images.
public final class TextRecognizer: Sendable {
    /// Languages to prioritize for recognition. Vision will auto-detect but hints improve accuracy.
    private let recognitionLanguages: [String]
    /// Minimum confidence threshold to include a result.
    private let minimumConfidence: Float

    public init(
        recognitionLanguages: [String] = ["ja", "en"],
        minimumConfidence: Float = 0.3
    ) {
        self.recognitionLanguages = recognitionLanguages
        self.minimumConfidence = minimumConfidence
    }

    /// Recognize text in a CVPixelBuffer (from a live camera frame).
    public func recognize(in pixelBuffer: CVPixelBuffer) async throws -> [TextRegion] {
        let request = VNRecognizeTextRequest()
        request.recognitionLevel = .accurate
        request.recognitionLanguages = recognitionLanguages
        request.usesLanguageCorrection = true

        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])
        try handler.perform([request])

        return processResults(request.results)
    }

    /// Recognize text in a CGImage (from a still photo or saved image).
    public func recognize(in image: CGImage) async throws -> [TextRegion] {
        let request = VNRecognizeTextRequest()
        request.recognitionLevel = .accurate
        request.recognitionLanguages = recognitionLanguages
        request.usesLanguageCorrection = true

        let handler = VNImageRequestHandler(cgImage: image, options: [:])
        try handler.perform([request])

        return processResults(request.results)
    }

    // MARK: - Private

    private func processResults(_ observations: [VNRecognizedTextObservation]?) -> [TextRegion] {
        guard let observations else { return [] }

        return observations.compactMap { observation in
            guard let candidate = observation.topCandidates(1).first,
                  candidate.confidence >= minimumConfidence else {
                return nil
            }

            let script = detectScript(candidate.string)

            return TextRegion(
                text: candidate.string,
                boundingBox: observation.boundingBox,
                confidence: candidate.confidence,
                script: script
            )
        }
    }

    private func detectScript(_ text: String) -> Script {
        var jaCount = 0
        var zhCount = 0
        var koCount = 0
        var latinCount = 0

        for scalar in text.unicodeScalars {
            switch scalar.value {
            case 0x3040...0x309F, 0x30A0...0x30FF:
                // Hiragana or Katakana → Japanese
                jaCount += 1
            case 0xAC00...0xD7AF, 0x1100...0x11FF:
                // Hangul → Korean
                koCount += 1
            case 0x4E00...0x9FFF:
                // CJK Unified — could be Japanese or Chinese, count separately
                zhCount += 1
            case 0x0041...0x005A, 0x0061...0x007A:
                latinCount += 1
            default:
                break
            }
        }

        // If any kana present, it's Japanese (even with kanji)
        if jaCount > 0 { return .japanese }
        if koCount > 0 { return .korean }
        if zhCount > latinCount { return .chinese }
        if latinCount > 0 { return .latin }
        return .unknown
    }
}
