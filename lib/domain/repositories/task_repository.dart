import '../entities/task.dart';

abstract class TaskRepository {
  /// Stream that emits the latest full list of tasks.
  Stream<List<Task>> getTasks();

  /// Add a new task by title.
  Future<void> addTask(String title);
}
