import Foundation

public struct Ingredient: Identifiable, Sendable {
    public let id: Int
    public let name: String
    public let quantity: Double
    public let unit: String

    public func scaledQuantity(servings: Int, baseServings: Int) -> Double {
        // Always scale from the original amount so repeated taps don't introduce rounding errors.
        quantity * Double(max(1, servings)) / Double(max(1, baseServings))
    }

    public func amount(servings: Int, baseServings: Int) -> String {
        let value = scaledQuantity(servings: servings, baseServings: baseServings)
        let whole = Int(value)
        let fraction = value - Double(whole)
        let fractions: [(Double, String)] = [(0.25, "¼"), (0.5, "½"), (0.75, "¾")]
        let number: String
        if let match = fractions.first(where: { abs($0.0 - fraction) < 0.001 }) {
            number = (whole == 0 ? "" : String(whole)) + match.1
        } else {
            number = value.formatted(.number.precision(.fractionLength(0...2)))
        }
        return unit.isEmpty ? number : "\(number) \(unit)"
    }
}
