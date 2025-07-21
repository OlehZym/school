// pages/edit_student_page.dart
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/student.dart';

class EditStudentPage extends StatefulWidget {
  final Student? student;

  const EditStudentPage({super.key, this.student});

  @override
  State<EditStudentPage> createState() => _EditStudentPageState();
}

class _EditStudentPageState extends State<EditStudentPage> {
  final nameController = TextEditingController();
  Map<String, List<String>> schedule = {};

  final days = ['Понеділок', 'Вівторок', 'Середа', 'Четвер', 'П’ятниця'];

  @override
  void initState() {
    if (widget.student != null) {
      nameController.text = widget.student!.name;
      schedule = Map.from(widget.student!.schedule);
    } else {
      for (var day in days) {
        schedule[day] = [];
      }
    }
    super.initState();
  }

  void _save() {
    if (widget.student == null) {
      final newStudent = Student(
        name: nameController.text,
        schedule: schedule,
        marks: {}, // або що тобі потрібно
      );
      Hive.box<Student>('students').add(newStudent);
    } else {
      widget.student!.name = nameController.text;
      widget.student!.schedule = schedule;
      widget.student!.save(); // зберегти зміни
    }

    Navigator.pop(context);
  }

  void _editLesson(String day) {
    final controller = TextEditingController(
      text: schedule[day]?.join(', ') ?? '',
    );

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text('Уроки на $day'),
            content: TextField(
              controller: controller,
              decoration: InputDecoration(hintText: 'Математика, Читання'),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  schedule[day] =
                      controller.text.split(',').map((e) => e.trim()).toList();
                  setState(() {});
                  Navigator.pop(context);
                },
                child: Text('Зберегти'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.student == null ? 'Новий учень' : 'Редагувати'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          TextField(
            controller: nameController,
            decoration: InputDecoration(labelText: 'Ім’я учня'),
          ),
          SizedBox(height: 16),
          Text('Розклад:'),
          for (var day in days)
            ListTile(
              title: Text('$day: ${schedule[day]?.join(', ') ?? ''}'),
              trailing: IconButton(
                onPressed: () => _editLesson(day),
                icon: Icon(Icons.edit),
              ),
              // onTap: () => _editLesson(day),
            ),
          SizedBox(height: 16),
          ElevatedButton(onPressed: _save, child: Text('Зберегти')),
        ],
      ),
    );
  }
}
