import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './providers/task_provider.dart';
import '../widgets/task_list.dart';
import './add_task_screen.dart';

class TaskScreen extends StatefulWidget {
  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  String _selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        actions: [
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedFilter,
              items: [
                DropdownMenuItem(
                  child: Text('All'),
                  value: 'All',
                ),
                DropdownMenuItem(
                  child: Text('Todo'),
                  value: 'Todo',
                ),
                DropdownMenuItem(
                  child: Text('In progress'),
                  value: 'In progress',
                ),
                DropdownMenuItem(
                  child: Text('Done'),
                  value: 'Done',
                ),
                DropdownMenuItem(
                  child: Text('Bug'),
                  value: 'Bug',
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedFilter = value!;
                  Provider.of<TaskProvider>(context, listen: false).applyFilters(_selectedFilter);
                });
              },
            ),
          ),
        ],
      ),
      body: Consumer<TaskProvider>(
        builder: (context, taskProvider, child) {
          return TaskList(taskProvider: taskProvider);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AddTaskScreen.routeName).then((value) {
            Provider.of<TaskProvider>(context, listen: false).notifyListeners();
          });
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.grey,
      ),
    );
  }
}
