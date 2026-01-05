import 'package:flutter/material.dart';

class BasicDismissibleExample extends StatefulWidget {
  const BasicDismissibleExample({super.key});

  @override
  State<BasicDismissibleExample> createState() => _BasicDismissibleExampleState();
}

class _BasicDismissibleExampleState extends State<BasicDismissibleExample> {
  // รายการ items - ใช้ unique ID
  final List<Map<String, dynamic>> _items = [
    {'id': '1', 'title': 'เรียน Flutter'},
    {'id': '2', 'title': 'ทำ Lab Dismissible'},
    {'id': '3', 'title': 'อ่านเอกสาร Key'},
    {'id': '4', 'title': 'ฝึก Drag and Drop'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Basic Dismissible')),
      body: ListView.builder(
        itemCount: _items.length,
        itemBuilder: (context, index) {
          final item = _items[index];

          return Dismissible(
            // Key ต้องไม่ซ้ำกัน - ใช้ ID ของ item
            key: ValueKey(item['id']),

            // Background เมื่อ swipe (แสดงสีแดงและไอคอนลบ)
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 20),
              child: const Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),

            // เมื่อ dismiss สำเร็จ - ลบออกจาก list
            onDismissed: (direction) {
              setState(() {
                _items.removeAt(index);
              });

              // แสดง SnackBar บอกผู้ใช้
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('ลบ "${item['title']}" แล้ว'),
                  action: SnackBarAction(
                    label: 'Undo',
                    onPressed: () {
                      // TODO: Implement undo
                    },
                  ),
                ),
              );
            },

            // Child คือ Widget ที่จะแสดง
            child: Card(
              margin: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              child: ListTile(
                leading: CircleAvatar(
                  child: Text('${index + 1}'),
                ),
                title: Text(item['title']),
                subtitle: const Text('ปัดไปทางซ้ายเพื่อลบ'),
              ),
            ),
          );
        },
      ),
    );
  }
}