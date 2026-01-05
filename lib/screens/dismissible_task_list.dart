import 'package:flutter/material.dart';
import '../models/task.dart';
import '../widgets/add_task_dialog.dart';

class DismissibleTaskList extends StatefulWidget {
  const DismissibleTaskList({super.key});

  @override
  State<DismissibleTaskList> createState() => _DismissibleTaskListState();
}

class _DismissibleTaskListState extends State<DismissibleTaskList> {
  final List<Task> _tasks = [
    Task(
      id: '1',
      title: 'Fix You',
      artist: 'Coldplay',
      imageUrl: 'https://picsum.photos/200?1',
      isFavorite: true,
    ),
    Task(
      id: '2',
      title: 'Perfect',
      artist: 'Ed Sheeran',
      imageUrl: 'https://picsum.photos/200?2',
    ),
  ];

  Task? _lastDeletedTask;
  int? _lastDeletedIndex;
  String _searchText = '';

  void _addTask(Task task) {
    setState(() {
      _tasks.insert(0, task);
    });
  }

  void _deleteTask(int index) {
    setState(() {
      _lastDeletedTask = _tasks[index];
      _lastDeletedIndex = index;
      _tasks.removeAt(index);
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.info_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'ลบ "${_lastDeletedTask!.title}" แล้ว',
                style: const TextStyle(fontSize: 15),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.red.shade400,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        action: SnackBarAction(
          label: 'เรียกคืน',
          textColor: Colors.white,
          onPressed: _undoDelete,
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _undoDelete() {
    if (_lastDeletedTask != null && _lastDeletedIndex != null) {
      setState(() {
        _tasks.insert(_lastDeletedIndex!, _lastDeletedTask!);
        _lastDeletedTask = null;
        _lastDeletedIndex = null;
      });
    }
  }

  List<Task> get _filteredTasks {
    return _tasks
        .where((task) =>
    task.title.toLowerCase().contains(_searchText.toLowerCase()) ||
        task.artist.toLowerCase().contains(_searchText.toLowerCase()))
        .toList();
  }

  void _toggleComplete(Task task) {
    setState(() {
      final index = _tasks.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        _tasks[index] =
            _tasks[index].copyWith(isCompleted: !_tasks[index].isCompleted);
      }
    });
  }

  void _toggleFavorite(Task task) {
    setState(() {
      final index = _tasks.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        _tasks[index] =
            _tasks[index].copyWith(isFavorite: !_tasks[index].isFavorite);
      }
    });
  }

  Future<void> _showAddTaskDialog() async {
    final task = await showDialog<Task>(
      context: context,
      builder: (context) => const AddTaskDialog(),
    );

    if (task != null) {
      _addTask(task);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.deepPurple.shade400,
              Colors.deepPurple.shade800,
              Colors.purple.shade900,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom App Bar
              Container(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(
                            Icons.headphones,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'My Playlist',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              Text(
                                'เพลงโปรดของคุณ',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Search Bar
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'ค้นหาเพลง หรือศิลปิน...',
                          hintStyle: TextStyle(color: Colors.grey.shade400),
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.deepPurple.shade400,
                          ),
                          suffixIcon: _searchText.isNotEmpty
                              ? IconButton(
                            icon: Icon(
                              Icons.clear,
                              color: Colors.grey.shade400,
                            ),
                            onPressed: () {
                              setState(() => _searchText = '');
                            },
                          )
                              : null,
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                        ),
                        onChanged: (value) {
                          setState(() => _searchText = value);
                        },
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Stats Row
                    Row(
                      children: [
                        _buildStatCard(
                          icon: Icons.music_note,
                          label: 'ทั้งหมด',
                          value: '${_tasks.length}',
                          color: Colors.blue,
                        ),
                        const SizedBox(width: 12),
                        _buildStatCard(
                          icon: Icons.favorite,
                          label: 'โปรด',
                          value: '${_tasks.where((t) => t.isFavorite).length}',
                          color: Colors.pink,
                        ),
                        const SizedBox(width: 12),
                        _buildStatCard(
                          icon: Icons.check_circle,
                          label: 'ฟังแล้ว',
                          value: '${_tasks.where((t) => t.isCompleted).length}',
                          color: Colors.green,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Task List
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(top: 10),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: _filteredTasks.isEmpty
                      ? _buildEmptyState()
                      : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 100),
                    itemCount: _filteredTasks.length,
                    itemBuilder: (context, index) {
                      final task = _filteredTasks[index];
                      return _buildTaskCard(task, index);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddTaskDialog,
        backgroundColor: Colors.deepPurple,
        elevation: 8,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'เพิ่มเพลง',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white, size: 24),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(
              _searchText.isEmpty ? Icons.music_note : Icons.search_off,
              size: 64,
              color: Colors.grey.shade400,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _searchText.isEmpty
                ? 'ยังไม่มีเพลงในเพลย์ลิสต์'
                : 'ไม่พบเพลงที่ค้นหา',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _searchText.isEmpty
                ? 'กดปุ่มด้านล่างเพื่อเพิ่มเพลงใหม่'
                : 'ลองค้นหาด้วยคำอื่น',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskCard(Task task, int index) {
    return Dismissible(
      key: ValueKey(task.id),
      background: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green.shade400, Colors.green.shade600],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 24),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle, color: Colors.white, size: 32),
            SizedBox(height: 4),
            Text(
              'ฟังแล้ว',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      secondaryBackground: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.red.shade400, Colors.red.shade600],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.delete_sweep, color: Colors.white, size: 32),
            SizedBox(height: 4),
            Text(
              'ลบ',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          _toggleComplete(task);
          return false;
        }
        return true;
      },
      onDismissed: (_) {
        _deleteTask(_tasks.indexWhere((t) => t.id == task.id));
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: task.isFavorite
                  ? Colors.pink.withOpacity(0.3)
                  : Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
          border: task.isFavorite
              ? Border.all(color: Colors.pink.shade200, width: 2)
              : null,
        ),
        child: Stack(
          children: [
            // Gradient overlay for completed tasks
            if (task.isCompleted)
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    colors: [
                      Colors.green.withOpacity(0.1),
                      Colors.green.withOpacity(0.05),
                    ],
                  ),
                ),
              ),

            ListTile(
              contentPadding: const EdgeInsets.all(12),

              // Album Image
              leading: Hero(
                tag: 'task-${task.id}',
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        task.imageUrl,
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.deepPurple.shade300,
                                Colors.deepPurple.shade600,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(
                            Icons.music_note,
                            size: 32,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    if (task.isCompleted)
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(
                            Icons.check_circle,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // Title & Artist
              title: Row(
                children: [
                  Expanded(
                    child: Text(
                      task.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        decoration: task.isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                        color: task.isCompleted
                            ? Colors.grey
                            : Colors.black87,
                      ),
                    ),
                  ),
                  if (task.isFavorite)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.pink.shade300, Colors.pink.shade500],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.favorite, color: Colors.white, size: 14),
                          SizedBox(width: 4),
                          Text(
                            'โปรด',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),

              subtitle: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Row(
                  children: [
                    Icon(
                      Icons.person,
                      size: 14,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        task.artist,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Action Buttons
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Favorite Button
                  Container(
                    decoration: BoxDecoration(
                      color: task.isFavorite
                          ? Colors.pink.shade50
                          : Colors.grey.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(
                        task.isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: task.isFavorite
                            ? Colors.pink.shade400
                            : Colors.grey.shade400,
                      ),
                      onPressed: () => _toggleFavorite(task),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Play/Complete Button
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: task.isCompleted
                            ? [Colors.green.shade400, Colors.green.shade600]
                            : [
                          Colors.deepPurple.shade400,
                          Colors.deepPurple.shade600
                        ],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(
                        task.isCompleted ? Icons.headphones : Icons.play_arrow,
                        color: Colors.white,
                      ),
                      onPressed: () => _toggleComplete(task),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}