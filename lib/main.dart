import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Checkable TODO List',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const TodoListPage(),
    );
  }
}

class TodoItem {
  String task;
  bool isDone;

  TodoItem({required this.task, this.isDone = false});
}

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final List<TodoItem> _todoItems = [];
  final TextEditingController _controller = TextEditingController();

  void _addTodoItem() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        _todoItems.add(TodoItem(task: _controller.text));
      });
      _controller.clear();
    }
  }

  void _toggleTodoItem(int index) {
    setState(() {
      _todoItems[index].isDone = !_todoItems[index].isDone;
    });
  }

  void _removeTodoItem(int index) {
    setState(() {
      _todoItems.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Checkable TODO List'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Enter a task',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => _addTodoItem(),
            ),
          ),
          ElevatedButton(
            onPressed: _addTodoItem,
            child: const Text('Add Task'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _todoItems.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: Key(_todoItems[index].task),
                  onDismissed: (direction) {
                    _removeTodoItem(index);
                  },
                  background: Container(color: Colors.red),
                  child: ListTile(
                    leading: Checkbox(
                      value: _todoItems[index].isDone,
                      onChanged: (_) {
                        _toggleTodoItem(index);
                      },
                    ),
                    title: Text(
                      _todoItems[index].task,
                      style: TextStyle(
                        decoration: _todoItems[index].isDone
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        _removeTodoItem(index);
                      },
                    ),
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