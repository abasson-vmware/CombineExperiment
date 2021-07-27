@testable import CombineExperiment
import Quick
import Nimble
import ViewInspector

class MembersSummaryViewTest: QuickSpec {
    override func spec() {
        var subject: MembersSummaryView!
        var memberManager: SpyMemberManager!

        beforeEach {
            memberManager = SpyMemberManager()

            let viewModel = MembersSummaryViewModel(memberManager: memberManager)
            subject = MembersSummaryView(viewModel: viewModel)
        }

        it("displays the number of members") {
            memberManager.membersSubject.send([
                Member(id: 1, name: "one"),
                Member(id: 2, name: "two")
            ])

            let view = try subject.inspect()

            expect(try view.find(text: "Number of members: 2")).notTo(beNil())
        }
    }
}

extension MembersSummaryView: Inspectable {}
