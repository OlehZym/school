import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../models/student.dart';
import '../../models/schedule.dart';

class EditStudentPage extends StatefulWidget {
  final Student? student;

  const EditStudentPage({super.key, this.student});

  @override
  State<EditStudentPage> createState() => _EditStudentPageState();
}

class _EditStudentPageState extends State<EditStudentPage> {
  final nameController = TextEditingController();
  final days = ['Понеділок', 'Вівторок', 'Середа', 'Четвер', 'П’ятниця'];

  @override
  void initState() {
    super.initState();
    if (widget.student != null) {
      nameController.text = widget.student!.name;
    }
  }

  void _save() {
    final globalSchedule = Hive.box<Schedule>('schedule').get('main');

    if (widget.student == null) {
      final newStudent = Student(
        name: nameController.text,
        schedule: Map<String, List<String>>.from(globalSchedule?.lessons ?? {}),
        marks: {},
      );
      Hive.box<Student>('students').add(newStudent);
    } else {
      widget.student!.name = nameController.text;
      widget.student!.schedule = Map<String, List<String>>.from(
        globalSchedule?.lessons ?? {},
      );
      widget.student!.save();
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.student == null ? 'Новий учень' : 'Редагувати'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Ім’я учня'),
          ),

          const SizedBox(height: 16),
          ElevatedButton(onPressed: _save, child: const Text('Зберегти')),
        ],
      ),
    );
  }
}
