import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/task_bloc.dart';


class TaskPage extends StatelessWidget {
  final _controller = TextEditingController();

  TaskPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Real-time To-Do List')),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<TaskBloc, TaskState>(
              builder: (ctx, state) {
                if (state is TaskLoading) {
                  return Center(child: CircularProgressIndicator());
                }
                if (state is TaskError) {
                  return Center(child: Text('Error: ${state.message}'));
                }
                if (state is TaskLoaded) {
                  return ListView(
                    children: state.tasks.map((t) {
                      return ListTile(
                        title: Text(t.title),
                        trailing: Checkbox(
                          value: t.completed,
                          onChanged: null,
                        ),
                      );
                    }).toList(),
                  );
                }
                return Center(child: Text('No tasks yet.'));
              },
            ),
          ),

          // input row
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(hintText: 'New task'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    final title = _controller.text.trim();
                    if (title.isNotEmpty) {
                      context.read<TaskBloc>().add(AddTaskEvent(title));
                      _controller.clear();
                    }
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
