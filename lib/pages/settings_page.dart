// pages/settings_page.dart
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/schedule.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _darkTheme = false;
  final _days = ['Понеділок', 'Вівторок', 'Середа', 'Четвер', 'П’ятниця'];
  final _scheduleBox = Hive.box<Schedule>('schedule');

  @override
  void initState() {
    super.initState();
    _loadTheme();
    _initSchedule();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _darkTheme = prefs.getBool('darkTheme') ?? false;
    });
  }

  Future<void> _saveTheme(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkTheme', value);
    setState(() {
      _darkTheme = value;
    });
  }

  void _initSchedule() {
    if (_scheduleBox.isEmpty) {
      final defaultSchedule = Schedule(
        lessons: {for (var day in _days) day: []},
      );
      _scheduleBox.put('main', defaultSchedule);
    }
  }

  void _editDay(String day) {
    final schedule = _scheduleBox.get('main')!;
    final controller = TextEditingController(
      text: schedule.lessons[day]?.join(', ') ?? '',
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
                  final updated =
                      controller.text.split(',').map((e) => e.trim()).toList();
                  schedule.lessons[day] = updated;
                  schedule.save();
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
    final schedule = _scheduleBox.get('main');

    return ListView(
      children: [
        SwitchListTile(
          title: Text('Темна тема'),
          value: _darkTheme,
          onChanged: (val) {
            _saveTheme(val);
            // Сповіщення головного екрану про зміну теми
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Перезапустіть додаток для застосування теми'),
              ),
            );
          },
        ),
        Divider(),
        ListTile(title: Text('Розклад')),
        for (var day in _days)
          ListTile(
            title: Text('$day: ${schedule?.lessons[day]?.join(', ') ?? ''}'),
            trailing: Icon(Icons.edit),
            onTap: () => _editDay(day),
          ),
      ],
    );
  }
}
