
# Country Explorer App

A Flutter application that allows users to browse a list of countries, search for specific countries, mark favorites, and view detailed country information.

---

## Features

* Browse a list of countries with flags, names, and populations.
* Search countries in a case-insensitive manner.
* Mark/unmark favorite countries.
* Pull-to-refresh to get the latest data.
* Navigate to a detailed screen for each country.
* Smooth UI interactions including Hero animations and keyboard dismissal.

---

## Getting Started

### Prerequisites

* Flutter SDK (>= 3.0.0) installed
* Dart SDK (included with Flutter)
* A device or emulator to run the app

### Setup

1. **Clone the repository**

```bash
git clone https://github.com/your-username/country-explorer.git
cd country-explorer
```

2. **Install dependencies**

```bash
flutter pub get
```

3. **Run the app**

```bash
flutter run
```

---

## Environment Variables

If your app requires API keys or environment-specific configuration, create a `.env` file in the root directory with variables like:

```env
API_BASE_URL=https://example.com/api
```

Then make sure to load them using your preferred package (e.g., `flutter_dotenv`).

---

## Architecture and Technology Choices

* **Flutter**: Chosen for building a cross-platform mobile application with a single codebase.
* **State Management**: `flutter_bloc` is used with `Cubit` for predictable state management and separation of concerns.
* **Repository Pattern**: All country data is fetched through a repository to decouple the data source from UI logic.
* **UI Components**: Built using `ListView`, `RefreshIndicator`, and `TextField` for search functionality.
* **Navigation**: Standard `Navigator` for screen transitions, with Hero animations for flag images.

---

## Folder Structure

```
lib/
 ├─ core/                # Utilities (e.g., formatters)
 ├─ features/
 │   ├─ home/            # Home screen, cubit, and state
 │   ├─ details/         # Detail screen for countries
 │   └─ favorites/       # Favorites screen
 └─ main.dart            # App entry point
```

---
