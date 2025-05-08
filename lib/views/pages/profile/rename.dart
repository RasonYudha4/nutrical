import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/user.dart';

class RenameSheet extends StatefulWidget {
  final String initialName;
  final void Function(String newName) onNameChanged;

  const RenameSheet({
    Key? key,
    required this.initialName,
    required this.onNameChanged,
  }) : super(key: key);

  @override
  State<RenameSheet> createState() => _RenameSheetState();
}

class _RenameSheetState extends State<RenameSheet> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialName);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final newName = _controller.text.trim();
    if (newName.isNotEmpty) {
      widget.onNameChanged(newName);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Enter new name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _submit,
              icon: const Icon(Icons.check),
              label: const Text('Confirm'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(45),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
