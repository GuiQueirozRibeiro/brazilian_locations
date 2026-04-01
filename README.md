# Brazilian Locations

[![Pub](https://img.shields.io/pub/v/brazilian_locations.svg)](https://pub.dev/packages/brazilian_locations)
[![GitHub Stars](https://img.shields.io/github/stars/GuiQueirozRibeiro/brazilian_locations)](https://github.com/GuiQueirozRibeiro/brazilian_locations)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

A Flutter package providing searchable state/city dropdowns for Brazil, backed by the official IBGE API with 7-day Hive caching.

**Platforms:** Android · iOS · macOS · Linux · Windows · Web

---

## Installation

```yaml
dependencies:
  brazilian_locations: ^3.4.1
```

---

## Quick Start

```dart
BrazilianLocations(
  showStates: true,
  showCities: true,
  onStateChanged: (state) => print(state), // e.g. "SP"
  onCityChanged: (city) => print(city),    // e.g. "São Paulo"
)
```

### Optional: Pre-load data at startup

Call `initialize()` before `runApp` to avoid a loading delay on first use:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await BrazilianLocations.initialize();
  runApp(const MyApp());
}
```

---

## Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `showStates` | `bool` | Show the state dropdown |
| `showCities` | `bool` | Show the city dropdown (requires `showStates: true`) |
| `showClearButton` | `bool` | Show a button to reset selections |
| `showDropdownLabel` | `bool` | Show label above each dropdown |
| `currentState` | `String?` | Pre-selected state value (UF code) |
| `currentCity` | `String?` | Pre-selected city value |
| `onStateChanged` | `Function(String?)` | Callback when state selection changes |
| `onCityChanged` | `Function(String?)` | Callback when city selection changes |
| `stateDropdownLabel` | `String` | Label text for state dropdown |
| `cityDropdownLabel` | `String` | Label text for city dropdown |
| `stateSearchPlaceholder` | `String` | Search hint in state dialog |
| `citySearchPlaceholder` | `String` | Search hint in city dialog |
| `dropdownDecoration` | `BoxDecoration` | Style for enabled dropdown |
| `disabledDropdownDecoration` | `BoxDecoration` | Style when dropdown is disabled |
| `dropdownInputDecoration` | `InputDecoration` | Override input decoration |
| `selectedItemStyle` | `TextStyle` | Style for the selected value text |
| `dropdownHeadingStyle` | `TextStyle` | Style for the dialog heading |
| `dropdownItemStyle` | `TextStyle` | Style for list items in dialog |
| `dropdownLabelStyle` | `TextStyle` | Style for the label above dropdown |
| `dropdownDialogRadius` | `double` | Corner radius of the search dialog |
| `searchBarRadius` | `double` | Corner radius of the search field |
| `dropdownPadding` | `EdgeInsets?` | Padding inside the dropdown |
| `customIcon` | `Widget?` | Replace the default dropdown arrow |
| `clearButtonContent` | `Widget?` | Custom clear button widget |
| `clearButtonDecoration` | `BoxDecoration?` | Style for clear button |

---

## Caching

Data is fetched from the [IBGE Districts API](https://servicodados.ibge.gov.br/api/v1/localidades/distritos) and stored locally with Hive for **7 days**. On subsequent launches the widget loads instantly from cache. If the API is unreachable, the existing cache is used as a fallback.

---

## Development

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs  # regenerate Hive adapters
flutter analyze
flutter test
```

To publish a new version:
1. Bump `version` in `pubspec.yaml`
2. Add entry to `CHANGELOG.md`
3. Run `flutter pub publish`

---

## License

MIT © [Guilherme Queiroz Ribeiro](https://github.com/GuiQueirozRibeiro)
