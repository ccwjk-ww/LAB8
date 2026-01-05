import 'package:flutter/material.dart';
import '../models/task.dart';

// ❌ StatefulWidget ที่เก็บ state ภายใน - มีปัญหาเมื่อไม่มี Key
class EditableTaskItem extends StatefulWidget {
  final Task task;
  final VoidCallback onDelete;

  const EditableTaskItem({
    // ⚠️ ไม่มี key!
    super.key,
    required this.task,
    required this.onDelete,
  });

  @override
  State<EditableTaskItem> createState() => _EditableTaskItemState();
}

class _EditableTaskItemState extends State<EditableTaskItem> {
  // 📦 State ที่เก็บอยู่ใน StatefulWidget
  late TextEditingController _controller;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.task.title);
    print('initState: ${widget.task.title}');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        title: _isEditing
            ? TextField(
          controller: _controller,
          autofocus: true,
          onSubmitted: (_) => setState(() => _isEditing = false),
        )
            : Text(widget.task.title),
        leading: CircleAvatar(
          child: Text(widget.task.title[0]),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(_isEditing ? Icons.check : Icons.edit),
              onPressed: () => setState(() => _isEditing = !_isEditing),
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: widget.onDelete,
            ),
          ],
        ),
      ),
    );
  }
}