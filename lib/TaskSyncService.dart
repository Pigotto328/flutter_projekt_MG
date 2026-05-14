import 'TaskApiService.dart';
import 'TaskLocalDatabase.dart';
import 'task_repository.dart';

class TaskSyncService {
  static Future<void> loadInitialDataIfNeeded() async {
    if (TaskLocalDatabase.isEmpty()) {
      final tasks = await TaskApiService.fetchTasks();
      await TaskLocalDatabase.saveTasks(tasks);
    }
  }
}