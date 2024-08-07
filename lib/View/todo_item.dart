import 'package:first_app/Model/todo_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

class ToDoItem extends StatelessWidget {
  // final String taskName;
  // final bool taskCompleted;
  final Function(bool?)? onChanged;
  final Function(BuildContext)? deleteTask;
  final TodoModel todoModel;
  // final DateTime taskDate;
  // final String taskCategory;

  const ToDoItem({
    super.key,
    // required this.taskName,
    // required this.taskCompleted,
    required this.todoModel,
    required this.onChanged,
    required this.deleteTask,
    // required this.taskDate,
    // required this.taskCategory,
  });

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat('d MMMM, HH:mm');

    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 0),
      child: Slidable(
        startActionPane: ActionPane(motion: const StretchMotion(), children: [
          SlidableAction(
            onPressed: deleteTask,
            icon: Icons.delete,
            backgroundColor: Colors.red,
          )
        ]),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(20),
            color: Colors.deepPurple,
            child: Row(
              children: [
                Checkbox(
                  value: todoModel.taskCompleted,
                  onChanged: onChanged,
                  side: const BorderSide(color: Colors.white),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      todoModel.taskName,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        decoration: todoModel.taskCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        decorationColor: Colors.white,
                        decorationThickness: 3,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          formatter.format(todoModel.taskDate),
                          style: const TextStyle(
                              color: Colors.white, fontSize: 18),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Text(
                          todoModel.taskCategory,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 18),
                        )
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
