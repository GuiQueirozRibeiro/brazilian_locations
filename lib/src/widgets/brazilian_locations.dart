import 'package:flutter/material.dart';

import 'package:brazilian_locations/src/models/location.dart';
import 'package:brazilian_locations/src/services/cache_service.dart';
import 'package:brazilian_locations/src/widgets/dropdown_search.dart';

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

  /// Custom Icon to open the dialog.
  final Icon? customIcon;

  /// Style for the selected item.
  final TextStyle? selectedItemStyle;

  /// Padding for the dropdown.
  final double? dropdownPadding;

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
  /// - [customIcon]: Custom Icon to open the dialog.
  /// - [selectedItemStyle]: Style for the selected item.
  /// - [dropdownPadding]: Padding for the dropdown.
  /// - [dropdownHeadingStyle]: Style for the dropdown heading.
  /// - [dropdownLabelStyle]: Style for the dropdown label.
  /// - [dropdownItemStyle]: Style for the dropdown items.
  /// - [dropdownDecoration]: Decoration for the dropdown.
  /// - [dropdownInputDecoration]: Decoration for the Text Field in dropdown.
  /// - [disabledDropdownDecoration]: Decoration for the disabled dropdown.
  /// - [showStates]: Whether to show states dropdown.
  /// - [showCities]: Whether to show cities dropdown.
  /// - [showDropdownLabel]: Whether to show dropdown Label.
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
    this.customIcon,
    this.selectedItemStyle,
    this.dropdownPadding,
    this.dropdownHeadingStyle,
    this.dropdownLabelStyle,
    this.dropdownItemStyle,
    this.dropdownDecoration,
    this.dropdownInputDecoration,
    this.disabledDropdownDecoration,
    this.showStates = true,
    this.showCities = true,
    this.showDropdownLabel = true,
    this.searchBarRadius,
    this.dropdownDialogRadius,
    this.stateSearchPlaceholder = 'Procurar Estado',
    this.citySearchPlaceholder = 'Procurar Cidade',
    this.stateDropdownLabel = 'Estado',
    this.cityDropdownLabel = 'Cidade',
    this.currentState = 'Estado',
    this.currentCity = 'Cidade',
  });

  static final CacheService _cacheService = CacheService();
  static bool _isInitialized = false;

  /// Static method to initialize Hive and fetch data.
  static Future<void> initialize() async {
    if (!_isInitialized) {
      await _cacheService.initializeHive();
      await _cacheService.loadData();
      _isInitialized = true;
    }
  }

  @override
  State<BrazilianLocations> createState() => _BrazilianLocationsState();
}

class _BrazilianLocationsState extends State<BrazilianLocations> {
  String selectedState = '';
  String selectedCity = '';
  List<String> states = [];
  Map<String, Set<String>> citiesMap = {};

  final CacheService _cacheService = BrazilianLocations._cacheService;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    if (!BrazilianLocations._isInitialized) {
      await BrazilianLocations.initialize();
    }
    final List<Location> locations = _cacheService.getCachedData();
    final Map<String, Set<String>> tempCitiesMap = {};

    for (final location in locations) {
      if (tempCitiesMap.containsKey(location.state)) {
        tempCitiesMap[location.state]!.add(location.city);
      } else {
        tempCitiesMap[location.state] = {location.city};
      }
    }

    setState(() {
      states = tempCitiesMap.keys.toList();
      citiesMap = tempCitiesMap;
      selectedState = widget.currentState;
      selectedCity = widget.currentCity;
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
                Expanded(flex: 1, child: buildClearButton()),
            ],
          ),
        if (widget.title != null || widget.showClearButton)
          SizedBox(height: widget.dropdownPadding ?? 16.0),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (widget.showDropdownLabel && widget.showStates)
              buildStateDropdownLabel(),
            if (widget.showStates) buildStateDropdown(),
            SizedBox(height: widget.dropdownPadding ?? 16.0),
            if (widget.showDropdownLabel && showCities)
              buildCityDropdownLabel(),
            if (showCities) buildCityDropdown(),
          ],
        )
      ],
    );
  }

  /// Build Dropdown Widget for State
  Widget buildStateDropdown() {
    return DropdownWithSearch(
      label: widget.stateSearchPlaceholder,
      title: widget.stateDropdownLabel,
      disabled: states.isEmpty ? true : false,
      items: states.map((String? dropDownStringItem) {
        return dropDownStringItem;
      }).toList(),
      customIcon: widget.customIcon,
      selectedItemStyle: widget.selectedItemStyle,
      dropdownHeadingStyle: widget.dropdownHeadingStyle,
      itemStyle: widget.dropdownItemStyle,
      decoration: widget.dropdownDecoration,
      inputDecoration: widget.dropdownInputDecoration,
      dialogRadius: widget.dropdownDialogRadius,
      searchBarRadius: widget.searchBarRadius,
      disabledDropdownDecoration: widget.disabledDropdownDecoration,
      selected: selectedState,
      onChanged: (String? newState) {
        if (newState != null && widget.onStateChanged != null) {
          widget.onStateChanged!(newState);
          setState(() => selectedState = newState);
        }
      },
    );
  }

  /// Build Dropdown Widget for City
  Widget buildCityDropdown() {
    List<String>? cities = citiesMap[selectedState]?.toList();
    cities ??= [];

    return DropdownWithSearch(
      title: widget.cityDropdownLabel,
      label: widget.citySearchPlaceholder,
      disabled: cities.isEmpty ? true : false,
      items: cities,
      customIcon: widget.customIcon,
      selectedItemStyle: widget.selectedItemStyle,
      dropdownHeadingStyle: widget.dropdownHeadingStyle,
      itemStyle: widget.dropdownItemStyle,
      decoration: widget.dropdownDecoration,
      inputDecoration: widget.dropdownInputDecoration,
      dialogRadius: widget.dropdownDialogRadius,
      searchBarRadius: widget.searchBarRadius,
      disabledDropdownDecoration: widget.disabledDropdownDecoration,
      selected: selectedCity,
      onChanged: (String? newCity) {
        if (newCity != null && widget.onCityChanged != null) {
          widget.onCityChanged!(newCity);
          setState(() => selectedCity = newCity);
        }
      },
    );
  }

  /// Show the State Dropdown Label
  Widget buildStateDropdownLabel() {
    return Text(
      widget.stateDropdownLabel,
      style: widget.dropdownLabelStyle ?? const TextStyle(fontSize: 18),
    );
  }

  /// Show the City Dropdown Label
  Widget buildCityDropdownLabel() {
    return Text(
      widget.cityDropdownLabel,
      style: widget.dropdownLabelStyle ?? const TextStyle(fontSize: 18),
    );
  }

  /// Clear State and City Values
  Widget buildClearButton() {
    return ElevatedButton(
      style: widget.clearButtonDecoration,
      onPressed: () {
        if (widget.onStateChanged != null) widget.onStateChanged!(null);
        if (widget.onCityChanged != null) widget.onCityChanged!(null);
        setState(() {
          selectedState = widget.stateDropdownLabel;
          selectedCity = widget.cityDropdownLabel;
        });
      },
      child: widget.clearButtonContent,
    );
  }
}
