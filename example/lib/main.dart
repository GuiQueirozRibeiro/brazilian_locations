import 'package:flutter/material.dart';
import 'package:brazilian_locations/brazilian_locations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String stateValue = "";
  String cityValue = "";
  String address = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Brazilian Locations'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 16),

            /// Adding Brazilian Locations Widget in app
            BrazilianLocations(
              /// Enable disable state dropdown [OPTIONAL PARAMETER]
              showStates: true,

              /// Enable disable city drop down [OPTIONAL PARAMETER]
              showCities: true,

              /// Dropdown box decoration to style your dropdown selector [OPTIONAL PARAMETER] (USE with disabledDropdownDecoration)
              dropdownDecoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(4)),
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade400, width: 1),
              ),

              /// Disabled Dropdown box decoration to style your dropdown selector [OPTIONAL PARAMETER]  (USE with disabled dropdownDecoration)
              disabledDropdownDecoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(4)),
                color: Colors.grey.shade300,
                border: Border.all(color: Colors.grey.shade400, width: 1),
              ),

              /// Placeholders for dropdown search field
              stateSearchPlaceholder: "Estado",
              citySearchPlaceholder: "City",

              /// Labels for dropdown
              stateDropdownLabel: "Estado",
              cityDropdownLabel: "City",

              /// Selected item style [OPTIONAL PARAMETER]
              selectedItemStyle: const TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),

              /// DropdownDialog Heading style [OPTIONAL PARAMETER]
              dropdownHeadingStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),

              /// DropdownDialog Item style [OPTIONAL PARAMETER]
              dropdownItemStyle: const TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),

              /// Dialog box radius [OPTIONAL PARAMETER]
              dropdownDialogRadius: 8.0,

              /// Search bar radius [OPTIONAL PARAMETER]
              searchBarRadius: 8.0,

              /// Triggers once state selected in dropdown
              onStateChanged: (value) {
                if (value != null) {
                  setState(() {
                    /// Store value in state variable
                    stateValue = value;
                  });
                }
              },

              /// Triggers once city selected in dropdown
              onCityChanged: (value) {
                if (value != null) {
                  setState(() {
                    /// Store value in city variable
                    cityValue = value;
                  });
                }
              },
            ),

            /// Print newly selected state and city in Text Widget
            TextButton(
              onPressed: () {
                setState(() => address = "$cityValue, $stateValue");
              },
              child: const Text("Print Data"),
            ),
            Text(address),
          ],
        ),
      ),
    );
  }
}
