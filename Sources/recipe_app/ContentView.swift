import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            RecipeHomeView()
        }
        .tint(MiseTheme.accent)
        .preferredColorScheme(.light)
    }
}
