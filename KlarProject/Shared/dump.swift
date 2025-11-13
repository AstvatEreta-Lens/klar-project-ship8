//if let profile = currentProfile {
//    VStack(alignment: .leading, spacing: 16) {
//        HStack {
//            Text("Profile")
//                .foregroundColor(Color.primaryText)
//            Spacer()
//            profilePicker
//        }
//        
//        
//private var profilePicker: some View {
//    Menu {
//        ForEach(viewModel.userProfiles.indices, id: \.self) { index in
//            Button {
//                selectedProfileIndex = index
//            } label: {
//                Text(viewModel.userProfiles[index].username)
//            }
//        }
//    } label: {
//        HStack(spacing: 8) {
//            Text(currentProfile?.username ?? "Select user")
//                .foregroundColor(Color.primaryText)
//            Image(systemName: "chevron.down")
//                .font(.caption)
//        }
//        .padding(.horizontal, 12)
//        .padding(.vertical, 8)
//        .background(
//            Capsule()
//                .fill(Color.sectionHeader.opacity(0.15))
//        )
//    }
//}
//
//    VStack(spacing: 12) {
//        Text("No account data found.")
//            .foregroundColor(.secondary)
//        Button("Reload") {
//            selectedProfileIndex = 0
//        }
//    }
//    .frame(maxWidth: .infinity, alignment: .center)
