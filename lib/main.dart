import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  final List<Task> tasks = const [
    Task(
      title: "Projekt Flutter",
      deadline: "jutro",
      done: true,
      priority: "wysoki",
    ),
    Task(
      title: "Ćwiczenia z matematyki",
      deadline: "dzisiaj",
      done: false,
      priority: "średni",
    ),
    Task(
      title: "Przeczytać o widgetach",
      deadline: "w tym tygodniu",
      done: true,
      priority: "niski",
    ),
    Task(
      title: "Przygotowanie do kolosa",
      deadline: "za 2 tygodnie",
      done: false,
      priority: "wysoki",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final int completedTasks = tasks.where((task) => task.done).length;
    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "masz dziś ${tasks.length} zadania, wykonano $completedTasks",
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "zadania",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    return TaskCard(
                      title: tasks[index].title,
                      deadline: tasks[index].deadline,
                      done: tasks[index].done,
                      priority: tasks[index].priority,
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

class Task {
  final String title;
  final String deadline;
  final bool done;
  final String priority;

  const Task({
    required this.title,
    required this.deadline,
    required this.done,
    required this.priority,
  });
}

class TaskCard extends StatelessWidget {
  final String title;
  final String deadline;
  final bool done;
  final String priority;

  const TaskCard({
    super.key,
    required this.title,
    required this.deadline,
    required this.done,
    required this.priority,
  });

  @override
  Widget build(BuildContext context) {
    final IconData icon = done
        ? Icons.check_circle
        : Icons.radio_button_unchecked;
    final Color iconColor = done ? Colors.green : Colors.grey;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, size: 32, color: iconColor),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "$deadline • Priorytet: $priority",
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
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
