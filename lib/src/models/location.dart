import 'package:hive/hive.dart';

part 'location.g.dart';

@HiveType(typeId: 0)
class Location {
  @HiveField(0)
  final String state;

  @HiveField(1)
  final String city;

  Location(this.state, this.city);
}
