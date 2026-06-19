# Swim Success — Flutter App

A Flutter application built as a test task. The app consists of two screens: a Pace Selector for swimmers and a User List with detail navigation.

---

## Swimmer Level Ranges

| Level | 100m Time |
|-------|-----------|
| Elite | < 1:10 (< 70 sec) |
| Advanced | 1:10 – 1:29 (70–89 sec) |
| Intermediate | 1:30 – 1:59 (90–119 sec) |
| Beginner | ≥ 2:00 (≥ 120 sec) |

These ranges are approximate — loosely based on competitive vs recreational swimming benchmarks. The focus is on demonstrating dynamic UI updates rather than precise sports science.

---

## State Management: Riverpod

I chose **flutter_riverpod** for the following reasons:

- **No BuildContext required** — providers can be read and mutated from anywhere, making repository and notifier logic cleanly separated from widgets.
- **AsyncValue** — built-in pattern for handling `loading / data / error` states without manual `isLoading` booleans. Especially clean for the user list screen.
- **Code generation (riverpod_generator)** — reduces boilerplate and makes the intent of each provider explicit.
- **Testability** — providers can be overridden in tests trivially with `ProviderContainer` or `WidgetRef` overrides.

Alternatives considered:
- **Bloc/Cubit** — more verbose for this scale, better suited for complex event-driven flows.
- **Provider** — simpler but lacks `AsyncValue` ergonomics and requires `ChangeNotifier`.
- **GetX** — bypasses standard Flutter lifecycle patterns and relies on implicit global state, making dependency lifetimes harder to track and debug.

---

## Project Structure

```
lib/
├── main.dart                  # App entry point, ProviderScope
├── core/
│   ├── constants/
│   │   ├── app_colors.dart    # Design tokens
│   │   └── swimmer_levels.dart
│   ├── network/
│   │   └── dio_client.dart    # Configured Dio instance (provider)
│   ├── router/
│   │   └── app_router.dart    # GoRouter configuration
│   ├── theme/
│   │   ├── app_theme.dart     # Light/Dark Theme configuration
│   │   └── theme_provider.dart# Theme mode state notifier
│   ├── utils/
│   │   └── error_handler.dart # Localized error helper
│   └── widgets/               # Shared cross-feature widgets
│       ├── common_app_bar.dart
│       ├── config_error_app.dart # English config error recovery screen
│       ├── language_selector_dropdown.dart
│       ├── navigation_shell_screen.dart
│       ├── theme_toggle_button.dart
│       └── top_notification.dart
└── features/
    ├── pace_selector/
    │   ├── data/
    │   │   └── pace_repository.dart
    │   ├── domain/
    │   │   └── swimmer_level.dart   # Pure logic, no Flutter deps
    │   └── presentation/
    │       ├── pace_selector_screen.dart
    │       ├── notifiers/
    │       │   └── pace_notifier.dart
    │       └── widgets/
    │           ├── time_display.dart
    │           ├── pace_slider.dart
    │           └── level_badge.dart
    └── user_list/
        ├── data/
        │   ├── user_repository.dart
        │   └── models/
        │       ├── user.dart
        │       ├── address.dart
        │       └── company.dart
        └── presentation/
            ├── user_list_screen.dart
            ├── user_detail_screen.dart
            ├── notifiers/
            │   └── user_list_notifier.dart
            └── widgets/
                ├── user_card.dart
                └── search_bar_widget.dart
```

**Key principle:** each feature is self-contained. `domain/` holds pure Dart logic with no Flutter imports. `data/` handles API and parsing. `presentation/` is UI-only.

---

## Testing

The project is equipped with robust unit and widget tests using **mocktail**:

- **Domain Model Tests**: Verifies that `SwimmerLevel.fromSeconds` maps ranges correctly to levels.
- **State Notifier Tests**: Verifies initial state, strict clamping logic for minutes/seconds updates, slider synchronization, and API submission status transitions (loading, success, error).
- **Widget Tests**: Verifies that the `TimeDisplay` widget renders translation keys and digit values correctly using a mock localization loader.



---

## What I Would Do Differently With More Time

1. **Rich Sealed Error Hierarchy** — while we added a centralized `ErrorHandler` utility to translate Dio and connectivity exceptions, we could expand this to a full sealed class hierarchy (e.g. `AppError`) to explicitly type-check specific response statuses or payload messages.

2. **Offline caching** — store the user list locally (e.g. with `drift` or `hive`) and show stale data while refreshing, rather than a spinner on every launch.

3. **Animations** — a subtle wave animation on the Pace Selector screen as a thematic touch, and a shared-element hero transition between the list card and detail screen.

4. **CI/CD pipeline** — a `.github/workflows/flutter.yml` that runs `flutter analyze` and `flutter test` automatically on every pull request.

---

## Getting Started

To run the project locally, make sure to set up the environment variables:

1. Copy the `.env_example` template to create your `.env` file:
   ```bash
   copy .env_example .env
   ```
2. Open the newly created `.env` file and configure any necessary keys.
3. Run the app:
   ```bash
   flutter run
   ```


