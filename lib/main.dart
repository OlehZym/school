import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
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

  runApp(SchoolApp());
}

class SchoolApp extends StatefulWidget {
  const SchoolApp({super.key});

  @override
  State<SchoolApp> createState() => _SchoolAppState();
}

class _SchoolAppState extends State<SchoolApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleTheme(bool isDark) {
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
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
      home: HomePage(toggleTheme: _toggleTheme),
    );
  }
}
