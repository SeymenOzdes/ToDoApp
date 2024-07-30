import "package:first_app/todo_item.dart";
import "package:first_app/todo_list_data.dart";
import "package:flutter/material.dart";

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<TodoListData> todoItems = [
    TodoListData(
        taskName: "Drink water", taskCompleted: false, isVisible: true),
    TodoListData(
        taskName: "Take out the trash", taskCompleted: false, isVisible: true),
  ];
  final _textController = TextEditingController();

  void saveTask() {
    todoItems.add(TodoListData(
        taskName: _textController.text, taskCompleted: false, isVisible: true));
    _textController.clear();
  }

  void checkBoxChanged(int index) {
    setState(() {
      if (!todoItems[index].taskCompleted) {
        // check user click just one time.
        todoItems[index].taskCompleted = !todoItems[index].taskCompleted;

        Future.delayed(const Duration(seconds: 1), () {
          deleteTask(index);
        });
      }
    });
  }

  void deleteTask(int index) {
    setState(() {
      todoItems[index].isVisible = false;
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
      body: ListView.builder(
        itemCount: todoItems.length,
        itemBuilder: (BuildContext context, index) {
          return Visibility(
            visible: todoItems[index].isVisible,
            child: ToDoItem(
              taskName: todoItems[index].taskName,
              taskCompleted: todoItems[index].taskCompleted,
              onChanged: (value) => checkBoxChanged(index),
              deleteTask: (contex) => deleteTask(index),
            ),
          );
        },
      ),
      floatingActionButton: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: TextField(
                controller: _textController,
                decoration: InputDecoration(
                  hintText: "Add a new ToDo",
                  filled: true,
                  fillColor: const Color.fromARGB(255, 200, 146, 223),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: const BorderSide(
                      color: Colors.white,
                      width: 2.2,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: const BorderSide(
                      color: Colors.white,
                      width: 2.2,
                    ),
                  ),
                ),
                keyboardType: TextInputType.name,
              ),
            ),
          ),
          FloatingActionButton(
            onPressed: () {
              setState(() {
                if (_textController.text.isNotEmpty) {
                  saveTask();
                }
              });
            },
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}
