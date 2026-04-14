import NaturalLanguage
import SharedModels

/// Protocol for language-specific tokenizers.
/// Allows swapping between Apple NL tokenization and dedicated analyzers (e.g., MeCab).
public protocol TokenizerProtocol: Sendable {
    func tokenize(_ text: String) -> [Token]
}

/// Default tokenizer using Apple's NaturalLanguage framework.
/// Provides reasonable results for Japanese, Chinese, Korean, and Latin scripts.
/// For higher-quality Japanese morphology (readings, lemmas), use a MeCab-based tokenizer.
public struct NLTokenizer_: TokenizerProtocol {
    private let language: NLLanguage?

    public init(language: NLLanguage? = .japanese) {
        self.language = language
    }

    public func tokenize(_ text: String) -> [Token] {
        let tokenizer = NLTokenizer(unit: .word)
        if let language {
            tokenizer.setLanguage(language)
        }
        tokenizer.string = text

        var tokens: [Token] = []
        tokenizer.enumerateTokens(in: text.startIndex..<text.endIndex) { range, _ in
            let surface = String(text[range])
            let token = Token(
                surface: surface,
                reading: nil,  // NLTokenizer doesn't provide readings
                lemma: lemma(for: surface, in: text),
                roleLabel: nil,
                range: range
            )
            tokens.append(token)
            return true
        }

        return tokens
    }

    private func lemma(for word: String, in text: String) -> String? {
        let tagger = NLTagger(tagSchemes: [.lemma])
        tagger.string = word
        if let language {
            tagger.setLanguage(language, range: word.startIndex..<word.endIndex)
        }
        let (tag, _) = tagger.tag(at: word.startIndex, unit: .word, scheme: .lemma)
        return tag?.rawValue
    }
}

// MARK: - MeCab placeholder

/// Placeholder for a future MeCab-based tokenizer that provides higher quality
/// Japanese morphological analysis including readings, parts of speech, and lemmas.
///
/// Implementation will wrap MeCab as a C library dependency.
/// Expected to provide:
/// - Accurate word segmentation for Japanese
/// - Hiragana readings for all tokens
/// - Part-of-speech tags mappable to RoleLabel
/// - Dictionary form (lemma) for inflected words
public struct MeCabTokenizer: TokenizerProtocol {
    public init() {}

    public func tokenize(_ text: String) -> [Token] {
        // TODO: Implement MeCab C library integration
        // For now, fall back to NLTokenizer
        return NLTokenizer_(language: .japanese).tokenize(text)
    }
}
