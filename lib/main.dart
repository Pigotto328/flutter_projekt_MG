import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  final List<Task> tasks = const [
    Task(title: "Projekt Flutter", deadline: "jutro"),
    Task(title: "Ćwiczenia z matematyki", deadline: "dzisiaj"),
    Task(title: "Przeczytać o widgetach", deadline: "w tym tygodniu"),
    Task(title: "Przygotowanie do pracy", deadline: "za 2 tygodnie ")
  ];


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        home: Column(
          children: [
            Text("ZADANIE",
                style: TextStyle(
                  fontSize: 64,
                  fontWeight: FontWeight.bold,
                )),
            Expanded(child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return TaskCard(
                    title: tasks[index].title,
                    deadline: tasks[index].deadline,
                    icon: tasks[index].icon
                );
              },
            ))
          ],
        )
    );
  }
}

class Task {
  final String title;
  final String deadline;
  final IconData icon = Icons.one_x_mobiledata_rounded;

  const Task({required this.title, required this.deadline});
}

class TaskCard extends StatelessWidget {
  final String title;
  final String deadline;
  final IconData icon;

  const TaskCard({
    super.key,
    required this.title,
    required this.deadline,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 4,
      child: Padding(padding: const EdgeInsets.all(16.0),
          child: Row(children: [
              Icon(icon, size: 32, color: Colors.blue),
      const SizedBox(width: 16),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(deadline,
            style: TextStyle(fontSize: 14, color: Colors.grey,
            ),
          ),
        ],
      ),
      ),
      ],
    ),)
    ,
    );
  }
}