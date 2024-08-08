import 'dart:async';
import 'package:first_app/Controller/database_helper.dart';
import 'package:first_app/Model/todo_model.dart';
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

  @override
  void initState() {
    super.initState();
    _controller = ViewController(
      onTodosLoaded: (todos) {
        if (mounted) {
          setState(() {
            _controller.todoItems = todos;
          });
        }
      },
    );

    // _controller.loadTodos();

    Timer.periodic(const Duration(minutes: 5), (timer) {
      _databaseHelper.deleteTodo();

      if (_controller.todoItems.isEmpty) {
        timer.cancel();
      }
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
      body: FutureBuilder<List<TodoModel>>(
        future: _databaseHelper.getTodos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No todos found.'));
          } else {
            _controller.todoItems = snapshot.data!;
            return ListView.builder(
              itemCount: _controller.todoItems.length,
              itemBuilder: (BuildContext context, index) {
                return Visibility(
                  visible: _controller.todoItems[index].isVisible,
                  child: ToDoItem(
                    todoModel: _controller.todoItems[index],
                    onChanged: (value) {
                      _controller.checkBoxChanged(index);
                      if (mounted) {
                        setState(() {});
                      }
                    },
                    deleteTask: (context) async {
                      await _controller
                          .deleteTask(_controller.todoItems[index]);
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
