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
  static const Duration _cacheDuration = Duration(days: 7);

  List<Location>? _cachedData;
  bool _isHiveInitialized = false;

  List<Location> getCachedData() {
    if (_cachedData == null) {
      return [];
    }
    return _cachedData!;
  }

  Future<void> initializeHive() async {
    if (_isHiveInitialized) return;

    try {
      final appDocumentDir = await getApplicationDocumentsDirectory();
      Hive.init(appDocumentDir.path);

      if (!Hive.isAdapterRegistered(LocationAdapter().typeId)) {
        Hive.registerAdapter(LocationAdapter());
      }
      if (!Hive.isAdapterRegistered(CacheDataAdapter().typeId)) {
        Hive.registerAdapter(CacheDataAdapter());
      }

      if (!Hive.isBoxOpen(_boxName)) {
        await Hive.openBox<CacheData>(_boxName);
      }

      _isHiveInitialized = true;
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
      debugPrint('Error loading data: $e');
      try {
        var box = Hive.box<CacheData>(_boxName);
        CacheData? cacheData = box.get('cache');
        if (cacheData != null) {
          _cachedData = cacheData.locations;
        } else {
          _cachedData = [];
        }
      } catch (fallbackError) {
        debugPrint('Fallback also failed: $fallbackError');
        _cachedData = [];
      }
    }
  }

  Future<List<Location>> fetchAndCacheData() async {
    try {
      final response = await http
          .get(
            Uri.https(
                'servicodados.ibge.gov.br', '/api/v1/localidades/distritos'),
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode != 200) {
        throw Exception('API returned status code: ${response.statusCode}');
      }

      final List<dynamic> data = jsonDecode(response.body);
      final List<Location> locations = [];

      for (final item in data) {
        try {
          // Safe navigation through nested structure
          final municipio = item['municipio'];
          if (municipio == null) continue;

          final microrregiao = municipio['microrregiao'];
          if (microrregiao == null) continue;

          final mesorregiao = microrregiao['mesorregiao'];
          if (mesorregiao == null) continue;

          final uf = mesorregiao['UF'];
          if (uf == null) continue;

          final stateUF = uf['sigla'];
          final city = municipio['nome'];

          if (stateUF != null && city != null) {
            locations.add(Location(stateUF.toString(), city.toString()));
          }
        } catch (e) {
          debugPrint('Error parsing item: $e');
          continue;
        }
      }

      if (locations.isEmpty) {
        throw Exception('No valid locations found in API response');
      }

      locations.sort((a, b) => a.state.compareTo(b.state));
      await saveData(locations);
      return locations;
    } catch (e) {
      debugPrint('Error fetching data from API: $e');
      rethrow;
    }
  }
}
