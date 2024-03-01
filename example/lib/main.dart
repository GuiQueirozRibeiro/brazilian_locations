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
      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          height: 600,
          child: Column(
            children: [
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
              ),
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
      ),
    );
  }
}
