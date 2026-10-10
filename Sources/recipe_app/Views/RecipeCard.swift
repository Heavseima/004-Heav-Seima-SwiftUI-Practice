import SwiftUI
import RecipeCore

struct RecipeCard: View {
    let recipe: Recipe

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            RecipePhoto(name: recipe.id, height: 148)
                .clipShape(RoundedRectangle(cornerRadius: 18))
            Text(recipe.name)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(MiseTheme.ink)
                .fixedSize(horizontal: false, vertical: true)
            Text("\(recipe.minutes) min · Serves \(recipe.baseServings)")
                .font(.caption)
                .foregroundStyle(MiseTheme.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .accessibilityElement(children: .combine)
    }
}
