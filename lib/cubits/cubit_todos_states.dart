abstract class CubitTodosStates {}

class CubitTodosLoading extends CubitTodosStates {}

class CubitTodosLoaded extends CubitTodosStates {
  CubitTodosLoaded();
}

class CubitTodosError extends CubitTodosStates {
  final String errorMessage;

  CubitTodosError({required this.errorMessage});
}
