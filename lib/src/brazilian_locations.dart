import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import 'dropdown_search.dart';

/// A widget for selecting Brazilian locations.
class BrazilianLocations extends StatefulWidget {
  /// Callback for when the state selection changes.
  final ValueChanged<String?>? onStateChanged;

  /// Callback for when the city selection changes.
  final ValueChanged<String?>? onCityChanged;

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

  /// Style for the dropdown label.
  final TextStyle? dropdownLabelStyle;

  /// Style for the dropdown items.
  final TextStyle? dropdownItemStyle;

  /// Decoration for the dropdown.
  final BoxDecoration? dropdownDecoration;

  /// Decoration for the Text Field in dropdown.
  final InputDecoration? dropdownInputDecoration;

  /// Decoration for the disabled dropdown.
  final BoxDecoration? disabledDropdownDecoration;

  /// Whether to show states dropdown.
  final bool showStates;

  /// Whether to show cities dropdown.
  final bool showCities;

  /// Whether to show dropdown Label.
  final bool showDropdownLabel;

  /// Use local data or use JSON from IBGE API.
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

  /// The currently selected state.
  final String currentState;

  /// The currently selected city.
  final String currentCity;

  /// Creates a [BrazilianLocations] widget.
  ///
  /// Parameters:
  ///
  /// - [onStateChanged]: Callback for when the state selection changes.
  /// - [onCityChanged]: Callback for when the city selection changes.
  /// - [showClearButton]: Whether to show the clear button.
  /// - [clearButtonContent]: Content to display on the clear button.
  /// - [clearButtonDecoration]: Decoration for the clear button.
  /// - [title]: Widget to display as title.
  /// - [selectedItemStyle]: Style for the selected item.
  /// - [dropdownHeadingStyle]: Style for the dropdown heading.
  /// - [dropdownLabelStyle]: Style for the dropdown label.
  /// - [dropdownItemStyle]: Style for the dropdown items.
  /// - [dropdownDecoration]: Decoration for the dropdown.
  /// - [dropdownInputDecoration]: Decoration for the Text Field in dropdown.
  /// - [disabledDropdownDecoration]: Decoration for the disabled dropdown.
  /// - [showStates]: Whether to show states dropdown.
  /// - [showCities]: Whether to show cities dropdown.
  /// - [showDropdownLabel]: Whether to show dropdown Label.
  /// - [useLocalData]: Use local data or use JSON from IBGE API.
  /// - [searchBarRadius]: Radius for the search bar.
  /// - [dropdownDialogRadius]: Radius for the dropdown dialog.
  /// - [stateSearchPlaceholder]: Placeholder text for state search.
  /// - [citySearchPlaceholder]: Placeholder text for city search.
  /// - [stateDropdownLabel]: Label for the state dropdown.
  /// - [cityDropdownLabel]: Label for the city dropdown.
  /// - [currentState]: The currently selected state.
  /// - [currentCity]: The currently selected city.
  const BrazilianLocations({
    super.key,
    this.onStateChanged,
    this.onCityChanged,
    this.showClearButton = false,
    this.clearButtonContent = const Text('Limpar'),
    this.clearButtonDecoration,
    this.title,
    this.selectedItemStyle,
    this.dropdownHeadingStyle,
    this.dropdownLabelStyle,
    this.dropdownItemStyle,
    this.dropdownDecoration,
    this.dropdownInputDecoration,
    this.disabledDropdownDecoration,
    this.showStates = true,
    this.showCities = true,
    this.showDropdownLabel = true,
    this.useLocalData = true,
    this.searchBarRadius,
    this.dropdownDialogRadius,
    this.stateSearchPlaceholder = 'Procurar Estado',
    this.citySearchPlaceholder = 'Procurar Cidade',
    this.stateDropdownLabel = 'Estado',
    this.cityDropdownLabel = 'Cidade',
    this.currentState = 'Estado',
    this.currentCity = 'Cidade',
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
    _selectedState = widget.currentState;
    _selectedCity = widget.currentCity;
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
    Map<String, Set<String>> statesAndCities = {};

    if (widget.useLocalData) {
      final Map<String, dynamic> data = jsonDecode(jsonContent);

      data.forEach((state, value) {
        String stateName = state;
        List<dynamic> cities = value['cidades'];
        Set<String> cityNames = {};

        for (final city in cities) {
          cityNames.add(city['nome']);
        }
        statesAndCities[stateName] = cityNames;
      });
    } else {
      final List<dynamic> data = jsonDecode(jsonContent);

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
    }

    setState(() {
      _states = statesAndCities.keys.toList();
      _citiesMap = statesAndCities;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool showCities = widget.showStates && widget.showCities;
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (widget.showDropdownLabel && widget.showStates)
              _buildStateDropdownLabel(),
            if (widget.showStates) _buildStateDropdown(),
            const SizedBox(height: 10.0),
            if (widget.showDropdownLabel && showCities)
              _buildCityDropdownLabel(),
            if (showCities) _buildCityDropdown(),
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
      inputDecoration: widget.dropdownInputDecoration,
      dialogRadius: widget.dropdownDialogRadius,
      searchBarRadius: widget.searchBarRadius,
      disabledDropdownDecoration: widget.disabledDropdownDecoration,
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
      inputDecoration: widget.dropdownInputDecoration,
      dialogRadius: widget.dropdownDialogRadius,
      searchBarRadius: widget.searchBarRadius,
      disabledDropdownDecoration: widget.disabledDropdownDecoration,
      selected: _selectedCity,
      onChanged: (String? newCity) {
        if (newCity != null && widget.onCityChanged != null) {
          widget.onCityChanged!(newCity);
          setState(() => _selectedCity = newCity);
        }
      },
    );
  }

  /// Show the State Dropdown Label
  Widget _buildStateDropdownLabel() {
    return Text(
      widget.stateDropdownLabel,
      style: widget.dropdownLabelStyle ?? const TextStyle(fontSize: 18),
    );
  }

  /// Show the City Dropdown Label
  Widget _buildCityDropdownLabel() {
    return Text(
      widget.cityDropdownLabel,
      style: widget.dropdownLabelStyle ?? const TextStyle(fontSize: 18),
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
