import 'package:flutter/material.dart';

class DismissibleWithConfirm extends StatefulWidget {
  const DismissibleWithConfirm({super.key});

  @override
  State<DismissibleWithConfirm> createState() => _DismissibleWithConfirmState();
}

class _DismissibleWithConfirmState extends State<DismissibleWithConfirm> {
  final List<Map<String, dynamic>> _tasks = [
    {'id': '1', 'title': 'งานสำคัญมาก', 'important': true},
    {'id': '2', 'title': 'งานทั่วไป', 'important': false},
    {'id': '3', 'title': 'ส่งรายงาน', 'important': true},
  ];

  // แสดง Dialog ยืนยันการลบ
  Future<bool?> _showDeleteConfirmation(BuildContext context, String title) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('ยืนยันการลบ'),
        content: Text('คุณต้องการลบ "$title" หรือไม่?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('ยกเลิก'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('ลบ'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dismissible with Confirm')),
      body: ListView.builder(
        itemCount: _tasks.length,
        itemBuilder: (context, index) {
          final task = _tasks[index];

          return Dismissible(
            key: ValueKey(task['id']),

            // จำกัดให้ swipe ได้เฉพาะทางซ้าย (ลบ)
            direction: DismissDirection.endToStart,

            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              child: const Icon(Icons.delete, color: Colors.white, size: 32),
            ),

            // confirmDismiss - return true เพื่อลบ, false เพื่อยกเลิก
            confirmDismiss: (direction) async {
              // ถ้าเป็นงานสำคัญ ต้องถามยืนยันก่อน
              if (task['important'] == true) {
                return await _showDeleteConfirmation(context, task['title']);
              }
              // งานทั่วไปลบได้เลย
              return true;
            },

            onDismissed: (direction) {
              setState(() {
                _tasks.removeAt(index);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('ลบ "${task['title']}" แล้ว')),
              );
            },

            child: Card(
              margin: const EdgeInsets.all(8),
              child: ListTile(
                leading: Icon(
                  task['important'] ? Icons.star : Icons.star_border,
                  color: task['important'] ? Colors.orange : Colors.grey,
                ),
                title: Text(task['title']),
                subtitle: Text(
                  task['important'] ? 'งานสำคัญ - ต้องยืนยันก่อนลบ' : 'ปัดเพื่อลบ',
                  style: TextStyle(
                    color: task['important'] ? Colors.orange : Colors.grey,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}