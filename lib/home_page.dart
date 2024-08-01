import 'package:first_app/todo_model.dart';
import 'package:first_app/database_helper.dart';
import 'package:first_app/todo_item.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<TodoModel> todoItems = [];
  final _textController = TextEditingController();
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  var log = Logger();

  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  Future<void> _loadTodos() async {
    final todos = await _databaseHelper.getTodos();
    setState(() {
      todoItems = todos;
    });
  }

  Future<void> saveTask() async {
    if (_textController.text.isNotEmpty) {
      final todo = TodoModel(
        id: null,
        taskName: _textController.text,
        taskCompleted: false,
      );
      try {
        await _databaseHelper.insertTodo(todo);
        _textController.clear();
        await _loadTodos();
      } catch (e) {
        log.e('Error inserting todo: $e');
      }
    }
  }

  void checkBoxChanged(int index) async {
    final todo = todoItems[index];
    final updatedTodo = TodoModel(
      id: todo.id,
      taskName: todo.taskName,
      taskCompleted: !todo.taskCompleted,
      isVisible: true,
    );
    await _databaseHelper.updateTodo(updatedTodo);
    await _loadTodos();

    await Future.delayed(const Duration(seconds: 1));
    await deleteTask(index);
    await _loadTodos();
    setState(() {});
  }

  Future<void> deleteTask(int index) async {
    final todo = todoItems[index];
    final updatedTodo = TodoModel(
      id: todo.id,
      taskName: todo.taskName,
      taskCompleted: todo.taskCompleted,
      isVisible: false,
    );
    await _databaseHelper.updateTodo(updatedTodo);

    setState(() {
      todoItems[index] = updatedTodo;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "ToDo App",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 138, 20, 189),
      ),
      body: ListView.builder(
        itemCount: todoItems.length,
        itemBuilder: (BuildContext context, index) {
          return Visibility(
            visible: todoItems[index].isVisible,
            child: ToDoItem(
              taskName: todoItems[index].taskName,
              taskCompleted: todoItems[index].taskCompleted,
              onChanged: (value) => checkBoxChanged(index),
              deleteTask: (context) => deleteTask(index),
            ),
          );
        },
      ),
      floatingActionButton: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: TextField(
                controller: _textController,
                decoration: InputDecoration(
                  hintText: "Add a new ToDo",
                  filled: true,
                  fillColor: const Color.fromARGB(255, 200, 146, 223),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: const BorderSide(
                      color: Colors.white,
                      width: 2.2,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: const BorderSide(
                      color: Colors.white,
                      width: 2.2,
                    ),
                  ),
                ),
                keyboardType: TextInputType.name,
              ),
            ),
          ),
          FloatingActionButton(
            onPressed: () {
              saveTask();
            },
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}
