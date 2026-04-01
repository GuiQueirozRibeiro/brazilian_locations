# Blueprint — brazilian_locations

## Purpose

Published Flutter plugin package (`pub.dev/packages/brazilian_locations`) providing state and city selection dropdowns for Brazil. Data source is the official IBGE Districts API, cached locally with Hive for 7 days.

## Current Version

`3.4.1` (August 2025)

## Goals

- Zero-config usage: drop in `BrazilianLocations(...)` and it works
- Offline resilience: stale cache serves as fallback when API is unreachable
- Full customization: every visual aspect is overridable via constructor params
- Cross-platform: Android, iOS, macOS, Linux, Windows, Web

## Non-Goals

- Does not validate or restrict selections to real state/city combinations beyond what IBGE returns
- Does not support address input beyond state + city (no CEP, street, etc.)
- Platform channels contain no real logic — this is a pure-Dart package

## Architecture Summary

```
Widget layer        BrazilianLocations → DropdownWithSearch → SearchDialog
Service layer       CacheService (Hive + IBGE HTTP)
Model layer         Location (state UF + city name), CacheData (locations + timestamp)
```

## Key Design Decisions

| Decision | Reason |
|----------|--------|
| Hive for caching | Works on all 6 platforms including Web without native dependencies |
| 7-day cache TTL | Balances freshness with offline reliability; IBGE data changes infrequently |
| Per-item try/catch in API parser | One malformed district record must not crash the entire dataset |
| 15s HTTP timeout | Avoids indefinite hang on slow connections; falls back to cache |
| Stateless `DropdownWithSearch` | All state is owned by `BrazilianLocations`; makes the component reusable |
| UF codes (not full state names) | Matches common form field conventions in Brazilian systems |

## File Map

```
lib/
├── brazilian_locations.dart          ← public export (only this file is imported by consumers)
├── brazilian_locations_web.dart      ← web plugin stub
└── src/
    ├── models/
    │   ├── location.dart             ← @HiveType(typeId: 0)
    │   ├── location.g.dart           ← generated
    │   ├── cache_data.dart           ← @HiveType(typeId: 1)
    │   └── cache_data.g.dart         ← generated
    ├── services/
    │   └── cache_service.dart        ← all data loading logic lives here
    └── widgets/
        ├── brazilian_locations.dart  ← main public widget
        └── dropdown_search.dart      ← DropdownWithSearch + SearchDialog + CustomDialog
```

## Maintenance Checklist

When updating the package:
- [ ] Bump version in `pubspec.yaml`
- [ ] Update `CHANGELOG.md`
- [ ] Run `dart run build_runner build --delete-conflicting-outputs` if models changed
- [ ] Run `flutter analyze` — must pass clean
- [ ] Test on at least one platform (the example app)
- [ ] `flutter pub publish`
