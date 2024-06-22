import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../models/task.dart';

class AddTaskScreen extends StatelessWidget {
  static const routeName = '/add-task';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Ajouter une tâche', style: TextStyle(fontSize: 24)),
                Container(
                  width: 120.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: DropdownButtonFormField<String>(
                    value: 'Todo',
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
                      // handle status change
                    },
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            AddTaskForm(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context); // Close the add task screen
        },
        child: Icon(Icons.close),
        backgroundColor: Colors.grey,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

class AddTaskForm extends StatefulWidget {
  @override
  _AddTaskFormState createState() => _AddTaskFormState();
}

class _AddTaskFormState extends State<AddTaskForm> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late String _description;
  late String _status;

  @override
  void initState() {
    super.initState();
    _name = '';
    _description = '';
    _status = 'Todo';
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 20),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Task Name',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
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
          SizedBox(height: 20),
          TextFormField(
            initialValue: _description,
            maxLines: 5,
            decoration: InputDecoration(
              labelText: 'Description',
             
