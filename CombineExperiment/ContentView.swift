import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(alignment: .leading) {
            MembersSummaryView()
                .padding(.bottom, 24)

            AddMemberFormView()
                .padding(.bottom, 48)

            MembersView()

            Spacer()
        }
        .padding(8)
    }
}
