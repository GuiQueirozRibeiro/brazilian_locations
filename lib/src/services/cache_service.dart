import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

import 'package:brazilian_locations/src/models/location.dart';

class CacheService {
  static const String _boxName = 'brazilian_locations';

  Future<void> initializeHive() async {
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(LocationAdapter());
    }
    await Hive.openBox<Location>(_boxName);
  }

  Future<void> saveData(List<Location> data) async {
    var box = Hive.box<Location>(_boxName);
    await box.clear();
    await box.addAll(data);
  }

  Future<List<Location>> getData() async {
    var box = Hive.box<Location>(_boxName);
    return box.values.toList();
  }

  Future<void> fetchAndCacheData() async {
    var box = Hive.box<Location>(_boxName);
    if (box.isNotEmpty) return;

    final response = await http.get(
      Uri.https('servicodados.ibge.gov.br', '/api/v1/localidades/distritos'),
    );

    final List<dynamic> data = jsonDecode(response.body);
    final List<Location> locations = data.map((item) {
      String state =
          item['municipio']['microrregiao']['mesorregiao']['UF']['nome'];
      String city = item['municipio']['nome'];
      return Location(state, city);
    }).toList();

    await saveData(locations);
  }
}
