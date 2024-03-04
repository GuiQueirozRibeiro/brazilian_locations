import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'dropdown_search.dart';

/// A widget for selecting Brazilian locations.
class BrazilianLocations extends StatefulWidget {
  /// Callback for state selection change.
  final ValueChanged<String?>? onStateChanged;

  /// Callback for city selection change.
  final ValueChanged<String?>? onCityChanged;

  /// The currently selected state.
  final String? currentState;

  /// The currently selected city.
  final String? currentCity;

  /// Whether to show the clear button.
  final bool showClearButton;

  /// Content to display on the clear button.
  final Widget clearButtonContent;

  /// Widget to display as title.
  final Widget? title;

  /// Style for the selected item.
  final TextStyle? selectedItemStyle;

  /// Style for the dropdown heading.
  final TextStyle? dropdownHeadingStyle;

  /// Style for the dropdown items.
  final TextStyle? dropdownItemStyle;

  /// Decoration for the dropdown.
  final BoxDecoration? dropdownDecoration;

  /// Decoration for the disabled dropdown.
  final BoxDecoration? disabledDropdownDecoration;

  /// Whether to show states dropdown.
  final bool showStates;

  /// Whether to show cities dropdown.
  final bool showCities;

  /// Radius for the search bar.
  final double? searchBarRadius;

  /// Radius for the dropdown dialog.
  final double? dropdownDialogRadius;

  /// Placeholder text for state search.
  final String stateSearchPlaceholder;

  /// Placeholder text for city search.
  final String citySearchPlaceholder;

  /// Label for the state dropdown.
  final String stateDropdownLabel;

  /// Label for the city dropdown.
  final String cityDropdownLabel;

  /// Creates a [BrazilianLocations] widget.
  const BrazilianLocations({
    super.key,
    this.onStateChanged,
    this.onCityChanged,
    this.selectedItemStyle,
    this.dropdownHeadingStyle,
    this.dropdownItemStyle,
    this.dropdownDecoration,
    this.disabledDropdownDecoration,
    this.searchBarRadius,
    this.dropdownDialogRadius,
    this.showStates = true,
    this.showCities = true,
    this.currentState,
    this.currentCity,
    this.stateSearchPlaceholder = "Search State",
    this.citySearchPlaceholder = "Search City",
    this.stateDropdownLabel = "State",
    this.cityDropdownLabel = "City",
    this.title,
    this.clearButtonContent = const Text("Clear"),
    this.showClearButton = false,
  });

  @override
  State<BrazilianLocations> createState() => _BrazilianLocationsState();
}

class _BrazilianLocationsState extends State<BrazilianLocations> {
  String _selectedState = 'State';
  String _selectedCity = 'City';
  List<String> _states = [];
  List<String> _cities = [];

  @override
  void initState() {
    super.initState();
    _loadStates();
  }

  /// Read JSON Brazil data from assets
  Future<String> loadJson() async {
    return await rootBundle
        .loadString('packages/brazilian_locations/lib/assets/brasil.json');
  }

  /// Read States from json response
  Future<void> _loadStates() async {
    final String jsonContent = await loadJson();
    final List<dynamic> states = jsonDecode(jsonContent)['states'];
    setState(() {
      _states = states.map((state) => state['name']).cast<String>().toList();
    });
  }

  /// Read Cities from json response
  Future<void> _loadCities(String stateName) async {
    final String jsonContent = await loadJson();
    final List<dynamic> states = jsonDecode(jsonContent)['states'];
    final List<String> cities = states
        .firstWhere((state) => state['name'] == stateName)['cities']
        .map((city) => city['name'])
        .cast<String>()
        .toList();
    setState(() {
      _cities = cities;
      _selectedCity = 'City';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.title != null || widget.showClearButton)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (widget.title != null) Expanded(flex: 2, child: widget.title!),
              if (widget.showClearButton)
                Expanded(flex: 1, child: _buildClearButton()),
            ],
          ),
        if (widget.title != null || widget.showClearButton)
          const SizedBox(height: 10.0),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (widget.showStates) _buildStateDropdown(),
            const SizedBox(height: 10.0),
            if (widget.showStates && widget.showCities) _buildCityDropdown(),
          ],
        )
      ],
    );
  }

  /// Build Dropdown Widget for State
  Widget _buildStateDropdown() {
    return DropdownWithSearch(
      title: widget.stateDropdownLabel,
      placeHolder: widget.stateSearchPlaceholder,
      disabled: _states.isEmpty ? true : false,
      items: _states.map((String? dropDownStringItem) {
        return dropDownStringItem;
      }).toList(),
      selectedItemStyle: widget.selectedItemStyle,
      dropdownHeadingStyle: widget.dropdownHeadingStyle,
      itemStyle: widget.dropdownItemStyle,
      decoration: widget.dropdownDecoration,
      dialogRadius: widget.dropdownDialogRadius,
      searchBarRadius: widget.searchBarRadius,
      disabledDecoration: widget.disabledDropdownDecoration,
      selected: _selectedState,
      label: widget.stateSearchPlaceholder,
      onChanged: (String? newState) {
        if (newState != null && widget.onStateChanged != null) {
          widget.onStateChanged!(newState);
          _loadCities(newState);
          setState(() => _selectedState = newState);
        }
      },
    );
  }

  /// Build Dropdown Widget for City
  Widget _buildCityDropdown() {
    return DropdownWithSearch(
      title: widget.cityDropdownLabel,
      placeHolder: widget.citySearchPlaceholder,
      disabled: _cities.isEmpty ? true : false,
      items: _cities.map((String? dropDownStringItem) {
        return dropDownStringItem;
      }).toList(),
      selectedItemStyle: widget.selectedItemStyle,
      dropdownHeadingStyle: widget.dropdownHeadingStyle,
      itemStyle: widget.dropdownItemStyle,
      decoration: widget.dropdownDecoration,
      dialogRadius: widget.dropdownDialogRadius,
      searchBarRadius: widget.searchBarRadius,
      disabledDecoration: widget.disabledDropdownDecoration,
      selected: _selectedCity,
      label: widget.citySearchPlaceholder,
      onChanged: (String? newCity) {
        if (newCity != null && widget.onCityChanged != null) {
          widget.onCityChanged!(newCity);
          setState(() => _selectedCity = newCity);
        }
      },
    );
  }

  /// Clear State and City Values
  Widget _buildClearButton() {
    return ElevatedButton(
      onPressed: () {
        if (widget.onStateChanged != null) widget.onStateChanged!(null);
        if (widget.onCityChanged != null) widget.onCityChanged!(null);
        setState(() {
          _selectedState = 'State';
          _selectedCity = 'City';
        });
      },
      child: widget.clearButtonContent,
    );
  }
}
