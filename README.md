# Mise — My SwiftUI Recipe App

I built this project for my SwiftUI fundamentals recipe UI assignment. I used the assignment PDF to decide what to implement and the supplied Mise prototype as my reference for the recipe content, photos, colors, and layout.

I focused on the two required screens: browsing recipes and viewing a recipe's details. The larger HTML prototype also contains favorites, planning, shopping, and recipe creation; I kept those outside this assignment's scope.

## What I implemented

- A home screen with the current date and “What’s cooking?” heading.
- A two-column grid with eight recipes, local photos, cooking times, and serving counts.
- Live recipe-name search that ignores case and surrounding whitespace, plus a clear button and an empty state.
- Navigation from each recipe card to a scrollable detail screen, with a back button.
- A hero photo, category, description, ingredient list, and numbered method cards.
- Serving controls that start at each recipe's base serving count and never go below one.
- Ingredient quantities that update when I change the servings, without changing the original recipe data.

I used a warm cream background, serif headings, rounded photos, and a terracotta accent to stay close to the reference. I kept the light appearance intentional. My text uses Dynamic Type styles, the controls have accessibility labels, and the serving buttons have 44-point touch targets.

## How I organized the code

```text
Sources/
├── RecipeCore/
│   ├── Models/
│   │   ├── Recipe.swift
│   │   ├── Ingredient.swift
│   │   └── MethodStep.swift
│   └── Data/SampleRecipes.swift
└── recipe_app/
    ├── recipe_appApp.swift
    ├── ContentView.swift
    ├── Resources/                 # Eight bundled JPEG photos
    └── Views/
        ├── RecipeHomeView.swift
        ├── RecipeCard.swift
        ├── RecipeDetailView.swift
        ├── ServingControl.swift
        ├── IngredientRow.swift
        ├── MethodStepCard.swift
        ├── RecipePhoto.swift
        └── MiseTheme.swift
Tests/RecipeCoreTests/RecipeCoreTests.swift
Scripts/test-core.sh
Package.swift
xtool.yml
```

I kept `ContentView` small: it owns the `NavigationStack` and opens the home screen. Each repeated part of the interface has its own view. I put the models and sample data in `RecipeCore`, which has no SwiftUI dependency, so I can test the recipe logic on Linux.

I use `@State` for the search text and selected servings. `RecipeDetailView` owns the serving count and passes `$servings` to `ServingControl` as an `@Binding`. This lets the child update the parent's state while the ingredient rows refresh automatically.

My scaling calculation is:

```swift
baseQuantity * Double(selectedServings) / Double(baseServings)
```

For example, the salad's 70 g of rocket for two people becomes 35 g for one person or 105 g for three. I calculate from the original amount every time, so changing servings repeatedly does not accumulate rounding errors. I display common fractions as ¼, ½, and ¾, and other amounts with up to two decimal places.

## Building with xtool

I target iOS 17 or later. My development setup uses Swift 6.4, xtool, and the installed Darwin Swift SDK. I don't need any third-party packages or network services inside the app.

From the project folder, I build with:

```bash
xtool dev build
```

On my Linux setup, the AppImage cannot mount through FUSE, so I use its extraction mode and a writable cache:

```bash
XDG_CACHE_HOME=/tmp/recipe-cache APPIMAGE_EXTRACT_AND_RUN=1 xtool dev build
```

The output is `xtool/recipe_app.app`. A build without signing produces an app bundle; installing on an iPhone also needs xtool's Apple signing setup, a trusted connected device, and Developer Mode enabled.

I use these commands to check the device and build, sign, install, and launch:

```bash
APPIMAGE_EXTRACT_AND_RUN=1 xtool devices
XDG_CACHE_HOME=/tmp/recipe-cache APPIMAGE_EXTRACT_AND_RUN=1 xtool dev run --usb
```

If I need an Xcode project on a Mac, I can generate one with `xtool dev generate-xcode-project`.

## Testing

I run my core tests with:

```bash
bash Scripts/test-core.sh
```

The script copies the current core sources and tests into a temporary Swift package, runs XCTest, and removes the temporary package afterwards. This avoids trying to compile SwiftUI on Linux. xtool handles the actual iOS app build; this version of xtool does not expose a separate test command.

My five automated tests cover:

- Case-insensitive search with surrounding whitespace.
- Empty searches and searches with no matches.
- Scaling up, scaling down, and keeping the original amounts unchanged.
- Fraction formatting and precise gram amounts.
- Complete sample data, positive quantities, and unique recipe and ingredient IDs.

I verified that the iOS debug build succeeds and all five XCTest tests pass. I also checked that all eight photos are included in the built resource bundle.

I attempted `xtool dev run --usb` on the connected iPhone. The build succeeded, but Apple returned `403 FORBIDDEN_ERROR` during provisioning: “Your development team has reached the maximum number of registered iPhone devices.” I could not finish installation or verify the UI on the phone. Before I retry, I need an eligible signing team or an available device registration resolved through my Apple Developer account.

### My device review checklist

I keep the following checks separate from the automated tests; the unit tests do not prove that the rendered UI is correct.

- [ ] Open the app and confirm all eight cards show the matching photos.
- [ ] Search for `salmon`, clear the search, and try a name with no matches.
- [ ] Open a card, return to the grid, and confirm the search is preserved.
- [ ] Open the salad, change servings from 2 to 1 to 3, and check rocket amounts of 70 g, 35 g, and 105 g.
- [ ] Tap minus at one serving and confirm it remains at one.
- [ ] Open the cannelloni and confirm it starts at four servings.
- [ ] Scroll through every method step on a smaller screen and at larger text sizes.
- [ ] Check VoiceOver labels and confirm the app works without an internet connection.

## Reference material and assets

I used `Seima Heav - SwiftUI_Fundamentals_Recipe_UI_Assignment.pdf` for the requirements and `Seima Heav - Mise Prototype.html` for the visual reference and sample recipe content. I extracted the eight embedded photos from the supplied prototype and bundled them locally using SwiftPM resources. The prototype's image references point to TheMealDB. I do not claim ownership of those photos.

I use system fonts and SF Symbols. Method durations are informational labels; I did not add a running timer. Search and serving selections are temporary UI state and are not saved between launches.
