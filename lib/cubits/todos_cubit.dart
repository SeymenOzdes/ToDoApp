import 'package:first_app/Model/todo_model.dart';
import 'package:first_app/Repository/todos_repo.dart';
import 'package:flutter/material.dart';
import 'cubit_todos_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TodosCubit extends Cubit<CubitTodosStates> {
  final TodosRepo _todosRepo = TodosRepo();

  TodosCubit() : super(CubitTodosLoading()) {
    getData();
  }

  Future<void> getData() async {
    emit(CubitTodosLoading());
    print("emitted loading");

    try {
      List<TodoModel> todos = await _todosRepo.loadTodos();
      emit(CubitTodosLoaded(todoItems: todos));
      print("todoloeaded loading");
    } catch (e) {
      emit(CubitTodosError(
          errorMessage: 'Veriler yüklenirken bir hata oluştu: $e'));
    }
  }

  Future<void> saveTask(String taskName, String taskDescription,
      String selectedCategoryValue, DateTime dateTime) async {
    try {
      emit(CubitTodosSaving());

      final todo = TodoModel(
        id: null,
        taskName: taskName,
        taskCompleted: false,
        isVisible: true,
        taskDescription: taskDescription,
        taskDate: dateTime,
        taskCategory: selectedCategoryValue,
      );
      if (taskName.isNotEmpty && taskDescription.isNotEmpty) {
        await _todosRepo.saveTask(todo);
      }
      emit(CubitTodosSaved(savedTodo: _todosRepo.todoItems.last));
      print("emitted savetodo");
      await getData();
    } catch (e) {
      emit(CubitTodosError(errorMessage: 'Görev kaydedilemedi: $e'));
    }
  }

  Future<void> deleteTask(TodoModel todo) async {
    try {
      await _todosRepo.deleteTask(todo);
      await Future.delayed(const Duration(milliseconds: 500));
      await _todosRepo.loadTodos();

      emit(CubitTodosDeleted(deletedTodo: todo));
    } catch (e) {
      emit(CubitTodosError(errorMessage: 'Görev silinemedi: $e'));
    }
  }

  Future<void> checkBoxChanged(int index) async {
    await _todosRepo.checkBoxChanged(index);
  }

  void updateDropdownValue(String? value, String selectedCategoryValue) {
    _todosRepo.updateDropdownValue(value, selectedCategoryValue);
  }
}
