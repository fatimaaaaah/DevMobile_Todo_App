import 'package:flutter/material.dart';
import 'task_tile.dart';
import '../providers/task_provider.dart';

class TaskList extends StatelessWidget {
  final TaskProvider taskProvider;

  TaskList({required this.taskProvider});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: taskProvider.filteredTasks.length,
      itemBuilder: (context, index) {
        return TaskTile(task: taskProvider.filteredTasks[index]);
      },
    );
  }
}
