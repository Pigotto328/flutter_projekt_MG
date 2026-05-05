import 'package:flutter/material.dart';
import 'task_repository.dart';
import 'AddTaskScreen.dart';
import 'EditTaskScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'krakflow',
      home: Homescreen(),
    );
  }
}

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});
  @override
  State<Homescreen> createState() => _Homescreen();
}
class _Homescreen extends State<Homescreen> {
  String selectedFilter = "wszystkie";
  @override
  Widget build(BuildContext context) {
    final int completedTasks = TaskRepository.tasks.where((task) => task.done).length;
    List<Task> filteredTasks = TaskRepository.tasks;
    if (selectedFilter == "wykonane") {
      filteredTasks = TaskRepository.tasks.where((task) => task.done).toList();
    } else if (selectedFilter == "do zrobienia") {
      filteredTasks = TaskRepository.tasks.where((task) => !task.done).toList();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("krakflow"),
        actions: [
          IconButton(
            icon: Icon(
              Icons.delete,
              color: TaskRepository.tasks.isEmpty ? Colors.grey : Colors.red,
            ),
            onPressed: () {
              if (TaskRepository.tasks.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Brak zadań do usunięcia"),
                  ),
                );
              } else {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("Potwierdzenie"),
                      content: const Text("Czy na pewno chcesz usunąć wszystkie zadania?"),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Anuluj"),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              TaskRepository.tasks.clear();
                            });
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Wszystkie zadania zostały usunięte"),
                              ),
                            );
                          },
                          child: const Text("Usuń"),
                        ),
                      ],
                    );
                  },
                );
              }
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "masz ${TaskRepository.tasks.length} zadań, wykonano $completedTasks",
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () {
                          setState(() {
                            selectedFilter = "wszystkie";
                          });
                        },
                        child: Text(
                          "Wszystkie",
                          style: TextStyle(color: selectedFilter == "wszystkie" ? Colors.blue : Colors.grey),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            selectedFilter = "do zrobienia";
                          });
                        },
                        child: Text(
                          "Do zrobienia",
                          style: TextStyle(color: selectedFilter == "do zrobienia" ? Colors.blue : Colors.grey),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            selectedFilter = "wykonane";
                          });
                        },
                        child: Text(
                          "Wykonane",
                          style: TextStyle(color: selectedFilter == "wykonane" ? Colors.blue : Colors.grey),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredTasks.length,
                itemBuilder: (context, index) {
                  final task = filteredTasks[index];
                  return Dismissible(
                    key: ValueKey(task.title),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Zadanie usunięte"),
                        ),
                      );
                      setState(() {
                        TaskRepository.tasks.remove(task);
                      });
                    },
                    child: TaskCard(
                      title: task.title,
                      deadline: task.deadline,
                      done: task.done,
                      priority: task.priority,
                      onChanged: (value) {
                        setState(() {
                          int realIndex = TaskRepository.tasks.indexOf(task);
                          if (realIndex != -1) {
                            TaskRepository.tasks[realIndex] = Task(
                              title: task.title,
                              deadline: task.deadline,
                              done: value ?? false,
                              priority: task.priority,
                            );
                          }
                        });
                      },
                      onTap: () async {
                        final Task? updatedTask = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditTaskScreen(task: task),
                          ),
                        );
                        if (updatedTask != null) {
                          setState(() {
                            int realIndex = TaskRepository.tasks.indexOf(task);
                            if (realIndex != -1) {
                              TaskRepository.tasks[realIndex] = updatedTask;
                            }
                          });
                        }
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final Task? newTask = await Navigator.push(
            context,
            PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 250),
              pageBuilder: (context, animation, secondaryAnimation) =>
                  AddTaskScreen(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return FadeTransition(opacity: animation, child: child);
              },
            ),
          );
          if (newTask != null) {
            setState(() {
              TaskRepository.tasks.add(newTask);
            });
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class TaskCard extends StatelessWidget {
  final String title;
  final String deadline;
  final bool done;
  final String priority;
  final ValueChanged<bool?>? onChanged;
  final VoidCallback? onTap;

  const TaskCard({
    super.key,
    required this.title,
    required this.deadline,
    required this.done,
    required this.priority,
    this.onChanged,
    this.onTap,
  });

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'wysoki':
      case 'high':
      case '1':
        return Colors.red;
      case 'średni':
      case 'medium':
      case '2':
        return Colors.orange;
      case 'niski':
      case 'low':
      case '3':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 4,
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.all(8.0),
        leading: Checkbox(
          value: done,
          onChanged: onChanged,
          activeColor: Colors.green,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            decoration: done ? TextDecoration.lineThrough : TextDecoration.none,
            color: done ? Colors.grey : Colors.black,
          ),
        ),
        subtitle: RichText(
          text: TextSpan(
            style: const TextStyle(fontSize: 14, color: Colors.grey),
            children: [
              TextSpan(text: "termin: $deadline | priorytet: "),
              TextSpan(
                text: priority,
                style: TextStyle(
                  color: _getPriorityColor(priority),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}