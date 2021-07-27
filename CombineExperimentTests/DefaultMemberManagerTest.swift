@testable import CombineExperiment
import Quick
import Nimble
import Combine

class DefaultMemberManagerTest: QuickSpec {
    override func spec() {
        var subject: DefaultMemberManager!
        var actualMembers: [Member] = []
        var subscription: AnyCancellable!

        beforeEach {
            subject = DefaultMemberManager.shared

            subscription = subject.membersPublisher
                .sink { members in
                    actualMembers = members
                }
        }

        afterEach {
            subscription.cancel()
        }

        describe("addMember()") {
            beforeEach {
                subject.addMember(name: "new member name")
            }

            it("emits the updated members") {
                let expectedMembers = [
                    Member(id: 1, name: "new member name")
                ]

                expect(actualMembers).to(equal(expectedMembers))
            }
        }
    }
}
