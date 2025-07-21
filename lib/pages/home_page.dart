import 'package:flutter/material.dart';
import 'package:school/pages/students_page.dart';
import 'package:school/pages/examples_page.dart';
import 'package:school/pages/settings_page.dart';
import 'package:audioplayers/audioplayers.dart';

class HomePage extends StatefulWidget {
  final void Function(ThemeMode) toggleTheme;
  final ThemeMode currentThemeMode;

  const HomePage({
    super.key,
    required this.toggleTheme,
    required this.currentThemeMode,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  late final List<Widget> _screens;
  final AudioPlayer _player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _screens = [
      StudentsPage(),
      ExamplesPage(),
      SettingsPage(
        onThemeChanged: widget.toggleTheme,
        currentThemeMode: widget.currentThemeMode,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Школа'),
        actions: [
          IconButton(
            icon: const Icon(Icons.campaign),
            onPressed: () async {
              await _player.play(AssetSource('sounds/bell.mp3'));
              if (!context.mounted) return;
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Дзвоник!')));
            },
          ),
        ],
        iconTheme: const IconThemeData(color: Colors.teal),
      ),
      drawer: NavigationDrawer(
        onDestinationSelected: (index) {
          setState(() => _selectedIndex = index);
          Navigator.pop(context);
        },
        selectedIndex: _selectedIndex,
        children: const [
          NavigationDrawerDestination(
            icon: Icon(Icons.people, color: Colors.teal),
            label: Text('Учні'),
          ),
          NavigationDrawerDestination(
            icon: Icon(
              Icons.calculate,
              color: Color.fromARGB(255, 241, 183, 7),
            ),
            label: Text('Приклади'),
          ),
          NavigationDrawerDestination(
            icon: Icon(Icons.settings, color: Colors.grey),
            label: Text('Налаштування'),
          ),
        ],
      ),
      body: _screens[_selectedIndex],
    );
  }
}
