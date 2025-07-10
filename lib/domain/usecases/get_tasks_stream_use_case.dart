import '../entities/task.dart';
import '../repositories/task_repository.dart';

class GetTasksStream {
  final TaskRepository repository;
  GetTasksStream(this.repository);

  Stream<List<Task>> call() => repository.getTasks();
}
