import 'package:flutter/material.dart';

void main() {
  runApp(ToDoApp());
}

class ToDoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista de Tareas',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ToDoList(),
    );
  }
}

class ToDoList extends StatefulWidget {
  @override
  _ToDoListState createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  List<String> tasks = [];
  List<String> filteredTasks = [];

  TextEditingController taskController = TextEditingController();
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredTasks = tasks;

    searchController.addListener(() {
      filterTasks();
    });
  }

  void filterTasks() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredTasks = tasks
          .where((task) => task.toLowerCase().contains(query))
          .toList();
    });
  }

  void addTask() {
    if (taskController.text.isNotEmpty) {
      setState(() {
        tasks.add(taskController.text);
        taskController.clear();
        filterTasks(); // importante para mantener sincronizado
      });
    }
  }

  void removeTask(int index) {
    String taskToRemove = filteredTasks[index];
    setState(() {
      tasks.remove(taskToRemove);
      filterTasks();
    });
  }

  void toggleTaskCompletion(int index) {
    String taskToUpdate = filteredTasks[index];
    int originalIndex = tasks.indexOf(taskToUpdate);
    setState(() {
      tasks[originalIndex] = taskToUpdate + " ✅";
      filterTasks();
    });
  }

  @override
  void dispose() {
    taskController.dispose();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de tareas'),
      ),
      body: Column(
        children: [
          // Campo para buscar tareas
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Buscar tarea...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          // Campo para agregar tareas
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: taskController,
                    decoration: InputDecoration(
                      hintText: 'Escribe una tarea...',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: addTask,
                ),
              ],
            ),
          ),
          // Lista de tareas filtradas
          Expanded(
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(tasks[index]),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.check),
                        onPressed: () => toggleTaskCompletion(index),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => removeTask(index),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
