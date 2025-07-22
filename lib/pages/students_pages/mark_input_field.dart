import 'package:flutter/material.dart';

class MarkInputField extends StatefulWidget {
  final String initialMark;
  final void Function(String) onSave;

  const MarkInputField({
    super.key,
    required this.onSave,
    this.initialMark = '',
  });

  @override
  State<MarkInputField> createState() => _MarkInputFieldState();
}

class _MarkInputFieldState extends State<MarkInputField> {
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.initialMark);
  }

  bool isValidMark(String input) {
    final regex = RegExp(r'^[1-5]([+-])?$');
    return regex.hasMatch(input.trim());
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 50,
          child: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: 'Оц.',
              isDense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 6),
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.check),
          color: Colors.green,
          onPressed: () {
            final mark = controller.text.trim();
            if (isValidMark(mark)) {
              widget.onSave(mark);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Оцінку збережено')));
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Введіть оцінку від 1 до 5, з "+" або "-"'),
                ),
              );
            }
          },
        ),
      ],
    );
  }
}
