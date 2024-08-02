import 'package:flutter/material.dart';

class AddingTodoSheet extends StatefulWidget {
  const AddingTodoSheet({super.key});

  @override
  _AddingTodoSheetState createState() => _AddingTodoSheetState();
}

class _AddingTodoSheetState extends State<AddingTodoSheet> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          showBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return Container(
                color: Colors.white,
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Add a new ToDo',
                      style: TextStyle(fontSize: 24),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Add Task'),
                    ),
                  ],
                ),
              );
            },
          );
        },
        child: const Text('Show Add Todo Sheet'),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
