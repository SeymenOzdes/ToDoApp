import 'package:first_app/Controller/database_helper.dart';
import 'package:first_app/Model/todo_model.dart';
import 'package:flutter/material.dart';
import 'package:logger/web.dart';

class TodosRepo {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  final List<String> _categories = ["Gündelik", "İş", "Okul"];
  List<TodoModel> todoItems = [];
  var log = Logger();

  List<String> get categories => _categories;

  Future<List<TodoModel>> loadTodos() async {
    final todos = await _databaseHelper.getTodos();
    todoItems = List.from(todos);
    return todoItems;
  }

  Future<void> saveTask(TodoModel todo) async {
    try {
      log.i(todoItems.indexed);
      await _databaseHelper.insertTodo(todo);
      await loadTodos();
    } catch (e) {
      log.e('Error inserting todo: $e');
    }
  }

  Future<void> checkBoxChanged(int index) async {
    final todo = todoItems[index];
    final updatedTodo = TodoModel(
      id: todo.id,
      taskName: todo.taskName,
      taskCompleted: !todo.taskCompleted,
      isVisible: !todo.isVisible,
      taskDescription: todo.taskDescription,
      taskDate: todo.taskDate,
      taskCategory: todo.taskCategory,
    );
    await _databaseHelper.updateTodo(updatedTodo);
    await loadTodos();

    // await Future.delayed(const Duration(seconds: 1));
    // await deleteTask(todo);
    // await loadTodos();
  }

  Future<void> deleteTask(TodoModel todo) async {
    final updatedTodo = TodoModel(
        id: todo.id,
        taskName: todo.taskName,
        taskCompleted: true,
        isVisible: false,
        taskDescription: todo.taskDescription,
        taskDate: todo.taskDate,
        taskCategory: todo.taskCategory);

    await _databaseHelper.updateTodo(updatedTodo);
  }

  void updateDropdownValue(String? value, String selectedCategoryValue) {
    selectedCategoryValue = value ?? "";
  }

  void clearAddingTodoFields(
      TextEditingController textController,
      TextEditingController descriptionTextController,
      String selectedCategoryValue,
      DateTime dateTime) {
    textController.clear();
    descriptionTextController.clear();
    selectedCategoryValue = "";
    dateTime = DateTime.now();
  }
}
