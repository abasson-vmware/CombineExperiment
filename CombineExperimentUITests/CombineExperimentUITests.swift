import XCTest

class CombineExperimentUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    func testManagingMembers() throws {
        app.assertThat("Number of members: 0").isDisplayed()

        submitForm(with: "Alice")

        app.assertThat("Alice").isDisplayed()
        app.assertThat("Number of members: 1").isDisplayed()

        submitForm(with: "Bob")

        app.assertThat("Bob").isDisplayed()
        app.assertThat("Number of members: 2").isDisplayed()

        submitForm(with: "Carl")

        app.assertThat("Carl").isDisplayed()
        app.assertThat("Number of members: 3").isDisplayed()

        removeButton(at: 0).tap()

        app.assertThat("Alice").isNotDisplayed()
        app.assertThat("Number of members: 2").isDisplayed()
    }

    func isDisplayed() {
        XCTAssertTrue(app.staticTexts["Number of members: 2"].exists)
    }

    private func submitForm(with name: String) {
        newMemberNameTextField.tap()
        newMemberNameTextField.typeText(name)
        addNewMemberButton.tap()
    }

    private var newMemberNameTextField: XCUIElement {
        app.textFields["New member name"]
    }

    private var addNewMemberButton: XCUIElement {
        app.buttons["Add new member"]
    }

    private func removeButton(at index: Int) -> XCUIElement {
        app.buttons.matching(identifier: "remove").element(boundBy: index)
    }
}

extension XCUIApplication {
    func assertThat(_ text: String) -> Thing {
        return Thing(app: self, text: text)
    }
}

struct Thing {
    let app: XCUIApplication
    let text: String

    func isDisplayed() {
        XCTAssertTrue(app.staticTexts[text].exists)
    }

    func isNotDisplayed() {
        XCTAssertFalse(app.staticTexts[text].exists)
    }
}
