import SwiftUI

struct ServingControl: View {
    @Binding var servings: Int

    var body: some View {
        HStack {
            Text("Servings")
            Spacer()
            Button { servings = max(1, servings - 1) } label: {
                Image(systemName: "minus")
                    .frame(width: 44, height: 44)
                    .background(MiseTheme.background, in: Circle())
            }
            .disabled(servings <= 1)
            .accessibilityLabel("Decrease servings")
            Text("\(servings)")
                .font(.body.weight(.semibold).monospacedDigit())
                .frame(minWidth: 28)
                .accessibilityLabel("\(servings) servings")
            Button { servings += 1 } label: {
                Image(systemName: "plus")
                    .frame(width: 44, height: 44)
                    .background(MiseTheme.background, in: Circle())
            }
            .accessibilityLabel("Increase servings")
        }
        .buttonStyle(.plain)
        .padding(12)
        .background(.white, in: RoundedRectangle(cornerRadius: 18))
    }
}
