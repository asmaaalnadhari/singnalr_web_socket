import 'dart:async';
import 'package:bloc/bloc.dart';
import '../../domain/entities/task.dart';
import '../../domain/usecases/add_task_use_case.dart';
import '../../domain/usecases/get_tasks_stream_use_case.dart';

part 'task_event.dart';
part 'task_state.dart';


class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final GetTasksStream _getTasks;
  final AddTask _addTask;
  StreamSubscription<List<Task>>? _sub;

  TaskBloc({
    required GetTasksStream getTasks,
    required AddTask addTask,
  })  : _getTasks = getTasks,
        _addTask = addTask,
        super(TaskInitial()) {
    on<LoadTasks>(_onLoad);
    on<AddTaskEvent>(_onAdd);
    on<TasksUpdatedEvent>(_onUpdated);
  }

  Future<void> _onLoad(
      LoadTasks event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    await _sub?.cancel();
    _sub = _getTasks().listen(
          (tasks) => add(TasksUpdatedEvent(tasks)),
      onError: (e) => emit(TaskError(e.toString())),
    );
  }

  void _onAdd(AddTaskEvent event, Emitter<TaskState> emit) {
    _addTask(event.title);
  }

  void _onUpdated(
      TasksUpdatedEvent event, Emitter<TaskState> emit) {
    emit(TaskLoaded(event.tasks));
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
