import 'dart:async';
import 'package:signalr_netcore/signalr_client.dart';
import '../models/task_model.dart';

abstract class TaskRemoteDataSource {
  Stream<List<TaskModel>> tasksStream();
  Future<void> sendAddTask(String title);
  Future<void> dispose();
}

class TaskRemoteDataSourceImpl implements TaskRemoteDataSource {
  final HubConnection _hub;
  final _controller = StreamController<List<TaskModel>>();

  TaskRemoteDataSourceImpl(String url)
      : _hub = HubConnectionBuilder().withUrl(url).build() {
    _init();
  }

  Future<void> _init() async {
    await _hub.start();
    _hub.on('TasksUpdated', (args) {
      // server sends List<Map<String, dynamic>>
      final raw = args![0] as List;
      final tasks = raw
          .map((e) => TaskModel.fromJson(e as Map<String, dynamic>))
          .toList();
      _controller.add(tasks);
    });
  }

  @override
  Stream<List<TaskModel>> tasksStream() => _controller.stream;

  @override
  Future<void> sendAddTask(String title) =>
      _hub.invoke('AddTask', args: [title]);

  @override
  Future<void> dispose() async {
    await _hub.stop();
    await _controller.close();
  }
}
/*
- Use invoke(...) for client-initiated server calls.

- Use hub.on(...) to register server-initiated client callbacks,
which the Hub triggers via Clients.*.SendAsync(...).

*/