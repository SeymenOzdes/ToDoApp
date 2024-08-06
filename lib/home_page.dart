import 'dart:async';
import 'package:first_app/todo_model.dart';
import 'package:first_app/database_helper.dart';
import 'package:first_app/todo_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'adding_todo_sheet.dart';

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
  final List<String> _categories = ["Gündelik", "İş", "Okul"];
  DateTime dateTime = DateTime.now();
  List<TodoModel> todoItems = [];
  String _selectedValue = "";
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
        taskCategory: _selectedValue,
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

  void updateDropdownValue(String value) {
    setState(() {
      _selectedValue = value;
    });
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
      taskCategory: _selectedValue,
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
        taskDate: todo.taskDate,
        taskCategory: todo.taskCategory);

    await _databaseHelper.updateTodo(updatedTodo);

    final index = todoItems.indexWhere((item) => item.id == todo.id);
    if (index != -1) {
      todoItems[index] = updatedTodo;
    }
  }

  // void showDatePickerSheet() {
  //   showModalBottomSheet(
  //       context: context,
  //       builder: (context) {
  //         return SizedBox(
  //           height: 300,
  //           width: double.infinity,
  //           child: Padding(
  //             padding: const EdgeInsets.all(12),
  //             child: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 Expanded(
  //                   child: CupertinoDatePicker(
  //                     initialDateTime: dateTime,
  //                     minimumYear: 2024,
  //                     onDateTimeChanged: (DateTime newTime) {
  //                       setState(() {
  //                         dateTime = newTime;
  //                       });
  //                     },
  //                     mode: CupertinoDatePickerMode.dateAndTime,
  //                   ),
  //                 ),
  //                 ElevatedButton(
  //                   onPressed: () {
  //                     Navigator.pop(context);
  //                     showCustomBottomSheet(context);
  //                   },
  //                   child: const Text("save"),
  //                 )
  //               ],
  //             ),
  //           ),
  //         );
  //       });
  // }

  void showCustomBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      elevation: 0,
      builder: (context) {
        return CustomBottomSheet(
          textController: _textController,
          descriptionTextController: descriptionTextController,
          selectedValue: _selectedValue,
          categories: _categories,
          onSaveTask: saveTask,
          onValueChanged: (value) => updateDropdownValue(value ?? ""),
          onDateSelected: (DateTime newDate) {
            if (mounted) {
              setState(() {
                dateTime = newDate;
              });
            }
          },
          initialDateTime: dateTime,
        );
      },
    );
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
              taskDate: todoItems[index].taskDate,
              taskCategory: todoItems[index].taskCategory,
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
              showCustomBottomSheet(context);
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
