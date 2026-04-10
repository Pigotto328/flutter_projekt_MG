import 'package:flutter/material.dart';
import 'task_repository.dart';
//
class AddTaskScreen extends StatelessWidget {
  AddTaskScreen({super.key});
  final TextEditingController titleController = TextEditingController();
  final TextEditingController deadlineController = TextEditingController();
  final TextEditingController priorityController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Nowe zadanie"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: "tytuł zadania",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            TextField(
              controller: deadlineController,
              decoration: InputDecoration(
                labelText: "deadline",
                border: OutlineInputBorder()
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            TextField(
              controller: priorityController,
              decoration: InputDecoration(
                  labelText: "priorytet",
                  border: OutlineInputBorder()
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            ElevatedButton(onPressed: () {
              final newTask = Task(
                title: titleController.text,
                deadline: deadlineController.text,
                done: false,
                priority: priorityController.text
              );
              Navigator.pop(context, newTask);
            },
                child: Text("zapisz")
            ),
          ],
        ),
      )
    );
  }
}
