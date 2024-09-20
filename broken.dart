import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weekly TODO List',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const TodoListPage(title: 'Weekly TODO List'),
    );
  }
}

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key, required this.title});

  final String title;

  @override
  State createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final List<TodoItem> _todos = [];
  final TextEditingController _textController = TextEditingController();

  void _addTodoItem(String title) {
    if (title.trim().isEmpty) return;
    setState(() {
      _todos.add(TodoItem(title: title.trim()));
    });
    _textController.clear();
  }

  void _toggleTodoItem(int index) {
    setState(() {
      _todos[index].isDone = !_todos[index].isDone;
    });
  }

  void _removeTodoItem(int index) {
    setState(() {
      _todos.removeAt(index);
    });
  // }

  Future<void> _showAddTodoDialog() async {
    String newTodo = '';
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Task'),
          content: TextField(
            controller: _textController,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'Enter task title',
            ),
            onChanged: (value) {
              newTodo = value;
            },
            onSubmitted: (value) {
              Navigator.of(context).pop();
              _addTodoItem(value);
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _addTodoItem(newTodo);
              },
              child: const Text('Add'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _textController.clear();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTodoItem(BuildContext context, int index) {
    final todo = _todos[index];
    return Dismissible(
      key: Key(todo.title + index.toString()),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
        _removeTodoItem(index);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Deleted "${todo.title}"')),
        );
      },
      child: ListTile(
        leading: Checkbox(
          value: todo.isDone,
          onChanged: (bool? value) {
            _toggleTodoItem(index);
          },
        ),
        title: Text(
          todo.title,
          style: TextStyle(
            decoration: todo.isDone ? TextDecoration.lineThrough : null,
            color: todo.isDone ? Colors.grey : null,
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () => _removeTodoItem(index),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _todos.isEmpty
          ? const Center(
              child: Text(
                'No tasks added yet.\nTap the "+" button to add a new task.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18.0),
              ),
            )
          : ListView.builder(
              itemCount: _todos.length,
              itemBuilder: _buildTodoItem,
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTodoDialog,
        tooltip: 'Add Task',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class TodoItem {
  String title;
  bool isDone;

  TodoItem({required this.title, this.isDone = false});
}
