@testable import CombineExperiment
import Quick
import Nimble
import ViewInspector

class AddMemberFormViewTest: QuickSpec {
    override func spec() {
        var subject: AddMemberFormView!
        var memberManager: SpyMemberManager!

        beforeEach {
            memberManager = SpyMemberManager()

            let viewModel = AddMemberFormViewModel(memberManager: memberManager)
            subject = AddMemberFormView(viewModel: viewModel)
        }

        describe("when the user submits the form") {
            it("passes") {
                self.onViewDidAppear(subject) { view in
                    let nameTextField = try? view.find(viewWithTag: "newMemberName").textField()
                    try nameTextField?.setInput("some name")

                    try view.find(button: "Add new member").tap()

                    expect(memberManager.addMemberWasCalled(with: "some name")).to(beTrue())
                }
            }
        }
    }
}

extension AddMemberFormView: Inspectable {}
