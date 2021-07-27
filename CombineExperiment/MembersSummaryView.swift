import SwiftUI
import Combine

class MembersSummaryViewModel: ObservableObject {
    private let memberManager: MemberManager
    private var subscription: AnyCancellable?

    @Published var memberCount: Int = 0

    init(memberManager: MemberManager) {
        self.memberManager = memberManager
        self.subscription = memberManager.membersPublisher
            .sink { [self] members in
                self.memberCount = members.count
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
}

struct MembersSummaryView: View {
    @ObservedObject private var viewModel: MembersSummaryViewModel

    init(viewModel: MembersSummaryViewModel) {
        self.viewModel = viewModel
    }

    init() {
        self.init(viewModel: MembersSummaryViewModel())
    }

    var body: some View {
        Text("Number of members: \(viewModel.memberCount)").bold()
    }
}
