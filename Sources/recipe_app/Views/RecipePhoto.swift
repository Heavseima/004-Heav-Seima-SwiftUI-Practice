import SwiftUI

struct RecipePhoto: View {
    let name: String
    let height: CGFloat

    var body: some View {
        // The geometry reader lets the photo crop without widening its grid column.
        GeometryReader { geometry in
            Image(name + ".jpg", bundle: .module)
                .resizable()
                .scaledToFill()
                .frame(width: geometry.size.width, height: geometry.size.height)
                .clipped()
        }
        .frame(height: height)
        .accessibilityHidden(true)
    }
}
