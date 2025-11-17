import SwiftUI

struct CustomSegmentPicker: View {
    @Binding var selectedTab : Int

    var body: some View {
        Picker("", selection: $selectedTab) {
            Text("Files").tag(0)
            Text("Evaluation").tag(1)
        }
        .foregroundStyle(Color.grayTextColor)
        .pickerStyle(.segmented)
        .frame(width: 200, height: 28)
        .padding(6)
        .frame(width: 200, height: 28)
        .background(Color(hex : "E6E6E6"))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(.trailing)
        .foregroundStyle(Color.sectionHeader) // warna text
        .tint(Color(hex : "#E6E6E6"))    // warna segmen yang dipilih
    }
}


#Preview {
    CustomSegmentPicker(selectedTab: .constant(0))
}
