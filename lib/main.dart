import 'package:flutter/material.dart';

void main() {
  runApp(const TaskTrackerApp());
}

class TaskTrackerApp extends StatelessWidget {
  const TaskTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Canonical Task Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFE95420), // Ubuntu Orange
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF111827),
      ),
      home: const TaskHomeScreen(),
    );
  }
}

class TaskItem {
  final String id;
  final String title;
  final String category;
  bool isCompleted;

  TaskItem({
    required this.id,
    required this.title,
    required this.category,
    this.isCompleted = false,
  });
}

class TaskHomeScreen extends StatefulWidget {
  const TaskHomeScreen({super.key});

  @override
  State<TaskHomeScreen> createState() => _TaskHomeScreenState();
}

class _TaskHomeScreenState extends State<TaskHomeScreen> {
  final List<TaskItem> _tasks = [
    TaskItem(id: '1', title: 'Review React UI Components', category: 'Frontend'),
    TaskItem(id: '2', title: 'Test Flutter Web Performance', category: 'Multi-platform'),
    TaskItem(id: '3', title: 'Update Ubuntu Server Packages', category: 'DevOps'),
  ];

  final TextEditingController _taskController = TextEditingController();
  String _selectedCategory = 'Frontend';

  void _addTask() {
    if (_taskController.text.trim().isEmpty) return;
    setState(() {
      _tasks.add(
        TaskItem(
          id: DateTime.now().toString(),
          title: _taskController.text.trim(),
          category: _selectedCategory,
        ),
      );
    });
    _taskController.clear();
  }

  void _toggleTask(String id) {
    setState(() {
      final task = _tasks.firstWhere((t) => t.id == id);
      task.isCompleted = !task.isCompleted;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Canonical Task Tracker'),
        backgroundColor: const Color(0xFF1F2937),
        elevation: 0,
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 800),
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAlignment.start,
            children: [
              const Text(
                'Cross-Platform Task Manager',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 5),
              const Text(
                'Built with Flutter Web & Desktop Architecture',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _taskController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: 'Enter new task title...',
                        hintStyle: TextStyle(color: Colors.grey),
                        filled: true,
                        fillColor: Color(0xFF1F2937),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  DropdownButton<String>(
                    value: _selectedCategory,
                    dropdownColor: const Color(0xFF1F2937),
                    style: const TextStyle(color: Colors.white),
                    items: ['Frontend', 'Multi-platform', 'DevOps'].map((cat) {
                      return DropdownMenuItem(value: cat, child: Text(cat));
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedCategory = val);
                    },
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _addTask,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE95420),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    ),
                    child: const Text('Add Task', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
              const SizedBox(height: 25),
              Expanded(
                child: ListView.builder(
                  itemCount: _tasks.length,
                  itemBuilder: (context, index) {
                    final task = _tasks[index];
                    return Card(
                      color: const Color(0xFF1F2937),
                      margin: const EdgeInsets.only(bottom: 10),
                      child: ListTile(
                        leading: Checkbox(
                          value: task.isCompleted,
                          activeColor: const Color(0xFFE95420),
                          onChanged: (_) => _toggleTask(task.id),
                        ),
                        title: Text(
                          task.title,
                          style: TextStyle(
                            color: Colors.white,
                            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                          ),
                        ),
                        subtitle: Text(
                          task.category,
                          style: const TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
