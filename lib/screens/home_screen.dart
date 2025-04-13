import 'package:flutter/material.dart';
import 'package:todo/models/task.dart';
import 'package:todo/services/task_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TaskService _taskService = TaskService();
  List<Task> tasks = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTasks();
  }

  Future<void> fetchTasks() async {
    final fetchedTasks = await _taskService.getTasks();
    setState(() {
      tasks = fetchedTasks;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My To-Do List"),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : tasks.isEmpty
          ? const Center(child: Text("No tasks yet."))
          : ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          return Card(
            child: ListTile(
              leading: Checkbox(
                value: task.completed,
                onChanged: (_) async {
                  final updatedTask = await _taskService.updateTask(task.id);
                  if (updatedTask != null) {
                    setState(() {
                      final index = tasks.indexWhere((t) => t.id == task.id);
                      tasks[index] = updatedTask;
                    });
                  }
                },
              ),
              title: Text(task.title),
              subtitle: Text(task.description),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () async {
                  await _taskService.deleteTask(task.id);
                  setState(() {
                    tasks.removeWhere((t) => t.id == task.id);
                  });
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              final titleController = TextEditingController();
              final descriptionController = TextEditingController();

              return AlertDialog(
                title: const Text("Add Task"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(labelText: "Title"),
                    ),
                    TextField(
                      controller: descriptionController,
                      decoration: const InputDecoration(labelText: "Description"),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () async {
                      final newTask = Task(
                        id: 0, // temporary, backend should assign actual ID
                        title: titleController.text,
                        description: descriptionController.text,
                        completed: false,
                      );

                      final createdTask = await _taskService.addTask(newTask);
                      if (createdTask != null) {
                        setState(() {
                          tasks.add(createdTask);
                        });
                        Navigator.of(context).pop(); // close the dialog
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Failed to add task")),
                        );
                      }
                    },
                    child: const Text("Add"),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
