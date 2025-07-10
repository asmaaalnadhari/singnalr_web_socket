import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'data/datasources/task_remote_data_source.dart';
import 'data/repositories/task_repository_impl.dart';

import 'domain/usecases/add_task_use_case.dart';
import 'domain/usecases/get_tasks_stream_use_case.dart';
import 'presentation/bloc/task_bloc.dart';
import 'presentation/pages/task_page.dart';

void main() {
  // Create your SignalR data source:
  final remote = TaskRemoteDataSourceImpl("http://localhost:5000/tasksHub");

  //  repository + use-cases:
  final repo = TaskRepositoryImpl(remote);
  final getTasks = GetTasksStream(repo);
  final addTask  = AddTask(repo);

  runApp(
    MaterialApp(
      home: BlocProvider(
        create: (_) =>
        TaskBloc(getTasks: getTasks, addTask: addTask)
          ..add(LoadTasks()),    // start listening immediately
        child: TaskPage(),
      ),
    ),
  );
}
