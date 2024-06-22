import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../models/task.dart';

class TaskDialog extends StatefulWidget {
  final Task? task;
  final int? index;

  TaskDialog({this.task, this.index});

  @override
  _TaskDialogState createState() => _TaskDialogState();
}

class _TaskDialogState extends State<TaskDialog> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late String _description;
  late String _status;

  @override
  void initState() {
    super.initState();
    _name = widget.task?.name ?? '';
    _description = widget.task?.description ?? '';
    _status = widget.task?.status ?? 'Todo';
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.task == null ? 'Add Task' : 'Update Task'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextFormField(
              initialValue: _name,
              decoration: InputDecoration(labelText: 'Task Name'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a task name';
                }
                return null;
              },
              onSaved: (value) {
                _name = value!;
              },
            ),
            TextFormField(
              initialValue: _description,
              maxLines: 3,
              decoration: InputDecoration(labelText: 'Description'),
              onSaved: (value) {
                _description = value!;
              },
            ),
            DropdownButtonFormField<String>(
              value: _status,
              items: [
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
                  _status = value!;
                });
              },
              decoration: InputDecoration(labelText: 'Status'),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        ElevatedButton(
          child: Text(widget.task == null ? 'Add' : 'Update'),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              final taskProvider = Provider.of<TaskProvider>(context, listen: false);
              if (widget.task == null) {
                taskProvider.addTask(Task(
                  name: _name,
                  description: _description,
                  status: _status,
                ));
              } else {
                taskProvider.updateTask(widget.index!, Task(
                  name: _name,
                  description: _description,
                  status: _status,
                ));
              }
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }
}
