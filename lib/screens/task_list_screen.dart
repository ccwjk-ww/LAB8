// import 'package:flutter/material.dart';
// import '../models/task.dart';
// import '../widgets/task_item.dart';
// import '../widgets/add_task_dialog.dart';
//
// class TaskListScreen extends StatefulWidget {
//   const TaskListScreen({super.key});
//
//   @override
//   State<TaskListScreen> createState() => _TaskListScreenState();
// }
//
// class _TaskListScreenState extends State<TaskListScreen> {
//   // รายการ Task ทั้งหมด
//   final List<Task> _tasks = [
//     // ข้อมูลตัวอย่างเริ่มต้น
//     Task.create(title: 'เรียนรู้ Flutter', description: 'ศึกษา Widget พื้นฐาน'),
//     Task.create(title: 'ทำ Lab ListView', description: 'ทำตาม Part 1'),
//     Task.create(title: 'อ่านเอกสาร' , description: 'ทำตามเอกสาร ListView'),
//   ];
//
//   // เพิ่ม Task ใหม่
//   void _addTask(Task task) {
//     setState(() {
//       _tasks.insert(0, task); // เพิ่มด้านบนสุด
//     });
//   }
// // เก็บ task ที่ถูกลบล่าสุด (สำหรับ Undo)
//   Task? _lastDeletedTask;
//   int? _lastDeletedIndex;
//
//   void _deleteTask(int index) {
//     setState(() {
//       _lastDeletedTask = _tasks[index];
//       _lastDeletedIndex = index;
//       _tasks.removeAt(index);
//     });
//
//     ScaffoldMessenger.of(context).clearSnackBars();
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text('ลบ "${_lastDeletedTask!.title}" แล้ว'),
//         action: SnackBarAction(
//           label: 'Undo',
//           onPressed: _undoDelete,
//         ),
//         duration: const Duration(seconds: 3),
//       ),
//     );
//   }
//
//   void _undoDelete() {
//     if (_lastDeletedTask != null && _lastDeletedIndex != null) {
//       setState(() {
//         _tasks.insert(_lastDeletedIndex!, _lastDeletedTask!);
//         _lastDeletedTask = null;
//         _lastDeletedIndex = null;
//       });
//     }
//   }
//
//   void _toggleComplete(int index) {
//     setState(() {
//       _tasks[index] = _tasks[index].copyWith(
//         isCompleted: !_tasks[index].isCompleted,
//       );
//     });
//   }
//
//   // // Toggle สถานะ completed
//   // void _toggleTask(int index, bool? value) {
//   //   if (value == null) return;
//   //   setState(() {
//   //     _tasks[index] = _tasks[index].copyWith(isCompleted: value);
//   //   });
//   // }
//
//   // แสดง Dialog เพิ่ม Task
//   Future<void> _showAddTaskDialog() async {
//     final task = await showDialog<Task>(
//       context: context,
//       builder: (context) => const AddTaskDialog(),
//     );
//
//     if (task != null) {
//       _addTask(task);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Task Manager'),
//         centerTitle: true,
//         backgroundColor: Theme.of(context).colorScheme.primaryContainer,
//         actions: [
//           Padding(
//             padding: const EdgeInsets.only(right: 16),
//             child: Center(
//               child: Text(
//                 '${_tasks.length} tasks',
//                 style: TextStyle(
//                   color: Theme.of(context).colorScheme.onPrimaryContainer,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//       body: _tasks.isEmpty
//           ? Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               Icons.task_outlined,
//               size: 80,
//               color: Colors.grey.shade300,
//             ),
//             const SizedBox(height: 16),
//             Text(
//               'ยังไม่มี Task',
//               style: TextStyle(
//                 fontSize: 18,
//                 color: Colors.grey.shade500,
//               ),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               'กดปุ่ม + เพื่อเพิ่ม Task ใหม่',
//               style: TextStyle(
//                 color: Colors.grey.shade400,
//               ),
//             ),
//           ],
//         ),
//       )
//       // ⭐ นี่คือ ListView.builder ที่เราใช้
//           : ListView.builder(
//         padding: const EdgeInsets.symmetric(vertical: 8),
//         itemCount: _tasks.length,
//         itemBuilder: (context, index) {
//           final task = _tasks[index];
//           return TaskItem(
//             key: ValueKey(task.id),
//             task: task,
//             onToggle: (value) => _toggleComplete(index),
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton.extended(
//         onPressed: _showAddTaskDialog,
//         icon: const Icon(Icons.add),
//         label: const Text('เพิ่ม Task'),
//       ),
//     );
//   }
// }