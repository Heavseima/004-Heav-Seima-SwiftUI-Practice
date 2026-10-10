import SwiftUI
import ImageIO

struct RecipePhoto: View {
    let name: String
    let height: CGFloat
    @State private var photo: CGImage?

    var body: some View {
        // The geometry reader lets the photo crop without widening its grid column.
        GeometryReader { geometry in
            Group {
                if let photo {
                    Image(decorative: photo, scale: 1)
                        .resizable()
                        .scaledToFill()
                } else {
                    ZStack {
                        MiseTheme.background
                        Image(systemName: "fork.knife")
                            .font(.largeTitle)
                            .foregroundStyle(MiseTheme.secondary)
                    }
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .clipped()
        }
        .frame(height: height)
        .accessibilityHidden(true)
        .task(id: name) {
            photo = nil
            // These are bundled JPEG files, so read them directly instead of using named-image lookup.
            guard let url = Bundle.module.url(forResource: name, withExtension: "jpg"),
                  let source = CGImageSourceCreateWithURL(url as CFURL, nil) else {
                return
            }
            photo = CGImageSourceCreateImageAtIndex(source, 0, nil)
        }
    }
}
