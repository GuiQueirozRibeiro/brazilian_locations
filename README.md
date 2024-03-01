<div align="center">
 <h1 align="center" style="font-size: 70px;">Flutter Brazilian Locations From <a href="https://www.linkedin.com/in/guilherme-queiroz-ribeiro-9ab383161/" target="_blank">Guilherme Queiroz</a> </h1>

[![Pub package](https://img.shields.io/pub/v/brazilian_locations.svg)](https://pub.dev/packages/brazilian_locations)
[![pub package](https://img.shields.io/badge/license-MIT-purple.svg)](https://opensource.org/licenses/MIT)

</div>

Flutter package to display list of States and Cities from Brazil.
Brazilian Locations you can build highly customizable input, that your designers can't even draw in Figma 🤭

## Support

[Example](https://github.com/GuiQueirozRibeiro/brazilian_locations)

Don't forget to give it a star ⭐

## Create instance of Brazilian Locations

```dart
  final brazilianLocations = BrazilianLocations();
```

## Get the list of Brazilian States

```dart
  void getStatesList() async {
    final statesList = await brazilianLocations.getStates();
    debugPrint('States List: $statesList');
  }
```

## Get the list of Cities for a specific State

```dart
  void getCitiesList() async {
    final citiesList = await brazilianLocations.getCities(stateId: "01"); // Replace 01 with the desired State ID
    debugPrint('Cities List: $citiesList');
  }
```
