import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/schedule.dart';

class SettingsPage extends StatefulWidget {
  final void Function(ThemeMode)? onThemeChanged;
  final ThemeMode currentThemeMode;

  const SettingsPage({
    super.key,
    this.onThemeChanged,
    required this.currentThemeMode,
  });

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _days = ['Понеділок', 'Вівторок', 'Середа', 'Четвер', 'П’ятниця'];
  final _scheduleBox = Hive.box<Schedule>('schedule');

  late ThemeMode _selectedThemeMode;

  @override
  void initState() {
    super.initState();
    _selectedThemeMode = widget.currentThemeMode;
    _initSchedule();
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
              decoration: const InputDecoration(
                hintText: 'Математика, Читання',
              ),
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
                child: const Text('Зберегти'),
              ),
            ],
          ),
    );
  }

  void _onThemeChanged(ThemeMode? mode) {
    if (mode == null) return;
    setState(() {
      _selectedThemeMode = mode;
    });
    if (widget.onThemeChanged != null) {
      widget.onThemeChanged!(mode);
    }
  }

  @override
  Widget build(BuildContext context) {
    final schedule = _scheduleBox.get('main');

    return ListView(
      children: [
        ListTile(
          title: const Text('Тема оформлення'),
          subtitle: Text(
            _selectedThemeMode == ThemeMode.system
                ? 'Системна'
                : _selectedThemeMode == ThemeMode.dark
                ? 'Темна'
                : 'Світла',
          ),
        ),
        RadioListTile<ThemeMode>(
          title: const Text('Світла'),
          value: ThemeMode.light,
          groupValue: _selectedThemeMode,
          onChanged: _onThemeChanged,
        ),
        RadioListTile<ThemeMode>(
          title: const Text('Темна'),
          value: ThemeMode.dark,
          groupValue: _selectedThemeMode,
          onChanged: _onThemeChanged,
        ),
        RadioListTile<ThemeMode>(
          title: const Text('Системна'),
          value: ThemeMode.system,
          groupValue: _selectedThemeMode,
          onChanged: _onThemeChanged,
        ),
        const Divider(),
        const ListTile(title: Text('Розклад')),
        for (var day in _days)
          ListTile(
            title: Text('$day: ${schedule?.lessons[day]?.join(', ') ?? ''}'),
            trailing: const Icon(Icons.edit),
            onTap: () => _editDay(day),
          ),
      ],
    );
  }
}
