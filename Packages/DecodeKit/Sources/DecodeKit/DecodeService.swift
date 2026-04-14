import Foundation
import SharedModels

/// Orchestrates the full decode pipeline: language ID → tokenization → dictionary lookup.
/// Takes raw TextRegions from CaptureKit and produces fully annotated regions with tokens.
public final class DecodeService: Sendable {
    private let languageIdentifier: LanguageIdentifier
    private let tokenizer: any TokenizerProtocol
    private let dictionary: any DictionaryServiceProtocol

    public init(
        tokenizer: any TokenizerProtocol = NLTokenizer_(),
        dictionary: any DictionaryServiceProtocol
    ) {
        self.languageIdentifier = LanguageIdentifier()
        self.tokenizer = tokenizer
        self.dictionary = dictionary
    }

    /// Decode a text region: identify language, tokenize, and look up meanings.
    public func decode(_ region: TextRegion) -> TextRegion {
        var decoded = region

        // Step 1: Tokenize
        var tokens = tokenizer.tokenize(region.text)

        // Step 2: Look up each token in the dictionary
        for i in tokens.indices {
            let query = tokens[i].lemma ?? tokens[i].surface
            tokens[i].lexicalEntries = dictionary.lookup(query)

            // If lemma lookup failed, try surface form
            if tokens[i].lexicalEntries.isEmpty && tokens[i].lemma != nil {
                tokens[i].lexicalEntries = dictionary.lookup(tokens[i].surface)
            }
        }

        decoded.tokens = tokens
        return decoded
    }

    /// Decode multiple text regions.
    public func decode(_ regions: [TextRegion]) -> [TextRegion] {
        regions.map { decode($0) }
    }
}
