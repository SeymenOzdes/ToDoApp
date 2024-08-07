import 'package:first_app/Model/todo_model.dart';
import 'package:first_app/Controller/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class ViewController {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  final void Function(List<TodoModel>) onTodosLoaded;
  final _textController = TextEditingController();
  final _descriptionTextController = TextEditingController();
  String _selectedCategoryValue = "";
  DateTime dateTime = DateTime.now();
  final List<String> _categories = ["Gündelik", "İş", "Okul"];
  List<TodoModel> todoItems = [];

  var log = Logger();

  ViewController({
    required this.onTodosLoaded,
  });

  TextEditingController get textController => _textController;

  TextEditingController get descriptionTextController =>
      _descriptionTextController;

  String get selectedCategoryValue => _selectedCategoryValue;
  set selectedCategoryValue(String value) {
    _selectedCategoryValue = value;
  }

  List<String> get categories => _categories;

  Future<void> loadTodos() async {
    final todos = await _databaseHelper.getTodos();
    onTodosLoaded(todos);
  }

  Future<void> saveTask() async {
    if (_textController.text.isNotEmpty &&
        _descriptionTextController.text.isNotEmpty) {
      final todo = TodoModel(
        id: null,
        taskName: _textController.text,
        taskCompleted: false,
        isVisible: true, // ekledim
        taskDescription: _descriptionTextController.text,
        taskDate: dateTime,
        taskCategory: _selectedCategoryValue,
      );
      try {
        log.i(todoItems.indexed);

        await _databaseHelper.insertTodo(todo);
        clearAddingTodoFields();
        await loadTodos();
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
      taskDate: todo.taskDate,
      taskCategory: todo.taskCategory,
    );
    await _databaseHelper.updateTodo(updatedTodo);
    await loadTodos();

    await Future.delayed(const Duration(seconds: 1));
    await deleteTask(todo);
    await loadTodos();
    // setState(() {});
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

  void updateDropdownValue(String? value) {
    selectedCategoryValue = value ?? "";
  }

  void clearAddingTodoFields() {
    _textController.clear();
    _descriptionTextController.clear();
    _selectedCategoryValue = "";
    dateTime = DateTime.now();
  }
}
