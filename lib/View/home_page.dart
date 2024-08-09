import 'dart:async';
import 'package:first_app/Controller/database_helper.dart';
import 'package:first_app/Model/todo_model.dart';
import 'package:first_app/View/loading_indicator.dart';
import 'package:first_app/View/todo_item.dart';
import 'package:flutter/material.dart';
import 'add_todo_sheet.dart';
import 'package:first_app/Controller/view_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final ViewController _controller;
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  late final Future<void> _initHomePage;

  @override
  void initState() {
    super.initState();
    _initHomePage = initHomePage();

    _controller = ViewController(onTodosLoaded: refresh);

    // _controller.loadTodos();

    Timer.periodic(const Duration(minutes: 5), (timer) {
      _databaseHelper.deleteTodo();

      if (_controller.todoItems.isEmpty) {
        timer.cancel();
      }
    });
  }

  void refresh() {
    setState(() {
      print("refrehlendi");
    });
  }

  void showCustomBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      elevation: 0,
      builder: (context) {
        return CustomBottomSheet(
          controller: _controller,
          textController: _controller.textController,
          descriptionTextController: _controller.descriptionTextController,
          selectedCategoryValue: _controller.selectedCategoryValue,
          categories: _controller.categories,
          onSaveTask: _controller.saveTask,
          onValueChanged: (value) {
            _controller.updateDropdownValue(value);
            setState(() {});
          },
          onDateSelected: (DateTime newDate) {
            if (mounted) {
              setState(() {
                _controller.dateTime = newDate;
              });
            }
          },
          initialDateTime: _controller.dateTime,
        );
      },
    );
  }

  Future<void> initHomePage() async {
    final tempList = await _databaseHelper.getTodos();
    setState(() {
      _controller.todoItems = tempList;
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
            return ListView.builder(
              itemCount: _controller.todoItems.length,
              itemBuilder: (BuildContext context, index) {
                final todo = _controller.todoItems[index];
                return Visibility(
                  visible: todo.isVisible,
                  child: ToDoItem(
                    todoModel: todo,
                    onChanged: (value) {
                      _controller.checkBoxChanged(index);
                      if (mounted) {
                        setState(() {});
                      }
                    },
                    deleteTask: (context) async {
                      await _controller.deleteTask(todo);
                      if (mounted) {
                        setState(() {});
                      }
                    },
                  ),
                );
              },
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
    _controller.textController.dispose();
    _controller.descriptionTextController.dispose();
    super.dispose();
  }
}
