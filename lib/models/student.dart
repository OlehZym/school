import 'package:hive/hive.dart';

part 'student.g.dart';

@HiveType(typeId: 0)
class Student extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  Map<String, List<String>> schedule;

  @HiveField(2)
  Map<String, Map<String, String>> marks;

  Student({required this.name, required this.schedule, required this.marks});
}
