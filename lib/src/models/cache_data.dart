import 'package:brazilian_locations/src/models/location.dart';
import 'package:hive/hive.dart';

part 'cache_data.g.dart';

@HiveType(typeId: 1)
class CacheData {
  @HiveField(0)
  final List<Location> locations;

  @HiveField(1)
  final DateTime timestamp;

  CacheData(this.locations, this.timestamp);
}
