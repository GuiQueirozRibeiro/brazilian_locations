import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

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

  /// Decoration for the clear button.
  final ButtonStyle? clearButtonDecoration;

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

  /// Use local data or use json from IBGE Api.
  final bool useLocalData;

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
    this.useLocalData = true,
    this.currentState,
    this.currentCity,
    this.stateSearchPlaceholder = 'Search State',
    this.citySearchPlaceholder = 'Search City',
    this.stateDropdownLabel = 'State',
    this.cityDropdownLabel = 'City',
    this.title,
    this.clearButtonContent = const Text('Clear'),
    this.clearButtonDecoration,
    this.showClearButton = false,
  });

  @override
  State<BrazilianLocations> createState() => _BrazilianLocationsState();
}

class _BrazilianLocationsState extends State<BrazilianLocations> {
  String _selectedState = '';
  String _selectedCity = '';
  List<String> _states = [];
  Map<String, Set<String>> _citiesMap = {};

  @override
  void initState() {
    super.initState();
    _initValues();
    _loadStatesAndCities();
  }

  void _initValues() {
    _selectedState = widget.currentState ?? widget.stateDropdownLabel;
    _selectedCity = widget.currentCity ?? widget.cityDropdownLabel;
  }

  /// Read JSON Brazil data from assets or IBGE Api
  Future<String> loadJson() async {
    if (widget.useLocalData) {
      return await rootBundle
          .loadString('packages/brazilian_locations/lib/assets/brasil.json');
    } else {
      final response = await http.get(
        Uri.https('servicodados.ibge.gov.br', '/api/v1/localidades/distritos'),
      );
      return response.body;
    }
  }

  Future<void> _loadStatesAndCities() async {
    final String jsonContent = await loadJson();
    final List<dynamic> data = jsonDecode(jsonContent);
    Map<String, Set<String>> statesAndCities = {};

    for (final item in data) {
      String state =
          item['municipio']['microrregiao']['mesorregiao']['UF']['nome'];
      String city = item['municipio']['nome'];

      if (statesAndCities.containsKey(state)) {
        statesAndCities[state]!.add(city);
      } else {
        statesAndCities[state] = {city};
      }
    }

    setState(() {
      _states = statesAndCities.keys.toList();
      _citiesMap = statesAndCities;
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
      label: widget.stateSearchPlaceholder,
      title: widget.stateDropdownLabel,
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
      onChanged: (String? newState) {
        if (newState != null && widget.onStateChanged != null) {
          widget.onStateChanged!(newState);
          setState(() => _selectedState = newState);
        }
      },
    );
  }

  /// Build Dropdown Widget for City
  Widget _buildCityDropdown() {
    List<String>? cities = _citiesMap[_selectedState]?.toList();
    cities ??= [];

    return DropdownWithSearch(
      title: widget.cityDropdownLabel,
      label: widget.citySearchPlaceholder,
      disabled: cities.isEmpty ? true : false,
      items: cities,
      selectedItemStyle: widget.selectedItemStyle,
      dropdownHeadingStyle: widget.dropdownHeadingStyle,
      itemStyle: widget.dropdownItemStyle,
      decoration: widget.dropdownDecoration,
      dialogRadius: widget.dropdownDialogRadius,
      searchBarRadius: widget.searchBarRadius,
      disabledDecoration: widget.disabledDropdownDecoration,
      selected: _selectedCity,
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
      style: widget.clearButtonDecoration,
      onPressed: () {
        if (widget.onStateChanged != null) widget.onStateChanged!(null);
        if (widget.onCityChanged != null) widget.onCityChanged!(null);
        setState(() {
          _selectedState = widget.stateDropdownLabel;
          _selectedCity = widget.cityDropdownLabel;
        });
      },
      child: widget.clearButtonContent,
    );
  }
}
