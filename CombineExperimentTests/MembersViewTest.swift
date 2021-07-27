@testable import CombineExperiment
import Quick
import Nimble
import ViewInspector

class MembersViewTest: QuickSpec {
    override func spec() {
        var subject: MembersView!
        var memberManager: SpyMemberManager!

        let members = [
            Member(id: 1, name: "one"),
            Member(id: 2, name: "two"),
            Member(id: 3, name: "three")
        ]

        beforeEach {
            memberManager = SpyMemberManager()

            let viewModel = MembersViewModel(memberManager: memberManager)
            subject = MembersView(viewModel: viewModel)
        }

        describe("when a list of members is published") {
            beforeEach {
                memberManager.membersSubject.send(members)
            }

            it("displays the members") {
                let view = try subject.inspect()
                expect(try view.find(text: "one")).notTo(beNil())
                expect(try view.find(text: "two")).notTo(beNil())
            }
        }

        describe("when the user taps 'Remove' on a member row") {
            beforeEach {
                memberManager.membersSubject.send(members)
            }

            it("calls 'remove' on the memberManager with the appropriate member") {
                let view = try subject.inspect()

                let memberTwoRow = try view.find(text: "two")
                expect(memberTwoRow).notTo(beNil())

                try memberTwoRow.parent().find(button: "remove").tap()

                expect(memberManager.removeWasCalled(with: Member(id: 2, name: "two"))).to(beTrue())
            }
        }
    }
}

extension MembersView: Inspectable {}
