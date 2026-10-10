# Mise — SwiftUI Recipe App

This project is about practicing SwiftUI fundamentals through a recipe browsing app. The assignment PDF defines the requirements, and the supplied Mise prototype provides the reference for recipe content, photos, colors, and layout.

The app covers two required screens: a recipe grid and a recipe detail screen. Favorites, meal planning, shopping lists, and recipe creation from the larger HTML prototype are outside the assignment scope.

## Features

- A home screen with the current date and “What’s cooking?” heading.
- A two-column grid with eight recipes, local photos, cooking times, and serving counts.
- Live recipe-name search that ignores case and surrounding whitespace, plus a clear button and an empty state.
- Navigation from each recipe card to a scrollable detail screen, with a back button.
- A hero photo, category, description, ingredient list, and numbered method cards.
- Serving controls that start at each recipe's base serving count and never go below one.
- Ingredient quantities that update when the serving count changes, without changing the original recipe data.

The interface follows the reference with a warm cream background, serif headings, rounded photos, and a terracotta accent. The app uses a light appearance, Dynamic Type text styles, accessibility labels, and 44-point touch targets for serving controls.

## Project structure

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

`ContentView` contains the `NavigationStack` and opens the home screen. Repeated interface elements have dedicated views. Models and sample data live in `RecipeCore`, which has no SwiftUI dependency and supports testing the recipe logic on Linux.

`@State` stores the search text and selected servings. `RecipeDetailView` owns the serving count and passes `$servings` to `ServingControl` as an `@Binding`. This lets the child update the parent's state while the ingredient rows refresh automatically.

Ingredient scaling uses the following calculation:

```swift
baseQuantity * Double(selectedServings) / Double(baseServings)
```

For example, the salad's 70 g of rocket for two servings becomes 35 g for one serving or 105 g for three servings. Each calculation starts from the original amount to avoid accumulating rounding errors. Common fractions appear as ¼, ½, and ¾; other amounts display up to two decimal places.

## Building with xtool

The app targets iOS 17 or later. The verified development setup uses Swift 6.4, xtool, and the Darwin Swift SDK. The app has no third-party package dependencies or runtime network services.

Build command from the project folder:

```bash
xtool dev build
```

For Linux environments where FUSE mounting is unavailable, AppImage extraction mode and a writable cache provide an alternative:

```bash
XDG_CACHE_HOME=/tmp/recipe-cache APPIMAGE_EXTRACT_AND_RUN=1 xtool dev build
```

The output is `xtool/recipe_app.app`. A build without signing produces an app bundle; installing on an iPhone also needs xtool's Apple signing setup, a trusted connected device, and Developer Mode enabled.

Device discovery and build, signing, installation, and launch commands:

```bash
APPIMAGE_EXTRACT_AND_RUN=1 xtool devices
XDG_CACHE_HOME=/tmp/recipe-cache APPIMAGE_EXTRACT_AND_RUN=1 xtool dev run --usb
```

An Xcode project can be generated with `xtool dev generate-xcode-project` for development on macOS.

## Testing

Core test command:

```bash
bash Scripts/test-core.sh
```

The script copies the current core sources and tests into a temporary Swift package, runs XCTest, and removes the temporary package afterwards. This avoids trying to compile SwiftUI on Linux. xtool handles the actual iOS app build; this version of xtool does not expose a separate test command.

The five automated tests cover:

- Case-insensitive search with surrounding whitespace.
- Empty searches and searches with no matches.
- Scaling up, scaling down, and keeping the original amounts unchanged.
- Fraction formatting and precise gram amounts.
- Complete sample data, positive quantities, and unique recipe and ingredient IDs.

Verification completed successfully: the iOS debug build passes, all five XCTest tests pass, and the built resource bundle contains all eight photos.

The `xtool dev run --usb` attempt completed the build but stopped during provisioning with Apple’s `403 FORBIDDEN_ERROR` because the signing team had reached its registered-iPhone limit. Installation and on-device UI verification remain pending until an eligible signing team or device registration is available.

### Pending device checks

These checks cover rendered UI behavior that the automated logic tests do not verify.

- [ ] Open the app and confirm all eight cards show the matching photos.
- [ ] Search for `salmon`, clear the search, and try a name with no matches.
- [ ] Open a card, return to the grid, and confirm the search is preserved.
- [ ] Open the salad, change servings from 2 to 1 to 3, and check rocket amounts of 70 g, 35 g, and 105 g.
- [ ] Tap minus at one serving and confirm it remains at one.
- [ ] Open the cannelloni and confirm it starts at four servings.
- [ ] Scroll through every method step on a smaller screen and at larger text sizes.
- [ ] Check VoiceOver labels and confirm the app works without an internet connection.

## Reference material and assets

The supplied SwiftUI assignment PDF defines the requirements. The Mise HTML prototype provides the visual reference and sample recipe content. Its eight embedded photos are bundled locally using SwiftPM resources. The prototype’s image references point to TheMealDB; photo ownership remains with the respective rights holders.

The interface uses system fonts and SF Symbols. Method durations are informational labels without a running timer. Search and serving selections are temporary UI state and are not saved between launches.
