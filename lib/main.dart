import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/student.dart';
import 'models/example.dart';
import 'models/schedule.dart';
import 'package:school/pages/home_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(StudentAdapter());
  Hive.registerAdapter(ExampleAdapter());
  Hive.registerAdapter(ScheduleAdapter());
  await Hive.openBox<Student>('students');
  await Hive.openBox<Example>('examples');
  await Hive.openBox<Schedule>('schedule');

  final prefs = await SharedPreferences.getInstance();
  final themeIndex = prefs.getInt('themeMode') ?? 2; // 0=light,1=dark,2=system

  runApp(SchoolApp(initialThemeMode: ThemeMode.values[themeIndex]));
}

class SchoolApp extends StatefulWidget {
  final ThemeMode initialThemeMode;
  const SchoolApp({super.key, required this.initialThemeMode});

  @override
  State<SchoolApp> createState() => _SchoolAppState();
}

class _SchoolAppState extends State<SchoolApp> {
  late ThemeMode _themeMode;

  @override
  void initState() {
    super.initState();
    _themeMode = widget.initialThemeMode;
  }

  Future<void> _toggleTheme(ThemeMode newTheme) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('themeMode', newTheme.index);
    setState(() {
      _themeMode = newTheme;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Школа',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: _themeMode,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('uk', 'UA'), Locale('en', 'US')],
      home: HomePage(toggleTheme: _toggleTheme, currentThemeMode: _themeMode),
    );
  }
}
