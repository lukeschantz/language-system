import Foundation
import CoreGraphics

/// A region of recognized text within a camera frame or image.
public struct TextRegion: Identifiable, Sendable {
    public let id: UUID
    /// The raw recognized string.
    public let text: String
    /// Bounding box in normalized image coordinates (0..1).
    public let boundingBox: CGRect
    /// OCR confidence score (0..1).
    public let confidence: Float
    /// Detected script (e.g., .japanese, .chinese, .korean, .latin).
    public let script: Script
    /// Tokens produced by the decode pipeline, populated after tokenization.
    public var tokens: [Token]

    public init(
        id: UUID = UUID(),
        text: String,
        boundingBox: CGRect,
        confidence: Float,
        script: Script = .unknown,
        tokens: [Token] = []
    ) {
        self.id = id
        self.text = text
        self.boundingBox = boundingBox
        self.confidence = confidence
        self.script = script
        self.tokens = tokens
    }
}

public enum Script: String, Sendable, Codable, CaseIterable {
    case japanese
    case chinese
    case korean
    case latin
    case unknown
}
