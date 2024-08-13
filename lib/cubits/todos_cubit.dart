import 'package:first_app/Model/todo_model.dart';
import 'package:first_app/Repository/todos_repo.dart';
import 'package:flutter/material.dart';
import 'cubit_todos_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TodosCubit extends Cubit<CubitTodosStates> {
  final TodosRepo _todosRepo = TodosRepo(onTodosLoaded: () {});

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

  Future<void> saveTask(
      TextEditingController textController,
      TextEditingController descriptionTextController,
      String selectedCategoryValue,
      DateTime dateTime) async {
    try {
      await _todosRepo.saveTask(textController, descriptionTextController,
          selectedCategoryValue, dateTime);
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
      await Future.delayed(Duration(milliseconds: 500));
      await getData();
      emit(CubitTodosDeleted(deletedTodo: todo));
    } catch (e) {
      emit(CubitTodosError(errorMessage: 'Görev silinemedi: $e'));
    }
  }

  void checkBoxChanged(int index) {
    _todosRepo.checkBoxChanged(index);
  }

  void updateDropdownValue(String? value, String selectedCategoryValue) {
    _todosRepo.updateDropdownValue(value, selectedCategoryValue);
  }
}
