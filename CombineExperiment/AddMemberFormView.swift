import SwiftUI

class AddMemberFormViewModel {
    private let memberManager: MemberManager

    init(memberManager: MemberManager) {
        self.memberManager = memberManager
    }

    convenience init() {
        self.init(
            memberManager: DefaultMemberManager.shared
        )
    }

    func addMember(name: String) {
        memberManager.addMember(name: name)
    }
}

struct AddMemberFormView: View {
    private let viewModel: AddMemberFormViewModel
    @State private var newMemberName: String = ""

    init(viewModel: AddMemberFormViewModel) {
        self.viewModel = viewModel
    }

    init() {
        self.init(viewModel: AddMemberFormViewModel())
    }

    var body: some View {
        VStack {
            TextField("New member name", text: $newMemberName)
                .tag("newMemberName")
                .padding(.bottom, 16)

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
    }
}
