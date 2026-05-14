import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'task_repository.dart';
import 'AddTaskScreen.dart';
import 'EditTaskScreen.dart';
import 'TaskLocalDatabase.dart';
import 'TaskSyncService.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox("tasks");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'krakflow',
      home: const Homescreen(),
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
  late Future<List<Task>> tasksFuture;

  int allTasksCount = 0;
  int doneTasksCount = 0;
  int todoTasksCount = 0;

  @override
  void initState() {
    super.initState();
    tasksFuture = loadTasks();
  }

  Future<List<Task>> loadTasks() async {
    await TaskSyncService.loadInitialDataIfNeeded();
    return TaskLocalDatabase.getTasks();
  }

  void updateCounters(List<Task> tasks) {
    setState(() {
      allTasksCount = tasks.length;
      doneTasksCount = tasks.where((task) => task.done).length;
      todoTasksCount = tasks.where((task) => !task.done).length;
    });
  }

  void refreshData() {
    setState(() {
      tasksFuture = loadTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("krakflow"),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Potwierdzenie"),
                  content: const Text("Czy na pewno chcesz usunąć wszystkie zadania?"),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context), child: const Text("Anuluj")),
                    TextButton(
                      onPressed: () async {
                        await TaskLocalDatabase.deleteAllTasks();
                        Navigator.pop(context);
                        refreshData();
                      },
                      child: const Text("Usuń"),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    "masz $allTasksCount zadań, wykonano $doneTasksCount, do zrobienia $todoTasksCount",
                    style: const TextStyle(fontWeight: FontWeight.bold)
                ),
                Row(
                  children: ["wszystkie", "do zrobienia", "wykonane"].map((filter) {
                    return TextButton(
                      onPressed: () => setState(() => selectedFilter = filter),
                      child: Text(filter,
                          style: TextStyle(color: selectedFilter == filter ? Colors.blue : Colors.grey)),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          Expanded(
            child: TaskListScreen(
              tasksFuture: tasksFuture,
              selectedFilter: selectedFilter,
              onTasksLoaded: updateCounters,
              onDataChanged: refreshData,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final Task? result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTaskScreen()),
          );
          if (result != null) {
            await TaskLocalDatabase.addTask(result);
            refreshData();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class TaskListScreen extends StatefulWidget {
  final Future<List<Task>> tasksFuture;
  final String selectedFilter;
  final ValueChanged<List<Task>> onTasksLoaded;
  final VoidCallback onDataChanged;

  const TaskListScreen({
    super.key,
    required this.tasksFuture,
    required this.selectedFilter,
    required this.onTasksLoaded,
    required this.onDataChanged,
  });

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Task>>(
      future: widget.tasksFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
        if (snapshot.hasError) return Center(child: Text("Błąd: ${snapshot.error}"));

        final tasks = snapshot.data ?? [];

        WidgetsBinding.instance.addPostFrameCallback((_) {
          widget.onTasksLoaded(tasks);
        });

        var filteredTasks = List<Task>.from(tasks);
        if (widget.selectedFilter == "wykonane") filteredTasks = filteredTasks.where((t) => t.done).toList();
        if (widget.selectedFilter == "do zrobienia") filteredTasks = filteredTasks.where((t) => !t.done).toList();

        return ListView.builder(
          itemCount: filteredTasks.length,
          itemBuilder: (context, index) {
            final task = filteredTasks[index];
            return Dismissible(
              key: ValueKey(task.id),
              onDismissed: (_) async {
                await TaskLocalDatabase.deleteTask(task.id);
                widget.onDataChanged();
              },
              child: TaskCard(
                title: task.title,
                deadline: task.deadline,
                done: task.done,
                priority: task.priority,
                onChanged: (val) async {
                  final updated = Task(
                    id: task.id,
                    title: task.title,
                    deadline: task.deadline,
                    done: val ?? false,
                    priority: task.priority,
                  );
                  await TaskLocalDatabase.updateTask(updated);
                  widget.onDataChanged();
                },
                onTap: () async {
                  final Task? updated = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EditTaskScreen(task: task)),
                  );
                  if (updated != null) {
                    await TaskLocalDatabase.updateTask(updated);
                    widget.onDataChanged();
                  }
                },
              ),
            );
          },
        );
      },
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

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        onTap: onTap,
        leading: Checkbox(value: done, onChanged: onChanged),
        title: Text(title, style: TextStyle(decoration: done ? TextDecoration.lineThrough : null)),
        subtitle: Text("termin: $deadline | priorytet: $priority"),
      ),
    );
  }
}