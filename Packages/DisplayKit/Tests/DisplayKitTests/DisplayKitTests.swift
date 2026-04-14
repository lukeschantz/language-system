import Testing
@testable import DisplayKit
@testable import SharedModels

@Test func scaffoldLevelControlsVisibility() {
    // Verify the scaffold model drives display decisions
    #expect(ScaffoldLevel.beginner.showsReadingByDefault == true)
    #expect(ScaffoldLevel.beginner.showsGroupingByDefault == true)
    #expect(ScaffoldLevel.beginner.showsMeaningByDefault == true)

    #expect(ScaffoldLevel.advanced.showsReadingByDefault == false)
    #expect(ScaffoldLevel.advanced.showsGroupingByDefault == false)
    #expect(ScaffoldLevel.advanced.showsMeaningByDefault == false)
}
