import Foundation
import Combine

enum MemberFailure: Error {
    case invalidName
}

protocol MemberManager {
    var membersPublisher: AnyPublisher<Result<[Member], MemberFailure>, Never> { get }
    func addMember(name: String)
    func remove(member: Member)
}

class DefaultMemberManager: MemberManager {
    private static var sharedInstance: DefaultMemberManager?
    private var currentMembers: [Member] = []
    private var id = 0

    static var shared: DefaultMemberManager {
        if let sharedInstance = sharedInstance {
            return sharedInstance
        } else {
            sharedInstance = DefaultMemberManager()
            return sharedInstance!
        }
    }

    private init() {}

    private let membersSubject = CurrentValueSubject<Result<[Member], MemberFailure>, Never>(.success([]))

    var membersPublisher: AnyPublisher<Result<[Member], MemberFailure>, Never> {
        membersSubject.eraseToAnyPublisher()
    }

    func addMember(name: String) {
        if (name.lowercased() == "invalid name") {
            membersSubject.send(.failure(.invalidName))
        } else {
            id = id + 1
            let newMember = Member(id: id, name: name)
            currentMembers = currentMembers + [newMember]
            membersSubject.send(.success(currentMembers))
        }
    }

    func remove(member: Member) {
        guard let memberIndex = currentMembers.firstIndex(of: member) else { return }
        currentMembers.remove(at: memberIndex)
        membersSubject.send(.success(currentMembers))
    }

    func resetMembers() {
        membersSubject.send(.success([]))
    }
}
