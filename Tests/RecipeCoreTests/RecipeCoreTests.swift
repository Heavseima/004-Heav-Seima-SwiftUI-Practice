import XCTest
@testable import RecipeCore

final class RecipeCoreTests: XCTestCase {
    func testSearchIgnoresCaseAndSurroundingWhitespace() {
        let results = Recipe.search(SampleRecipes.all, for: "  SALMON \n")
        XCTAssertEqual(Set(results.map(\.id)), ["benedict", "salad", "teriyaki"])
    }

    func testEmptySearchReturnsAllRecipesAndUnknownSearchReturnsNone() {
        XCTAssertEqual(Recipe.search(SampleRecipes.all, for: "  ").count, 8)
        XCTAssertTrue(Recipe.search(SampleRecipes.all, for: "no such recipe").isEmpty)
    }

    func testScalingKeepsOriginalAmountsAndSupportsSingleServings() {
        let ingredient = SampleRecipes.all.first { $0.id == "salad" }!.ingredients[2]
        XCTAssertEqual(ingredient.scaledQuantity(servings: 1, baseServings: 2), 35)
        XCTAssertEqual(ingredient.scaledQuantity(servings: 3, baseServings: 2), 105)
        XCTAssertEqual(ingredient.scaledQuantity(servings: 2, baseServings: 2), 70)
        XCTAssertEqual(ingredient.quantity, 70)
    }

    func testFractionFormattingDoesNotRoundGramsToTens() {
        let avocado = Ingredient(id: 0, name: "avocado", quantity: 1, unit: "")
        XCTAssertEqual(avocado.amount(servings: 1, baseServings: 2), "½")
        XCTAssertEqual(avocado.amount(servings: 3, baseServings: 2), "1½")
        let spinach = Ingredient(id: 1, name: "spinach", quantity: 300, unit: "g")
        XCTAssertEqual(spinach.amount(servings: 1, baseServings: 4), "75 g")
    }

    func testSampleRecipesHaveCompleteContentAndStableIDs() {
        XCTAssertEqual(Set(SampleRecipes.all.map(\.id)).count, 8)
        for recipe in SampleRecipes.all {
            XCTAssertGreaterThan(recipe.baseServings, 0)
            XCTAssertGreaterThan(recipe.minutes, 0)
            XCTAssertFalse(recipe.description.isEmpty)
            XCTAssertFalse(recipe.ingredients.isEmpty)
            XCTAssertFalse(recipe.steps.isEmpty)
            XCTAssertEqual(recipe.steps.map(\.id), Array(1...recipe.steps.count))
            XCTAssertEqual(Set(recipe.ingredients.map(\.id)).count, recipe.ingredients.count)
            XCTAssertTrue(recipe.ingredients.allSatisfy { $0.quantity > 0 })
        }
    }
}
