import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'dropdown_search.dart';

class BrazilianLocations extends StatefulWidget {
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
  final ValueChanged<String?>? onStateChanged;
  final ValueChanged<String?>? onCityChanged;

  final String? currentState;
  final String? currentCity;

  // clear button parameters
  final bool showClearButton;
  final Widget clearButtonContent;

  // title widget
  final Widget? title;

  ///Parameters to change style of CSC Picker
  final TextStyle? selectedItemStyle, dropdownHeadingStyle, dropdownItemStyle;
  final BoxDecoration? dropdownDecoration, disabledDropdownDecoration;
  final bool showStates, showCities;
  final double? searchBarRadius;
  final double? dropdownDialogRadius;

  final String stateSearchPlaceholder;
  final String citySearchPlaceholder;
  final String stateDropdownLabel;
  final String cityDropdownLabel;

  @override
  State<BrazilianLocations> createState() => _BrazilianLocationsState();
}

class _BrazilianLocationsState extends State<BrazilianLocations> {
  late List<String> _states;
  late List<String> _cities;
  String _selectedState = 'State';
  String _selectedCity = 'City';

  @override
  void initState() {
    super.initState();
    _states = [];
    _cities = [];
    _selectedState = widget.currentState ?? 'State';
    _selectedCity = widget.currentCity ?? 'City';
    _loadStates();
  }

  Future<dynamic> loadJson() async {
    return await rootBundle.loadString('assets/brazilian_locations.json');
  }

  Future<void> _loadStates() async {
    final String jsonContent = await loadJson();
    final List<dynamic> states = jsonDecode(jsonContent)['states'];
    setState(() {
      _states = states.map((state) => state['name']).cast<String>().toList();
    });
  }

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
          children: [
            if (widget.showStates) const SizedBox(height: 10.0),
            if (widget.showStates) Expanded(child: _buildStateDropdown()),
            const SizedBox(height: 10.0),
            if (widget.showStates && widget.showCities) _buildCityDropdown(),
          ],
        ),
      ],
    );
  }

  Widget _buildStateDropdown() {
    return DropdownWithSearch(
      title: widget.stateDropdownLabel,
      placeHolder: widget.stateSearchPlaceholder,
      disabled: _states.isEmpty ? true : false,
      items: _states.map<DropdownMenuItem<String>>((String state) {
        return DropdownMenuItem<String>(
          value: state,
          child: Text(state),
        );
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

  Widget _buildCityDropdown() {
    return DropdownWithSearch(
      title: widget.cityDropdownLabel,
      placeHolder: widget.citySearchPlaceholder,
      disabled: _cities.isEmpty ? true : false,
      items: _cities.map<DropdownMenuItem<String>>((String city) {
        return DropdownMenuItem<String>(
          value: city,
          child: Text(city),
        );
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
