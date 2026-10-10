import SwiftUI
import RecipeCore

struct MethodStepCard: View {
    let step: MethodStep

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Text("\(step.id)")
                .font(.caption.weight(.semibold))
                .foregroundStyle(MiseTheme.accent)
                .frame(width: 28, height: 28)
                .background(MiseTheme.accent.opacity(0.09), in: Circle())
            VStack(alignment: .leading, spacing: 8) {
                Text(step.instruction)
                    .font(.subheadline)
                    .fixedSize(horizontal: false, vertical: true)
                if step.seconds > 0 {
                    Label("\(step.seconds / 60) min", systemImage: "clock")
                        .font(.caption)
                        .foregroundStyle(MiseTheme.secondary)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(16)
        .background(.white, in: RoundedRectangle(cornerRadius: 18))
        .accessibilityElement(children: .combine)
    }
}
