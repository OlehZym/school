import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../models/student.dart';
import '../../models/schedule.dart';
import 'edit_student_page.dart';
import 'package:school/pages/students_pages/mark_input_field.dart';

class StudentsPage extends StatefulWidget {
  const StudentsPage({super.key});

  @override
  State<StudentsPage> createState() => _StudentsPageState();
}

class _StudentsPageState extends State<StudentsPage> {
  final studentsBox = Hive.box<Student>('students');
  final scheduleBox = Hive.box<Schedule>('schedule');

  DateTime selectedDate = DateTime.now();

  /// Хранит пари "дата|урок" для редагування оцінок
  final Set<String> editingLessons = {};

  void _deleteStudent(final student) {
    showDialog<bool>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Видалити учня?'),
            content: const Text('Цю дію не можна скасувати.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text(
                  'Скасувати',
                  style: TextStyle(color: Color.fromARGB(255, 0, 194, 26)),
                ),
              ),
              TextButton(
                onPressed: () {
                  student.delete();
                  Navigator.pop(ctx);
                },
                child: const Text(
                  'Видалити',
                  style: TextStyle(color: Color.fromARGB(255, 255, 0, 0)),
                ),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dateStr = _formatDate(selectedDate);
    final weekday = _getWeekday(selectedDate.weekday);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              ElevatedButton.icon(
                onPressed: _selectDate,
                icon: const Icon(
                  Icons.calendar_today,
                  color: Color.fromARGB(255, 33, 72, 243),
                ),
                label: Text(
                  'Дата: $dateStr',
                  style: const TextStyle(
                    color: Color.fromARGB(255, 33, 72, 243),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Text(weekday, style: const TextStyle(fontSize: 16)),
            ],
          ),
        ),
        Expanded(
          child: ValueListenableBuilder(
            valueListenable: studentsBox.listenable(),
            builder: (context, Box<Student> box, _) {
              return ListView(
                children: [
                  for (int i = 0; i < box.length; i++)
                    _buildStudentTile(
                      context,
                      box.getAt(i)!,
                      i,
                      weekday,
                      dateStr,
                    ),
                  ListTile(
                    leading: const Icon(Icons.add),
                    title: const Text('Додати учня'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const EditStudentPage(),
                        ),
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      locale: const Locale('uk', 'UA'),
    );
    if (picked != null) {
      setState(() => selectedDate = picked);
    }
  }

  Widget _buildStudentTile(
    BuildContext context,
    Student student,
    int index,
    String weekday,
    String dateStr,
  ) {
    final schedule = scheduleBox.get('main');
    final todayLessons = schedule?.lessons[weekday] ?? [];

    return ExpansionTile(
      title: Text(student.name),
      subtitle: Text('Оцінки на $dateStr ($weekday)'),
      children: [
        for (var lesson in todayLessons)
          ListTile(
            title: Text(lesson),
            trailing: _buildMarkWidget(student, dateStr, lesson),
          ),
        OverflowBar(
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.amber),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EditStudentPage(student: student),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _deleteStudent(student),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMarkWidget(Student student, String dateStr, String lesson) {
    final currentMark = student.marks[dateStr]?[lesson];
    final key = '$dateStr|${student.key}|$lesson';
    final isEditing = editingLessons.contains(key);

    if (isEditing) {
      return MarkInputField(
        initialMark: currentMark ?? '',
        onSave: (value) {
          student.marks[dateStr] ??= {};
          student.marks[dateStr]![lesson] = value;
          student.save();
          setState(() {
            editingLessons.remove(key);
          });
        },
      );
    } else {
      if (currentMark != null) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Оцінка: $currentMark',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: const Icon(Icons.edit, size: 20, color: Colors.amber),
              onPressed: () {
                setState(() {
                  editingLessons.add(key);
                });
              },
            ),
          ],
        );
      } else {
        return MarkInputField(
          onSave: (value) {
            student.marks[dateStr] ??= {};
            student.marks[dateStr]![lesson] = value;
            student.save();
            setState(() {});
          },
        );
      }
    }
  }

  String _getWeekday(int weekday) {
    const days = [
      'Понеділок',
      'Вівторок',
      'Середа',
      'Четвер',
      'П’ятниця',
      'Субота',
      'Неділя',
    ];
    return days[weekday - 1];
  }

  String _formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }
}
