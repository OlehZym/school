// pages/examples_page.dart
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/example.dart';
import 'dart:math';

class ExamplesPage extends StatefulWidget {
  const ExamplesPage({super.key});

  @override
  State<ExamplesPage> createState() => _ExamplesPageState();
}

class _ExamplesPageState extends State<ExamplesPage> {
  final examplesBox = Hive.box<Example>('examples');

  final TextEditingController minController = TextEditingController(text: '0');
  final TextEditingController maxController = TextEditingController(
    text: '100',
  );

  int minValue = 0;
  int maxValue = 100;
  int exampleCount = 10;

  void _generateExamples(int count, int minNum, int maxNum) {
    final rnd = Random();
    for (int i = 0; i < count; i++) {
      int a = minNum + rnd.nextInt(maxNum - minNum + 1);
      int b = minNum + rnd.nextInt(maxNum - minNum + 1);
      String op = rnd.nextBool() ? '+' : '-';

      if (op == '-' && a < b) {
        int temp = a;
        a = b;
        b = temp;
      }

      int result = op == '+' ? a + b : a - b;

      final example = Example(left: a, right: b, operation: op, answer: result);
      examplesBox.add(example);
    }
  }

  void _checkAnswers() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Перевірка'),
            content: Text('Приклади позначені як перевірені.'),
            actions: [
              TextButton(
                onPressed: () {
                  for (var ex in examplesBox.values) {
                    ex.checked = true;
                    ex.save();
                  }
                  Navigator.pop(context);
                  setState(() {});
                },
                child: Text('OK'),
              ),
            ],
          ),
    );
  }

  void _deleteAll() {
    examplesBox.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        OverflowBar(
          alignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Column(
                  children: [
                    ElevatedButton.icon(
                      icon: Icon(
                        Icons.add,
                        color: const Color.fromARGB(255, 33, 72, 243),
                        size: 25,
                      ),
                      label: Text(
                        'Генерувати',
                        style: TextStyle(
                          color: const Color.fromARGB(255, 33, 72, 243),
                        ),
                      ),
                      onPressed:
                          () => _generateExamples(
                            exampleCount,
                            minValue,
                            maxValue,
                          ),
                    ),

                    ElevatedButton.icon(
                      icon: Icon(
                        Icons.check,
                        color: const Color.fromARGB(255, 14, 177, 20),
                        size: 25,
                      ),
                      label: Text(
                        'Перевірити',
                        style: TextStyle(
                          color: const Color.fromARGB(255, 14, 177, 20),
                        ),
                      ),
                      onPressed: _checkAnswers,
                    ),
                    ElevatedButton.icon(
                      icon: Icon(Icons.clear, color: Colors.red, size: 25),
                      label: Text(
                        'Очистити',
                        style: TextStyle(color: Colors.red),
                      ),
                      onPressed: _deleteAll,
                    ),
                  ],
                ),
                SizedBox(width: 20),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Кількість прикладів:'),
                    NumberPicker(
                      value: exampleCount,
                      minValue: 1,
                      maxValue: 20,
                      onChanged:
                          (value) => setState(() => exampleCount = value),
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 60,
                          child: Column(
                            children: [
                              Text('Мін'),
                              TextField(
                                controller: minController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  hintText: 'Мін',
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 4,
                                    horizontal: 6,
                                  ),
                                ),
                                onChanged: (value) {
                                  final parsed = int.tryParse(value);
                                  if (parsed != null) {
                                    setState(() {
                                      minValue = parsed;
                                    });
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        SizedBox(
                          width: 60,
                          child: Column(
                            children: [
                              Text('Макс'),
                              TextField(
                                controller: maxController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  hintText: 'Макс',
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 4,
                                    horizontal: 6,
                                  ),
                                ),
                                onChanged: (value) {
                                  final parsed = int.tryParse(value);
                                  if (parsed != null) {
                                    setState(() {
                                      maxValue = parsed;
                                    });
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        const Divider(),
        Expanded(
          child: ValueListenableBuilder(
            valueListenable: examplesBox.listenable(),
            builder: (context, Box<Example> box, _) {
              if (box.isEmpty) return Center(child: Text('Немає прикладів'));

              return ListView.builder(
                itemCount: box.length,
                itemBuilder: (context, index) {
                  final ex = box.getAt(index)!;
                  return ListTile(
                    title: Text(
                      '${ex.question} ${ex.checked ? ex.answer : '____'}',
                    ),
                    trailing:
                        ex.checked
                            ? Icon(Icons.check, color: Colors.green)
                            : null,
                    onLongPress: () {
                      ex.delete();
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
