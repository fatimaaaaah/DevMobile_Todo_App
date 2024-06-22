import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [
    Task(name: 'Task 1', description: 'Description for Task 1', status: 'Todo'),
    Task(name: 'Task 2', description: 'Description for Task 2', status: 'In progress'),
    Task(name: 'Task 3', description: 'Description for Task 3', status: 'Bug'),
    Task(name: 'Task 4', description: 'Description for Task 4', status: 'Bug'),
    Task(name: 'Task 5', description: 'Description for Task 5', status: 'Todo'),
    Task(name: 'Task 6', description: 'Description for Task 6', status: 'Todo'),
    Task(name: 'Task 7', description: 'Description for Task 7', status: 'Done'),
    Task(name: 'Task 8', description: 'Description for Task 8', status: 'Todo'),
    Task(name: 'Task 9', description: 'Description for Task 9', status: 'In progress'),
    Task(name: 'Task 10', description: 'Description for Task 10', status: 'Bug'),
    Task(name: 'Task 11', description: 'Description for Task 11', status: 'Bug'),
    Task(name: 'Task 12', description: 'Description for Task 12', status: 'Todo'),
    Task(name: 'Task 13', description: 'Description for Task 13', status: 'Todo'),
    Task(name: 'Task 14', description: 'Description for Task 14', status: 'Done'),
  ];

  List<Task> _filteredTasks = [];

  TaskProvider() {
    _filteredTasks = _tasks;
  }

  List<Task> get tasks => _tasks;
  List<Task> get filteredTasks => _filteredTasks;

  void addTask(Task task) {
    _tasks.add(task);
    notifyListeners();
  }

  void updateTask(int index, Task task) {
    _tasks[index] = task;
    notifyListeners();
  }

  void applyFilters(String filter) {
    if (filter == 'All') {
      _filteredTasks = _tasks;
    } else {
      _filteredTasks = _tasks.where((task) => task.status == filter).toList();
    }
    notifyListeners();
  }
}
