import 'package:first_app/Model/todo_model.dart';
import 'package:first_app/Repository/todos_repo.dart';

import 'cubit_todos_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TodosCubit extends Cubit<CubitTodosStates> {
  final TodosRepo _todosRepo = TodosRepo(onTodosLoaded: () {});

  TodosCubit() : super(CubitTodosLoading()) {
    getData();
  }

  Future<void> getData() async {
    emit(CubitTodosLoading());
    List<TodoModel> todoss = await _todosRepo.loadTodos();
    emit(CubitTodosLoaded(todoItems: todoss));
  }

  Future<void> saveTask() async {
    await _todosRepo.saveTask();
    // await getData(); // gerekli mi bilmiyorum.
  }

  Future<void> deleteTask(TodoModel todo) async {
    await _todosRepo.deleteTask(todo);
    await getData();
  }

  void checkBoxChanged(int index) {
    _todosRepo.checkBoxChanged(index);
  }

  void updateDropdownValue(String? value) {
    _todosRepo.updateDropdownValue(value);
  }
}
