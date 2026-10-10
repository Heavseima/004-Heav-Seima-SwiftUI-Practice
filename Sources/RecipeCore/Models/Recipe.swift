import Foundation

public struct Recipe: Identifiable, Sendable {
    public let id: String
    public let name: String
    public let category: String
    public let minutes: Int
    public let baseServings: Int
    public let description: String
    public let ingredients: [Ingredient]
    public let steps: [MethodStep]

    public static func search(_ recipes: [Recipe], for text: String) -> [Recipe] {
        let query = text.trimmingCharacters(in: .whitespacesAndNewlines)
        return query.isEmpty ? recipes : recipes.filter {
            $0.name.localizedStandardContains(query)
        }
    }
}
