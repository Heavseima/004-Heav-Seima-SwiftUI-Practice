import SwiftUI
import RecipeCore

struct IngredientRow: View {
    let ingredient: Ingredient
    let servings: Int
    let baseServings: Int

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 16) {
            Text(ingredient.amount(servings: servings, baseServings: baseServings))
                .fontWeight(.medium)
                .foregroundStyle(MiseTheme.accent)
                .frame(minWidth: 64, alignment: .leading)
            Text(ingredient.name)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .font(.subheadline)
        .padding(.horizontal, 16)
        .padding(.vertical, 13)
        .accessibilityElement(children: .combine)
    }
}
