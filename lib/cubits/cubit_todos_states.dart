import 'package:first_app/Model/todo_model.dart';

abstract class CubitTodosStates {}

class CubitTodosLoading extends CubitTodosStates {}

class CubitTodosLoaded extends CubitTodosStates {
  final List<TodoModel> todoItems;

  CubitTodosLoaded({
    required this.todoItems,
  });
}

class CubitTodosError extends CubitTodosStates {
  final String errorMessage;

  CubitTodosError({required this.errorMessage});
}

// Görev silindiğinde kullanılacak state
class CubitTodosDeleted extends CubitTodosStates {
  final TodoModel deletedTodo;

  CubitTodosDeleted({
    required this.deletedTodo,
  });
}

class CubitTodosSaving extends CubitTodosStates {}

// Görev kaydedildiğinde kullanılacak state
class CubitTodosSaved extends CubitTodosStates {
  final TodoModel savedTodo;

  CubitTodosSaved({
    required this.savedTodo,
  });
}
