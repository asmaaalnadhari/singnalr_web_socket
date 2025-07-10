part of 'task_bloc.dart';


abstract class TaskEvent {}

class LoadTasks extends TaskEvent {}

class AddTaskEvent extends TaskEvent {
  final String title;
  AddTaskEvent(this.title);
}

class TasksUpdatedEvent extends TaskEvent {
  final List<Task> tasks;
  TasksUpdatedEvent(this.tasks);
}
