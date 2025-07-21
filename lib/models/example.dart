// models/example.dart
import 'package:hive/hive.dart';

part 'example.g.dart';

@HiveType(typeId: 1)
class Example extends HiveObject {
  @HiveField(0)
  int left;

  @HiveField(1)
  int right;

  @HiveField(2)
  String operation; // "+" або "-"

  @HiveField(3)
  int answer;

  @HiveField(4)
  bool checked;

  Example({
    required this.left,
    required this.right,
    required this.operation,
    required this.answer,
    this.checked = false,
  });

  String get question => '$left $operation $right = ';
}
