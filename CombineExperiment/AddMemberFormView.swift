import SwiftUI
import Combine

class AddMemberFormViewModel: ObservableObject {
    private let memberManager: MemberManager
    private var subscription: AnyCancellable?

    @Published var invalidMemberNameError = false

    init(memberManager: MemberManager) {
        self.memberManager = memberManager
        self.subscription = memberManager.membersPublisher
            .sink { [weak self] membersResult in
                if case let .failure(error) = membersResult, case .invalidName = error {
                    self?.invalidMemberNameError = true
                } else {
                    self?.invalidMemberNameError = false
                }
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

    func addMember(name: String) {
        memberManager.addMember(name: name)
    }
}

struct AddMemberFormView: View, DidAppearable {
    @ObservedObject private var viewModel: AddMemberFormViewModel
    @State private var newMemberName: String = ""

    var didAppear: ((AddMemberFormView) -> Void)?

    init(viewModel: AddMemberFormViewModel) {
        self.viewModel = viewModel
    }

    init() {
        self.init(viewModel: AddMemberFormViewModel())
    }

    var body: some View {
        VStack(alignment: .leading) {
            TextField("New member name", text: $newMemberName)
                .tag("newMemberName")
                .padding(.bottom, 8)

            if viewModel.invalidMemberNameError {
                Text("invalid member name")
                    .font(.system(size: 12))
                    .foregroundColor(.red)
            }

            Spacer()

            HStack {
                Button(action: {
                    viewModel.addMember(name: newMemberName)
                    newMemberName = ""
                }) {
                    Spacer()
                    Text("Add new member")
                    Spacer()
                }
            }
        }
        .frame(height: 100)
        .onAppear {
            self.didAppear?(self)
        }
    }
}
