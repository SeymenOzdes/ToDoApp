import 'dart:async';
import 'package:first_app/Controller/database_helper.dart';
import 'package:first_app/Cubits/cubit_todos_states.dart';
import 'package:first_app/Cubits/todos_cubit.dart';
import 'package:first_app/Model/todo_model.dart';
import 'package:first_app/Repository/todos_repo.dart';
import 'package:first_app/View/loading_indicator.dart';
import 'package:first_app/View/todo_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'add_todo_sheet.dart';
import 'package:first_app/Controller/view_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final TodosRepo _todosRepo;
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  late final Future<void> _initHomePage;

  @override
  void initState() {
    super.initState();
    _initHomePage = initHomePage();
    _todosRepo = TodosRepo(onTodosLoaded: () => {});

    // _controller = ViewController(onTodosLoaded: refresh);

    Timer.periodic(const Duration(minutes: 5), (timer) {
      _databaseHelper.deleteTodo();

      if (_todosRepo.todoItems.isEmpty) {
        timer.cancel();
      }
    });
  }

  void refresh() {
    setState(() {
      print("refrehlendi");
    });
  }

//burası
  void showCustomBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      elevation: 0,
      builder: (context) {
        return CustomBottomSheet(
          textController: _todosRepo.textController,
          descriptionTextController: _todosRepo.descriptionTextController,
          selectedCategoryValue: _todosRepo.selectedCategoryValue,
          categories: _todosRepo.categories,
          onSaveTask: _todosRepo.saveTask,
          onValueChanged: (value) {
            _todosRepo.updateDropdownValue(value);
            setState(() {});
          },
          onDateSelected: (DateTime newDate) {
            if (mounted) {
              setState(() {
                _todosRepo.dateTime = newDate;
              });
            }
          },
          initialDateTime: _todosRepo.dateTime,
        );
      },
    );
  }

  Future<void> initHomePage() async {
    final tempList = await _databaseHelper.getTodos();
    setState(() {
      _todosRepo.todoItems = tempList;
    });
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
      body: FutureBuilder<void>(
        future: _initHomePage,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: LoadingIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return BlocBuilder<TodosCubit, CubitTodosStates>(
                builder: (context, state) {
              if (state is CubitTodosLoading) {
                return const Center(child: LoadingIndicator());
              } else if (state is CubitTodosLoaded) {
                return ListView.builder(
                  itemCount: state.todoItems.length,
                  itemBuilder: (BuildContext context, index) {
                    final todo = state.todoItems[index];
                    return Visibility(
                      visible: todo.isVisible,
                      child: ToDoItem(
                        todoModel: todo,
                        onChanged: (value) {
                          context.read<TodosCubit>().checkBoxChanged(index);
                          if (mounted) {
                            setState(() {});
                          }
                        },
                        deleteTask: (context) async {
                          await context.read<TodosCubit>().deleteTask(todo);
                          if (mounted) {
                            setState(() {});
                          }
                        },
                      ),
                    );
                  },
                );
              } else if (state is CubitTodosError) {
                return Center(child: Text(state.errorMessage));
              } else {
                return const Center(child: Text("No Data"));
              }
            });
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
    _todosRepo.textController.dispose();
    // _controller.descriptionTextController.dispose();
    super.dispose();
  }
}
