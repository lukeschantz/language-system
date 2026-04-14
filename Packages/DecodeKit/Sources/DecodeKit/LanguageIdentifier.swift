import NaturalLanguage
import SharedModels

/// Identifies the dominant language and script of a text string.
public struct LanguageIdentifier: Sendable {
    public init() {}

    /// Identify the language of the given text using Apple NaturalLanguage.
    public func identify(_ text: String) -> IdentificationResult {
        let recognizer = NLLanguageRecognizer()
        recognizer.processString(text)

        let dominant = recognizer.dominantLanguage
        let hypotheses = recognizer.languageHypotheses(withMaximum: 3)

        let script = scriptFromText(text)
        let language = dominant.map { mapLanguage($0) } ?? .unknown

        return IdentificationResult(
            language: language,
            script: script,
            confidence: hypotheses[dominant ?? .undetermined] ?? 0
        )
    }

    // MARK: - Private

    private func scriptFromText(_ text: String) -> Script {
        // Reuse the same heuristic as TextRecognizer for consistency
        var kanaCount = 0
        var cjkCount = 0
        var hangulCount = 0
        var latinCount = 0

        for scalar in text.unicodeScalars {
            switch scalar.value {
            case 0x3040...0x309F, 0x30A0...0x30FF: kanaCount += 1
            case 0x4E00...0x9FFF: cjkCount += 1
            case 0xAC00...0xD7AF, 0x1100...0x11FF: hangulCount += 1
            case 0x0041...0x005A, 0x0061...0x007A: latinCount += 1
            default: break
            }
        }

        if kanaCount > 0 { return .japanese }
        if hangulCount > 0 { return .korean }
        if cjkCount > latinCount { return .chinese }
        if latinCount > 0 { return .latin }
        return .unknown
    }

    private func mapLanguage(_ nlLanguage: NLLanguage) -> Language {
        switch nlLanguage {
        case .japanese: return .japanese
        case .simplifiedChinese, .traditionalChinese: return .chinese
        case .korean: return .korean
        case .english: return .english
        default: return .unknown
        }
    }
}

public struct IdentificationResult: Sendable {
    public let language: Language
    public let script: Script
    public let confidence: Double
}

public enum Language: String, Sendable {
    case japanese
    case chinese
    case korean
    case english
    case unknown
}
