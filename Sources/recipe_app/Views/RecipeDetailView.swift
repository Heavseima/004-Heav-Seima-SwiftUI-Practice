import SwiftUI
import RecipeCore

struct RecipeDetailView: View {
    let recipe: Recipe
    @Environment(\.dismiss) private var dismiss
    @State private var servings: Int

    init(recipe: Recipe) {
        self.recipe = recipe
        _servings = State(initialValue: recipe.baseServings)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                RecipePhoto(name: recipe.id, height: 260)
                VStack(alignment: .leading, spacing: 24) {
                    introduction
                    VStack(alignment: .leading, spacing: 8) {
                        ServingControl(servings: $servings)
                        Text("Recipe serves \(recipe.baseServings) · amounts scaled ×\(scaleLabel)")
                            .font(.caption)
                            .foregroundStyle(MiseTheme.secondary)
                            .padding(.horizontal, 4)
                    }
                    ingredients
                    VStack(alignment: .leading, spacing: 10) {
                        sectionTitle("Method")
                        ForEach(recipe.steps) { step in
                            MethodStepCard(step: step)
                        }
                    }
                }
                .padding(20)
                .background(MiseTheme.background, in: UnevenRoundedRectangle(
                    topLeadingRadius: 24, topTrailingRadius: 24
                ))
                // A small overlap softens the transition from the photo to the recipe.
                .padding(.top, -24)
            }
            .frame(maxWidth: 680)
            .frame(maxWidth: .infinity)
        }
        .background(MiseTheme.background)
        .foregroundStyle(MiseTheme.ink)
        .toolbar(.hidden, for: .navigationBar)
        .safeAreaInset(edge: .top, spacing: 0) {
            HStack {
                Button { dismiss() } label: {
                    Label("Recipes", systemImage: "chevron.left")
                        .font(.subheadline.weight(.semibold))
                        .frame(minHeight: 44)
                }
                .accessibilityLabel("Back to recipes")
                Spacer()
                Text("MISE")
                    .font(.caption.weight(.semibold))
                    .tracking(3)
                    .foregroundStyle(MiseTheme.secondary)
            }
            .padding(.horizontal, 20)
            .background(MiseTheme.background)
        }
    }

    private var scaleLabel: String {
        (Double(servings) / Double(recipe.baseServings))
            .formatted(.number.precision(.fractionLength(0...2)))
    }

    private var introduction: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 12) {
                Text(recipe.category.uppercased())
                    .tracking(1)
                    .foregroundStyle(MiseTheme.accent)
                Label("\(recipe.minutes) min", systemImage: "clock")
                    .foregroundStyle(MiseTheme.secondary)
            }
            .font(.caption.weight(.medium))
            Text(recipe.name)
                .font(.system(.title, design: .serif, weight: .semibold))
                .accessibilityAddTraits(.isHeader)
            Text(recipe.description)
                .font(.subheadline)
                .foregroundStyle(MiseTheme.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private var ingredients: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                sectionTitle("Ingredients")
                Spacer()
                Text("\(recipe.ingredients.count) items")
                    .font(.caption)
                    .foregroundStyle(MiseTheme.secondary)
            }
            VStack(spacing: 0) {
                ForEach(recipe.ingredients) { ingredient in
                    IngredientRow(ingredient: ingredient, servings: servings, baseServings: recipe.baseServings)
                    if ingredient.id != recipe.ingredients.last?.id {
                        Divider().padding(.leading, 16)
                    }
                }
            }
            .background(.white, in: RoundedRectangle(cornerRadius: 18))
        }
    }

    private func sectionTitle(_ title: String) -> some View {
        Text(title)
            .font(.headline)
            .accessibilityAddTraits(.isHeader)
    }
}
