import 'dart:convert';

import 'package:brazilian_locations/src/models/cache_data.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import 'package:brazilian_locations/src/models/location.dart';

class CacheService {
  CacheService();

  static const String _boxName = 'brazilian_locations_box';
  static const Duration _cacheDuration = Duration(days: 0);

  List<Location>? _cachedData;

  List<Location> getCachedData() {
    if (_cachedData == null) {
      throw Exception('Data not loaded. Please call loadData() first.');
    }
    return _cachedData!;
  }

  Future<void> initializeHive() async {
    try {
      final appDocumentDir = await getApplicationDocumentsDirectory();
      Hive.init(appDocumentDir.path);
      Hive.registerAdapter(LocationAdapter());
      Hive.registerAdapter(CacheDataAdapter());
      await Hive.openBox<CacheData>(_boxName);
    } catch (e) {
      debugPrint('Error initializing Hive: $e');
      rethrow;
    }
  }

  Future<void> saveData(List<Location> data) async {
    try {
      var box = Hive.box<CacheData>(_boxName);
      CacheData cacheData = CacheData(data, DateTime.now());
      await box.clear();
      await box.put('cache', cacheData);
    } catch (e) {
      debugPrint('Error saving data: $e');
      rethrow;
    }
  }

  Future<void> loadData() async {
    try {
      var box = Hive.box<CacheData>(_boxName);
      CacheData? cacheData = box.get('cache');

      if (cacheData != null &&
          DateTime.now().difference(cacheData.timestamp) <= _cacheDuration) {
        _cachedData = cacheData.locations;
      } else {
        _cachedData = await fetchAndCacheData();
      }
    } catch (e) {
      debugPrint('Error getting data: $e');
      rethrow;
    }
  }

  Future<List<Location>> fetchAndCacheData() async {
    try {
      final response = await http.get(
        Uri.https('servicodados.ibge.gov.br', '/api/v1/localidades/distritos'),
      );

      final List<dynamic> data = jsonDecode(response.body);
      final List<Location> locations = data.map((item) {
        final String stateName =
            item['municipio']['microrregiao']['mesorregiao']['UF']['nome'];
        final String stateUF =
            item['municipio']['microrregiao']['mesorregiao']['UF']['sigla'];
        final String city = item['municipio']['nome'];
        return Location('$stateName - $stateUF', city);
      }).toList();
      locations.sort((a, b) => a.state.compareTo(b.state));
      await saveData(locations);
      return locations;
    } catch (e) {
      debugPrint('Error fetching and saving API data: $e');
      rethrow;
    }
  }
}
