import "package:first_app/todoitem.dart";
import "package:flutter/material.dart";

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List dummyData = [
    [
      "drink water",
      false
    ], // ikinci değer olarak chechked durumu almalı mı emin değilim?
    ["take out the trash", false],
  ];
  final _textController = TextEditingController();

  void saveTask() {
    dummyData.add([_textController.text, false]);
    _textController.clear();
  }

  void checkBoxChanged(int index) {
    setState(() {
      dummyData[index][1] = !dummyData[index][1];
    });
  }

  void deleteTask(int index) {
    setState(() {
      dummyData.removeAt(index);
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
        itemCount: dummyData.length,
        itemBuilder: (BuildContext context, index) {
          return ToDoItem(
            taskName: dummyData[index][0],
            taskCompleted: dummyData[index][1],
            onChanged: (value) => checkBoxChanged(index),
            deleteTask: (contex) => deleteTask(index),
          );
        },
      ),
      // floating action button
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
                saveTask();
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
