import 'dart:async';
import 'package:first_app/Controller/database_helper.dart';
import 'package:first_app/View/loading_indicator.dart';
import 'package:first_app/View/todo_item.dart';
import 'package:first_app/cubits/cubit_todos_states.dart';
import 'package:first_app/cubits/todos_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'add_todo_sheet.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  late final Future<void> _initHomePage;
  late final TodosCubit todosCubit;
  late final LoadingIndicator _loadingIndicator;
  // bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _initHomePage = initHomePage();
    todosCubit = context.read<TodosCubit>();
    _loadingIndicator = LoadingIndicator(context);

    Timer.periodic(const Duration(minutes: 5), (timer) {
      _databaseHelper.deleteTodo();

      if (todosCubit.todosRepo.todoItems.isEmpty) {
        timer.cancel();
      }
    });
  }

  void showCustomBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      elevation: 0,
      builder: (contex) {
        return CustomBottomSheet(
          todosCubit: todosCubit,
        );
      },
    );
  }

  Future<void> initHomePage() async {
    final tempList = await _databaseHelper.getTodos();
    setState(() {
      todosCubit.todosRepo.todoItems = tempList;
    });
  }

  @override
  Widget build(BuildContext context) {
    // if (isLoading) {
    //   _loadingIndicator.show();
    // } else if (isLoading == false) {
    //   _loadingIndicator.hide();
    // }
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "ToDo App",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 138, 20, 189),
      ),
      body: FutureBuilder<void>(
        future: _initHomePage,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return BlocListener<TodosCubit, CubitTodosStates>(
              listener: (context, state) {
                if (state is CubitTodosError) {
                  _loadingIndicator.hide();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.errorMessage)),
                  );
                } else if (state is CubitTodosLoading) {
                  _loadingIndicator.show();
                } else if (state is CubitTodosLoaded) {
                  setState(() {
                    _loadingIndicator.hide();
                  });
                }
              },
              child: ListView.builder(
                itemCount: todosCubit.todosRepo.todoItems.length,
                itemBuilder: (BuildContext context, index) {
                  final todo = todosCubit.todosRepo.todoItems[index];
                  return Visibility(
                    visible: todo.isVisible,
                    child: BlocProvider.value(
                        value: context.read<TodosCubit>(),
                        child: ToDoItem(
                          todoModel: todo,
                          todoCubit: BlocProvider.of<TodosCubit>(context),
                        )),
                  );
                },
              ),
            );
          }
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
    super.dispose();
  }
}
