import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'task_repository.dart';

class TaskApiService {
  static const String _url = 'https://dummyjson.com/todos';

  static Future<List<Task>> fetchTasks() async {
    final response = await http.get(Uri.parse(_url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> todos = data['todos'];

      final List<String> priorities = ['wysoki', 'średni', 'niski'];
      final List<String> deadlines = ['dzisiaj', 'jutro', 'za tydzień', 'brak'];
      final Random random = Random();

      return todos.map((json) {
        return Task(
          title: json['todo'],
          done: json['completed'],
          priority: priorities[random.nextInt(priorities.length)],
          deadline: deadlines[random.nextInt(deadlines.length)],
        );
      }).toList();
    } else {
      throw Exception('Nie udało się pobrać zadań');
    }
  }
}