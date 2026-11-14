# Movie Tracker

Movie Tracker is a Flutter mobile app that lets users discover movies, keep a
watch journal with ratings and reviews, build watchlists and shared lists with
voting, follow actors, get recommendations and chat in a moderated forum.

Movie Tracker est une application mobile Flutter pour découvrir des films, tenir
un journal de visionnage, composer des listes (seul ou à plusieurs) et échanger
avec une communauté de cinéphiles.

## Features

| Module | Content |
|---|---|
| 1. Users | Sign up / sign in, public profile, settings (theme, language, country), stats dashboard, shareable yearly recap |
| 2. Catalog | Home with featured movies, search with infinite scroll, filters, genres, movie details, where to watch, search history |
| 3. Journal | Mark as watched, ratings (0.5 to 5), reviews, spoiler tag, community reviews, calendar, rewatch counter |
| 4. Lists | To watch and favorites, custom lists, shared lists with invitation and votes, "What to watch tonight?" picker |
| 5. People | Cast and actor pages, follow actors, personalized recommendations |
| 6. Forum | Topics and replies, likes, reports, moderation queue (moderators only), anti-spam |

## Design

Cinema theme inspired by Pathé: cinema red `#E30613` on near-black `#111114`.
All colors come from one palette file (`lib/core/theme/app_palette.dart`), with
a dark theme by default and an optional light theme. Fonts: Poppins (titles)
and Inter (text).

## Tech stack

- Flutter 3.x / Dart
- State management: flutter_riverpod
- Navigation: go_router (ShellRoute with a 5-tab bottom bar)
- Charts: fl_chart · Sharing: share_plus · Images: cached_network_image
- Tests: flutter_test, mocktail
- Data: in-memory fake repositories (movies, actors, users, reviews, lists, forum).
  Firebase and the TMDB API are planned for the integration sprint.

## Architecture

Feature-based architecture. Modules communicate only through public interfaces
in `lib/shared/contracts`.

```
lib/
  core/               theme, router, shared widgets, utilities
  shared/contracts/   public interfaces of the 6 modules
  features/
    users/ catalog/ journal/ lists/ people/ forum/   (presentation, domain, data)
test/                 unit tests of the business logic
```

## Run the project

```bash
flutter pub get
flutter analyze
flutter test
flutter run
```

To run on Chrome: `flutter run -d chrome`.

The TMDB key must never be written in the code. When the integration starts:

```bash
flutter run --dart-define=TMDB_API_KEY=your_key
```

This product uses the TMDB API but is not endorsed or certified by TMDB.
Streaming availability data is provided by JustWatch.

## Team

Project by a team of 6 students, one module per member.
