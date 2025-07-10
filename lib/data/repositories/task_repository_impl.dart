import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository.dart';
import '../datasources/task_remote_data_source.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskRemoteDataSource remote;

  TaskRepositoryImpl(this.remote);

  @override
  Stream<List<Task>> getTasks() {
    return remote.tasksStream();
  }

  @override
  Future<void> addTask(String title) {
    return remote.sendAddTask(title);
  }
}
