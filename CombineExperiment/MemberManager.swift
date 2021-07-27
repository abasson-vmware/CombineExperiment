import Foundation
import Combine

protocol MemberManager {
    var membersPublisher: AnyPublisher<[Member], Never> { get }
    func addMember(name: String)
    func remove(member: Member)
}

class DefaultMemberManager: MemberManager {
    private static var sharedInstance: DefaultMemberManager?

    static var shared: DefaultMemberManager {
        if let sharedInstance = sharedInstance {
            return sharedInstance
        } else {
            sharedInstance = DefaultMemberManager()
            return sharedInstance!
        }
    }

    private init() {}

    private let membersSubject = CurrentValueSubject<[Member], Never>([])

    var membersPublisher: AnyPublisher<[Member], Never> {
        membersSubject.eraseToAnyPublisher()
    }

    func addMember(name: String) {
        let currentMembers = membersSubject.value
        let newMember = Member(id: currentMembers.count + 1, name: name)
        membersSubject.send(currentMembers + [newMember])
    }

    func remove(member: Member) {
        var currentMembers = membersSubject.value
        guard let memberIndex = currentMembers.firstIndex(of: member) else { return }
        currentMembers.remove(at: memberIndex)
        membersSubject.send(currentMembers)
    }
}
