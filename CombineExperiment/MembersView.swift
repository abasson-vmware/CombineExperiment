import SwiftUI
import Combine

class MembersViewModel: ObservableObject {
    private let memberManager: MemberManager
    private var subscription: AnyCancellable?

    @Published var members: [Member] = []

    init(memberManager: MemberManager) {
        self.memberManager = memberManager
        self.subscription = memberManager.membersPublisher
            .sink { [self] members in
                self.members = members
            }
    }

    convenience init() {
        self.init(
            memberManager: DefaultMemberManager.shared
        )
    }

    deinit {
        subscription?.cancel()
    }

    func remove(member: Member) {
        memberManager.remove(member: member)
    }
}

struct MembersView: View {
    @ObservedObject private var viewModel: MembersViewModel

    init(viewModel: MembersViewModel) {
        self.viewModel = viewModel
    }

    init() {
        self.init(viewModel: MembersViewModel())
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text("Members")
                .bold()
                .padding(.bottom, 8)

            ForEach(viewModel.members) { member in
                HStack {
                    Text(member.name)
                    Spacer()
                    Button(action: {
                        viewModel.remove(member: member)
                    }) {
                        Text("remove")
                    }
                }
                .padding(.bottom, 16)
            }

            Spacer()
        }
    }
}
