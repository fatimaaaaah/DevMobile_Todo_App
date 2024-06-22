import 'package:flutter/material.dart'; // Importation du package Flutter pour les widgets Material
import 'package:provider/provider.dart'; // Importation du package Provider pour la gestion d'état

void main() {
  runApp(MyApp()); // Fonction principale qui lance l'application en rendant MyApp
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider( // Utilisation de ChangeNotifierProvider pour gérer l'état global avec TaskProvider
      create: (context) => TaskProvider(),  // Création d'une instance de TaskProvider
      child: MaterialApp(
        title: 'Todo App', // Titre de l'application
        home: TaskScreen(), // Ecran d'accueil de l'application
        debugShowCheckedModeBanner: false, // Désactivation de la bannière de débogage
        routes: {
          AddTaskScreen.routeName: (context) => AddTaskScreen(), // Définition de la route vers AddTaskScreen
          EditTaskScreen.routeName: (context) => EditTaskScreen(),  // Définition de la route vers EditTaskScreen
        }, 
      ),
    );
  }
}

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
    Task(name: 'Task 9', description: 'Description for Task 1', status: 'Todo'),
    Task(name: 'Task 10', description: 'Description for Task 2', status: 'In progress'),
    Task(name: 'Task 11', description: 'Description for Task 3', status: 'Bug'),
  ];

  List<Task> _filteredTasks = []; // Liste filtrée de tâches


  TaskProvider() {
    _filteredTasks = _tasks;  // Initialise _filteredTasks avec _tasks
  }

  List<Task> get tasks => _tasks;  // Getter pour récupérer la liste complète des tâches
  List<Task> get filteredTasks => _filteredTasks;  // Getter pour récupérer la liste filtrée des tâches

 
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

  Color getStatusColor(String status) {  // Méthode pour obtenir la couleur en fonction du statut de la tâche
    switch (status) {
      case 'Todo':
        return Colors.grey;
      case 'In progress':
        return Color(int.parse('0xFF56CCF2'));
      case 'Done':
        return Color(int.parse('0xFF27AE60'));
      case 'Bug':
        return Color(int.parse('0xFFEB5757'));
      default:
        return Colors.grey;
    }
  }
}

class Task {
  String name;
  String description;
  String status;

  Task({required this.name, required this.description, required this.status});
}

class TaskScreen extends StatefulWidget {  // Création de l'état de TaskScreen
  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  String _selectedFilter = 'All';  // Filtre sélectionné par défaut

  @override
  Widget build(BuildContext context) {
    return Scaffold(  // Widget de base pour l'interface utilisateur Material
      appBar: AppBar(
        title: Text('Todo App', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Color(int.parse('0xFF333333')),
        actions: [
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedFilter,
              items: [
                DropdownMenuItem(
                  child: Text('All', style: TextStyle(color: Colors.white)),
                  value: 'All',
                ),
                DropdownMenuItem(
                  child: Text('Todo',  style: TextStyle(color: Colors.white)),
                  value: 'Todo',
                ),
                DropdownMenuItem(
                  child: Text('In progress', style: TextStyle(color: Colors.white)),
                  value: 'In progress',
                ),
                DropdownMenuItem(
                  child: Text('Done', style: TextStyle(color: Colors.white)),
                  value: 'Done',
                ),
                DropdownMenuItem(
                  child: Text('Bug', style: TextStyle(color: Colors.white)),
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
      body: Consumer<TaskProvider>(  // Widget Consumer pour écouter les changements dans TaskProvider
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
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: Color(int.parse('0xFF333333')),
      ),
    );
  }
}

class TaskList extends StatelessWidget { // Fournisseur de tâches
  final TaskProvider taskProvider;

  TaskList({required this.taskProvider}); // Constructeur de TaskList


  @override
  Widget build(BuildContext context) {
    return ListView.builder( // Construit une liste dynamique de tâches
      itemCount: taskProvider.filteredTasks.length, // Nombre d'éléments dans la liste filtrée
      itemBuilder: (context, index) {
        final task = taskProvider.filteredTasks[index];  // Récupère la tâche à l'index spécifié
        return TaskTile( // Retourne un widget TaskTile pour afficher une tâche
          task: task,
          index: index,
        );
      },
    );
  }
}

class TaskTile extends StatelessWidget {
  final Task task;  // Tâche à afficher
  final int index; // Index de la tâche dans la liste

  TaskTile({required this.task, required this.index}); // Constructeur de TaskTile

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final color = taskProvider.getStatusColor(task.status); // Couleur associée au statut de la tâche

    return Container(
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        border: Border.all(color: color, width: 2.0),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: ListTile(
        leading: Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
        title: Text(
          task.name,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        onTap: () {
          Navigator.pushNamed(
            context,
            EditTaskScreen.routeName,
            arguments: {'task': task, 'index': index},
          ).then((value) {
            Provider.of<TaskProvider>(context, listen: false).notifyListeners();
          });
        },
      ),
    );
  }
}

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
      contentPadding: EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 0),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              initialValue: _name,
              decoration: InputDecoration(labelText: 'Name'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Enter task name';
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
              decoration: InputDecoration(labelText: 'Description'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Enter task description';
                }
                return null;
              },
              onSaved: (value) {
                _description = value!;
              },
              maxLines: 3, // Increase the number of lines
            ),
            SizedBox(height: 20),
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
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              final taskProvider = Provider.of<TaskProvider>(context, listen: false);
              final task = Task(name: _name, description: _description, status: _status);
              if (widget.index == null) {
                taskProvider.addTask(task);
              } else {
                taskProvider.updateTask(widget.index!, task);
              }
              Navigator.pop(context);
            }
          },
          child: Text(widget.task == null ? 'Add' : 'Save'),
        ),
      ],
    );
  }
}

class AddTaskScreen extends StatelessWidget {
  static const routeName = '/addTask';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajouter une Tâche', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(int.parse('0xFF333333')),
        automaticallyImplyLeading: false, 
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: AddTaskForm(),
      ),
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
  String _status = 'Todo';

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
              labelText: 'Nom Tache',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Entre le nom de la tache'; // Contrôleur pour le nom de la tâche
              }
              return null;
            },
            onSaved: (value) {
              _name = value!;
            },
          ),
          SizedBox(height: 20),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Description', // Champ de texte pour la description de la tâche
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            maxLines: 5, // Increase the number of lines to make the field larger
            validator: (value) {
              if (value!.isEmpty) {
                return 'Entrer la description';
              }
              return null;
            },
            onSaved: (value) {
              _description = value!;
            },
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: DropdownButtonFormField<String>(
                  value: _status,
                  items: [
                    DropdownMenuItem(
                      child: Row(
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(width: 8),
                          Text('Todo',style:TextStyle(color:Colors.grey)),
                        ],
                      ),
                      value: 'Todo',
                    ),
                    DropdownMenuItem(
                      child: Row(
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(int.parse('0xFF56CCF2')),
                            ),
                          ),
                          SizedBox(width: 8),
                          Text('In progress',style:TextStyle(color:Colors.blue)),
                        ],
                      ),
                      value: 'In progress',
                    ),
                    DropdownMenuItem(
                      child: Row(
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(int.parse('0xFF27AE60')),
                            ),
                          ),
                          SizedBox(width: 8),
                          Text('Done',style:TextStyle(color:Colors.green)),
                        ],
                      ),
                      value: 'Done',
                    ),
                    DropdownMenuItem(
                      child: Row(
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(int.parse('0xFFEB5757')),
                            ),
                          ),
                          SizedBox(width: 8),
                          Text('Bug',style:TextStyle(color:Colors.red)),
                        ],
                      ),
                      value: 'Bug',
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _status = value!;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Status',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Center(
            child: Container(
              width: 200.0,
              height: 50.0,
              decoration: BoxDecoration(
                color: Color(int.parse('0xFF333333')), // Couleur de l'arrière-plan de la barre d'applications
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
                    taskProvider.addTask(Task(
                      name: _name,
                      description: _description,
                      status: _status,
                    ));
                    Navigator.of(context).pop();
                  }
                },
                child: Text('Ajouter', style: TextStyle(fontSize: 18.0)),
                style: ElevatedButton.styleFrom(
                  primary: Color(int.parse('0xFF333333')),
                  onPrimary: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              width: 50.0,
              height: 50.0,
              decoration: BoxDecoration(
                color: Colors.grey,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(Icons.close, color: Colors.white),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class EditTaskScreen extends StatelessWidget {
  static const routeName = '/editTask';

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final Task task = args['task'];
    final int index = args['index'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Todo App', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(int.parse('0xFF333333')),
        automaticallyImplyLeading: false, 
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: EditTaskForm(task: task, index: index),
      ),
    );
  }
}

class EditTaskForm extends StatefulWidget {
  final Task task;
  final int index;

  EditTaskForm({required this.task, required this.index});

  @override
  _EditTaskFormState createState() => _EditTaskFormState();
}

class _EditTaskFormState extends State<EditTaskForm> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late String _description;
  late String _status;

  @override
  void initState() {
    super.initState();
    _name = widget.task.name;
    _description = widget.task.description;
    _status = widget.task.status;
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
            initialValue: _name,
            decoration: InputDecoration(
              labelText: 'Nom Tache',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Entre le nom de la tache';
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
            decoration: InputDecoration(
              labelText: 'Description',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            maxLines: 5, // Veut dire quon aura 5 lignes 
            validator: (value) {
              if (value!.isEmpty) {
                return 'Entrer la description';
              }
              return null;
            },
            onSaved: (value) {
              _description = value!;
            },
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                flex: 2, // reduis lespace
                child: DropdownButtonFormField<String>(
                  value: _status,
                  items: [
                    DropdownMenuItem(
                      child: Row(
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(width: 8),
                          Text('Todo',style:TextStyle(color:Colors.grey)),
                        ],
                      ),
                      value: 'Todo',
                    ),
                    DropdownMenuItem(
                      child: Row(
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(int.parse('0xFF56CCF2')),
                            ),
                          ),
                          SizedBox(width: 8),
                          Text('In progress',style:TextStyle(color:Colors.blue)),
                        ],
                      ),
                      value: 'In progress',
                    ),
                    DropdownMenuItem(
                      child: Row(
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(int.parse('0xFF27AE60')),
                            ),
                          ),
                          SizedBox(width: 8),
                          Text('Done',style:TextStyle(color:Colors.green)),
                        ],
                      ),
                      value: 'Done',
                    ),
                    DropdownMenuItem(
                      child: Row(
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(int.parse('0xFFEB5757')),
                            ),
                          ),
                          SizedBox(width: 8),
                          Text('Bug',style:TextStyle(color:Colors.red)),
                        ],
                      ),
                      value: 'Bug',
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _status = value!;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Status',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Center(
            child: Container(
              width: 200.0,
              height: 50.0,
              decoration: BoxDecoration(
                color: Color(int.parse('0xFF333333')),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
                    taskProvider.updateTask(widget.index, Task(
                      name: _name,
                      description: _description,
                      status: _status,
                    ));
                    Navigator.of(context).pop();
                  }
                },
                child: Text('Enregistrer', style: TextStyle(fontSize: 18.0)),
                style: ElevatedButton.styleFrom(
                  primary: Color(int.parse('0xFF333333')),
                  onPrimary: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              width: 50.0,
              height: 50.0,
              decoration: BoxDecoration(
                color: Colors.grey,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(Icons.close, color: Colors.white),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
