import 'package:first_app/Model/todo_model.dart';
import 'package:first_app/Repository/todos_repo.dart';
import 'cubit_todos_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TodosCubit extends Cubit<CubitTodosStates> {
  final TodosRepo todosRepo = TodosRepo();

  TodosCubit() : super(CubitTodosLoading());

  Future<void> saveTask(String taskName, String taskDescription,
      String selectedCategoryValue, DateTime dateTime) async {
    try {
      emit(CubitTodosLoading());

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
        await todosRepo.saveTask(todo);
      }

      emit(CubitTodosLoaded());
      print("emitted savetodo");
    } catch (e) {
      emit(CubitTodosError(errorMessage: 'Görev kaydedilemedi: $e'));
    }
  }

  Future<void> deleteTask(TodoModel todo) async {
    try {
      emit(CubitTodosLoading());

      await todosRepo.deleteTask(todo);
      await todosRepo.loadTodos();

      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text('Görev başarıyla silindi!')),
      // );

      emit(CubitTodosLoaded());
    } catch (e) {
      emit(CubitTodosError(errorMessage: 'Görev silinemedi: $e'));
    }
  }

  Future<void> checkBoxChanged(int index) async {
    await todosRepo.checkBoxChanged(index);
  }

  void updateDropdownValue(String? value, String selectedCategoryValue) {
    todosRepo.updateDropdownValue(value, selectedCategoryValue);
  }
}
