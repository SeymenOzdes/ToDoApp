import 'dart:async';
import 'package:first_app/todo_model.dart';
import 'package:first_app/database_helper.dart';
import 'package:first_app/todo_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  final _textController = TextEditingController();
  final descriptionTextController = TextEditingController();
  DateTime dateTime = DateTime.now();
  List<TodoModel> todoItems = [];
  var log = Logger();

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(minutes: 5), (timer) {
      _databaseHelper.deleteTodo();

      if (todoItems.isEmpty) {
        timer.cancel();
      }
    });
    _loadTodos();
  }

  Future<void> _loadTodos() async {
    final todos = await _databaseHelper.getTodos();

    setState(() {
      todoItems = todos;
    });
  }

  Future<void> saveTask() async {
    if (_textController.text.isNotEmpty &&
        descriptionTextController.text.isNotEmpty) {
      final todo = TodoModel(
        id: null,
        taskName: _textController.text,
        taskCompleted: false,
        isVisible: true, // ekledim 
        taskDescription: descriptionTextController.text,
        taskDate: dateTime,
      );
      try {
        log.i(todoItems.indexed);

        await _databaseHelper.insertTodo(todo);
        _textController.clear();
        descriptionTextController.clear();
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
      taskDescription: todo.taskDescription,
      taskDate: dateTime,
    );
    await _databaseHelper.updateTodo(updatedTodo);
    await _loadTodos();

    await Future.delayed(const Duration(seconds: 1));
    await deleteTask(todo);
    await _loadTodos();
    setState(() {});
  }

  Future<void> deleteTask(TodoModel todo) async {
    final updatedTodo = TodoModel(
      id: todo.id,
      taskName: todo.taskName,
      taskCompleted: todo.taskCompleted,
      isVisible: false,
      taskDescription: todo.taskDescription,
      taskDate: dateTime,
    );

    await _databaseHelper.updateTodo(updatedTodo);

    final index = todoItems.indexWhere((item) => item.id == todo.id);
    if (index != -1) {
      todoItems[index] = updatedTodo;
    }
  }

  void showDatePickerSheet() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return SizedBox(
            height: 300,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: CupertinoDatePicker(
                      initialDateTime: dateTime,
                      onDateTimeChanged: (DateTime newTime) {
                        setState(() {
                          dateTime = newTime;
                        });
                      },
                      mode: CupertinoDatePickerMode.date,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // handle save process
                      Navigator.pop(context);
                      showCustomBottomSheet();
                    },
                    child: const Text("save"),
                  )
                ],
              ),
            ),
          );
        });
  }

  void showCustomBottomSheet() {
    showModalBottomSheet(
        context: context,
        showDragHandle: true,
        elevation: 0,
        builder: (context) {
          return SizedBox(
              height: 300,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Column(
                  children: [
                    TextField(
                      style: const TextStyle(fontSize: 22),
                      controller: _textController,
                      decoration: const InputDecoration(
                          hintText: "Add a new ToDo",
                          hintStyle:
                              TextStyle(fontSize: 22, color: Colors.grey),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none),
                      keyboardType: TextInputType.name,
                    ),
                    TextField(
                      style: const TextStyle(fontSize: 18),
                      controller: descriptionTextController,
                      decoration: const InputDecoration(
                        hintText: "Description",
                        hintStyle: TextStyle(fontSize: 18, color: Colors.grey),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                      ),
                    ),
                    // buraya
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: ElevatedButton.icon(
                            onPressed: () {
                              // bıraya gelicek
                              Navigator.pop(context);
                              showDatePickerSheet();
                            },
                            label: const Text("Bitiş Tarihi seç"),
                            icon: const Icon(Icons.flag),
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                        onPressed: () {
                          saveTask();
                          Navigator.pop(context);
                        },
                        child: const Text("Save"))
                  ],
                ),
              ));
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
              deleteTask: (context) => deleteTask(todoItems[index]),
            ),
          );
        },
      ),
      floatingActionButton: Row(
        children: [
          const Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
            ),
          ),
          FloatingActionButton(
            onPressed: () {
              showCustomBottomSheet();
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
    descriptionTextController.dispose();
    super.dispose();
  }
}
