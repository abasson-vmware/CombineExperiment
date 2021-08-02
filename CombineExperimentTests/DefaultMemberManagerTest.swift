@testable import CombineExperiment
import Quick
import Nimble
import Combine

class DefaultMemberManagerTest: QuickSpec {
    override func spec() {
        var subject: DefaultMemberManager!
        var actualMembers: [Member]!
        var memberFailure: MemberFailure?
        var subscription: AnyCancellable!

        beforeEach {
            actualMembers = []

            subject = DefaultMemberManager.shared

            subscription = subject.membersPublisher
                .sink { membersResult in
                    switch(membersResult) {
                    case let .success(members): actualMembers = members
                    case let .failure(error): memberFailure = error
                    }
                }
        }

        afterEach {
            subject.resetMembers()
            subscription.cancel()
        }

        describe("adding and removing members") {
            it("publishes the updated members") {
                subject.addMember(name: "new member name")

                expect(actualMembers).to(equal([
                    Member(id: 1, name: "new member name")
                ]))

                subject.addMember(name: "second member name")

                expect(actualMembers).to(equal([
                    Member(id: 1, name: "new member name"),
                    Member(id: 2, name: "second member name")
                ]))

                subject.remove(member: Member(id: 1, name: "new member name"))

                expect(actualMembers).to(equal([
                    Member(id: 2, name: "second member name")
                ]))

                subject.addMember(name: "a third member")

                expect(actualMembers).to(equal([
                    Member(id: 2, name: "second member name"),
                    Member(id: 3, name: "a third member")
                ]))
            }
        }

        describe("handling an invalid member name") {
            beforeEach {
                subject.addMember(name: "invalid name")
            }

            it("publishes an 'invalid name' error") {
                expect(memberFailure).to(equal(.invalidName))
            }

            it("does not publish a new member") {
                expect(actualMembers).to(equal([]))
            }
        }
    }
}
