//
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
class TaskRepository {
  static List<Task> tasks = [
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
}