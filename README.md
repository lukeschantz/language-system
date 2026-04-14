# LanguageLens

A camera-based travel language app that goes beyond translation into **structural decoding** and **situational pragmatics**. Point your camera at text and get layered breakdowns: original → sound → word grouping → meaning → cultural notes.

Built on evidence from SLA research, cognitive load theory, and intercultural pragmatics. See [`deep-research-report-language-system.md`](deep-research-report-language-system.md) for the full research foundation.

## Architecture

Six Swift packages, one app target:

```
App/LanguageLens/          iOS app entry point and navigation
Packages/
├── SharedModels/          Core types (TextRegion, Token, Encounter, etc.)
├── CaptureKit/            Camera + Apple Vision OCR
├── DecodeKit/             Language ID, tokenization, dictionary lookup
├── DisplayKit/            SwiftUI layered overlay views
├── ContextEngine/         Location + time → phrase suggestions
└── MemoryKit/             Encounter storage + spaced review scheduler
Data/JMdict/               Dictionary data import pipeline
```

### Pipeline

```
Camera → OCR → Text Regions → Tokenize → Dictionary Lookup → Layered Display
                                                                    ↓
                                              Encounter Store → Review Queue
Location + Time → Context Engine → Phrase Suggestions
```

## Requirements

- macOS with Xcode 15+
- iOS 17+ deployment target
- [XcodeGen](https://github.com/yonaskolb/XcodeGen) (for project generation)

## Getting Started

```bash
# First-time setup
make setup

# Or manually:
brew install xcodegen
xcodegen generate
open LanguageLens.xcodeproj
```

## Development

```bash
make open          # Generate project and open in Xcode
make test          # Run tests via xcodebuild
make test-packages # Test each Swift package independently
make clean         # Remove build artifacts
```

## Project Status

**Phase: Scaffold / MVP foundation**

- [x] Core data models (SharedModels)
- [x] Camera + OCR pipeline (CaptureKit)
- [x] Tokenization + dictionary protocol (DecodeKit)
- [x] Layered overlay UI components (DisplayKit)
- [x] Location + phrase suggestions (ContextEngine)
- [x] Encounter store + spaced review (MemoryKit)
- [x] App shell with tab navigation
- [ ] JMdict SQLite import pipeline
- [ ] MeCab integration for Japanese morphology
- [ ] Live camera overlay (connecting CaptureKit → DecodeKit → DisplayKit)
- [ ] SwiftData persistence (replacing in-memory stores)
- [ ] Itinerary / "Next" suggestions

## License

TBD

## Attribution

Japanese dictionary data from [JMdict/EDICT](https://www.edrdg.org/wiki/index.php/JMdict-EDICT_Dictionary_Project) by the Electronic Dictionary Research and Development Group (EDRDG).
