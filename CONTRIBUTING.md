# Contributing — brazilian_locations

## Setup

```bash
git clone https://github.com/GuiQueirozRibeiro/brazilian_locations
cd brazilian_locations
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

Run the example app:

```bash
cd example
flutter pub get
flutter run
```

---

## Making Changes

### Changing Hive models

After modifying `Location` or `CacheData` in `lib/src/models/`, regenerate adapters:

```bash
dart run build_runner build --delete-conflicting-outputs
```

Commit the generated `.g.dart` files.

### Adding a widget parameter

1. Add the field to `BrazilianLocations` constructor
2. Pass it down to `DropdownWithSearch` or `SearchDialog` as needed
3. Update the parameters table in `README.md`

### Changing API parsing

Edit `CacheService.fetchAndCacheData()` in `lib/src/services/cache_service.dart`. The IBGE endpoint returns a flat array of districts; state UF is nested at `item.municipio.microrregiao.mesorregiao.UF.sigla`.

---

## Code Quality

```bash
flutter analyze       # must pass with zero issues
dart format .         # auto-format before committing
flutter test          # run tests
```

---

## Releasing

1. Bump `version` in `pubspec.yaml` (semantic versioning)
2. Add a section to `CHANGELOG.md` with date and summary
3. Commit: `git commit -m "chore: release vX.Y.Z"`
4. Tag: `git tag vX.Y.Z && git push --tags`
5. Publish: `flutter pub publish`

Pub.dev performs a dry-run automatically on `publish` — fix any warnings before confirming.
