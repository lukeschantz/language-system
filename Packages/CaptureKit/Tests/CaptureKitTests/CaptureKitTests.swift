import Testing
@testable import CaptureKit
@testable import SharedModels

@Test func textRecognizerInit() {
    let recognizer = TextRecognizer(recognitionLanguages: ["ja", "en"])
    // Verify it can be created without errors
    #expect(recognizer != nil)
}
