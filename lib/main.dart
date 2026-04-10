import 'package:flutter/material.dart';
import 'task_repository.dart';
import 'AddTaskScreen.dart';
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
class Homescreen extends StatefulWidget{
  const Homescreen({super.key});
  @override
  State<Homescreen> createState() => _Homescreen();
}
class _Homescreen extends State<Homescreen>{


  @override
  Widget build(BuildContext context) {
    final int completedTasks = TaskRepository.tasks.where((task) => task.done).length;
    return Scaffold(
        appBar: AppBar(
          title: Text("krakflow")),
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
                  itemCount: TaskRepository.tasks.length,
                  itemBuilder: (context, index) {
                    return TaskCard(
                      title: TaskRepository.tasks[index].title,
                      deadline: TaskRepository.tasks[index].deadline,
                      done: TaskRepository.tasks[index].done,
                      priority: TaskRepository.tasks[index].priority,
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
              MaterialPageRoute(
                builder: (context) => AddTaskScreen(),
              ),
            );
            if (newTask != null){
              setState((){
                TaskRepository.tasks.add(newTask);
              });
            }
          },
          child: Icon(Icons.add),
        ),
      );
  }
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
