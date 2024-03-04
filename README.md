<div align="center">
 <h1 align="center" style="font-size: 70px;">Flutter Brazilian Locations From <a href="https://www.linkedin.com/in/guilherme-queiroz-ribeiro-9ab383161/" target="_blank">Guilherme Queiroz</a> </h1>

<!--  Donations -->
 <a href="https://ko-fi.com/guiqueirozribeiro">
  <img width="300" src="https://user-images.githubusercontent.com/26390946/161375567-9e14cd0e-1675-4896-a576-a449b0bcd293.png">
 </a>
 <div align="center">
   <a href="https://ko-fi.com/guiqueirozribeiro">
    <img width="150" alt="buymeacoffee" src="https://user-images.githubusercontent.com/26390946/161375563-69c634fd-89d2-45ac-addd-931b03996b34.png">
  </a>
   <a href="https://ko-fi.com/guiqueirozribeiro">
    <img width="150" alt="Ko-fi" src="https://user-images.githubusercontent.com/26390946/161375565-e7d64410-bbcf-4a28-896b-7514e106478e.png">
  </a>
 </div>
<!--  Donations -->

[![Pub package](https://img.shields.io/pub/v/brazilian_locations.svg)](https://pub.dev/packages/brazilian_locations)
[![GitHub starts](https://img.shields.io/github/stars/GuiQueirozRibeiro/brazilian_locations.svg?style=flat&logo=github&colorB=deeppink&label=stars)](https://github.com/GuiQueirozRibeiro/brazilian_locations)
[![pub package](https://img.shields.io/badge/license-MIT-purple.svg)](https://opensource.org/licenses/MIT)

</div>

Flutter package to display list of States and Cities from Brazil.
Brazilian Locations you can build highly customizable input, that your designers can't even draw in Figma 🤭

## How to Use

To use this Package, add `brazilian_locations` as a [dependency in your pubspec.yaml](https://flutter.io/platform-plugins/).

```dart
  BrazilianLocations(
    showStates: true,
    showCities: true,
    stateDropdownLabel: "State",
    cityDropdownLabel: "City",
    stateSearchPlaceholder: "State",
    citySearchPlaceholder: "City",
    onStateChanged: (value) {
      if (value != null) {
        setState(() => stateValue = value);
      }
    },
    onCityChanged: (value) {
      if (value != null) {
        setState(() => cityValue = value);
      }
    },
  );
```
you will get feedback in onChanged functions

### Parameters

<table>
<thead>
<td><b>Parameters</b></td><td><b>Type</b></td><td><b>Description</b></td></thead>
<tr><td>showStates</td><td>Boolean</td><td> Enable disable States dropdown (true / false)</td></tr>
<tr><td>showCities</td><td>Boolean</td><td> Enable disable Cities dropdown (true / false)</td></tr>
<tr><td>dropdownDecoration</td><td>BoxDecoration</td><td>Dropdown box decoration to style your dropdown selector [OPTIONAL PARAMETER] (USE with disabledDropdownDecoration)</td></tr>
<tr><td>disabledDropdownDecoration</td><td>BoxDecoration</td><td>Disabled Dropdown box decoration to style your dropdown selector [OPTIONAL PARAMETER]  (USE with disabled dropdownDecoration)</td></tr>
<tr><td>selectedItemStyle</td><td>TextStyle</td><td>To change selected item style</td></tr>
<tr><td>dropdownHeadingStyle</td><td>TextStyle</td><td>To change DropdownDialog Heading style</td></tr>
<tr><td>dropdownItemStyle</td><td>TextStyle</td><td>To change DropdownDialog Item style</td></tr>
<tr><td>dropdownDialogRadius</td><td>double</td><td>To change DropdownDialogBox radius</td></tr>
<tr><td>searchBarRadius</td><td>double</td><td>To change search bar radius</td></tr>
<tr><td>stateSearchPlaceholder</td><td>String</td><td>Placeholder for state search field</td></tr>
<tr><td>citySearchPlaceholder</td><td>String</td><td>Placeholder for city search field</td></tr>
<tr><td>stateDropdownLabel</td><td>String</td><td>Label/Title for state dropdown</td></tr>
<tr><td>cityDropdownLabel</td><td>String</td><td>Label/Title for city dropdown</td></tr>
</table>

## Support

[Guilherme Queiroz Ribeiro](https://github.com/GuiQueirozRibeiro)

Don't forget to give it a star ⭐
