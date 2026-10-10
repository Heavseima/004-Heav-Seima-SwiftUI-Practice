import SwiftUI
import RecipeCore

struct RecipeHomeView: View {
    @State private var searchText = ""
    private let columns = [GridItem(.flexible(), alignment: .top), GridItem(.flexible(), alignment: .top)]

    private var filteredRecipes: [Recipe] {
        Recipe.search(SampleRecipes.all, for: searchText)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                header
                searchField
                if filteredRecipes.isEmpty {
                    ContentUnavailableView {
                        Label("No recipes found", systemImage: "magnifyingglass")
                    } description: {
                        Text("Try another recipe name, or clear your search.")
                    } actions: {
                        Button("Clear search") { searchText = "" }
                    }
                } else {
                    LazyVGrid(columns: columns, alignment: .leading, spacing: 20) {
                        ForEach(filteredRecipes) { recipe in
                            NavigationLink {
                                RecipeDetailView(recipe: recipe)
                            } label: {
                                RecipeCard(recipe: recipe)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
            .padding(20)
            .frame(maxWidth: 680)
            .frame(maxWidth: .infinity)
        }
        .background(MiseTheme.background)
        .toolbar(.hidden, for: .navigationBar)
        .scrollDismissesKeyboard(.interactively)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(Date.now.formatted(.dateTime.weekday(.wide).month(.abbreviated).day()).uppercased())
                .font(.caption.weight(.semibold))
                .tracking(0.8)
                .foregroundStyle(MiseTheme.secondary)
            Text("What’s cooking?")
                .font(.system(.largeTitle, design: .serif, weight: .semibold))
                .foregroundStyle(MiseTheme.ink)
                .accessibilityAddTraits(.isHeader)
        }
    }

    private var searchField: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(MiseTheme.secondary)
            TextField("Search recipes", text: $searchText)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .submitLabel(.search)
                .accessibilityLabel("Search recipes by name")
            if !searchText.isEmpty {
                Button { searchText = "" } label: {
                    Image(systemName: "xmark.circle.fill")
                        .frame(width: 44, height: 44)
                }
                .accessibilityLabel("Clear search")
            }
        }
        .padding(.horizontal, 12)
        .frame(minHeight: 44)
        .background(.black.opacity(0.055), in: RoundedRectangle(cornerRadius: 12))
    }
}
