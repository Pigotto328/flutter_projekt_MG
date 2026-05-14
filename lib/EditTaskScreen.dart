import 'package:flutter/material.dart';
import 'task_repository.dart';
//
class EditTaskScreen extends StatefulWidget {
  final Task task;

  const EditTaskScreen({super.key, required this.task});
  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
  }
class _EditTaskScreenState extends State<EditTaskScreen> {
  late final TextEditingController titleController;
  late final TextEditingController deadlineController;
  late final TextEditingController priorityController ;
  bool isDone = false;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.task.title);
    deadlineController = TextEditingController(text: widget.task.deadline);
    priorityController = TextEditingController(text: widget.task.priority);
    isDone = widget.task.done;
  }

  @override
  void dispose() {
    titleController.dispose();
    deadlineController.dispose();
    priorityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edytuj zadanie"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: "Tytuł zadania",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: deadlineController,
                decoration: const InputDecoration(
                  labelText: "Deadline",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: priorityController,
                decoration: const InputDecoration(
                  labelText: "Priorytet",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),

              CheckboxListTile(
                title: const Text("Zadanie wykonane"),
                value: isDone,
                onChanged: (bool? value) {
                  setState(() {
                    isDone = value ?? false;
                  });
                },
              ),
              const SizedBox(height: 15),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final updatedTask = Task(
                      id: widget.task.id,
                      title: titleController.text,
                      deadline: deadlineController.text,
                      done: isDone,
                      priority: priorityController.text,
                    );
                    Navigator.pop(context, updatedTask);
                  },
                  child: const Text("Zapisz"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}




