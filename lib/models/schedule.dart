// models/schedule.dart
import 'package:hive/hive.dart';

part 'schedule.g.dart';

@HiveType(typeId: 2)
class Schedule extends HiveObject {
  @HiveField(0)
  Map<String, List<String>> lessons;

  Schedule({required this.lessons});
}
