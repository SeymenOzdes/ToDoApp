import 'package:first_app/Model/todo_model.dart';
import 'package:first_app/cubits/todos_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

class ToDoItem extends StatefulWidget {
  @override
  _ToDoItemState createState() => _ToDoItemState();

  final TodoModel todoModel;
  final TodosCubit todoCubit;
  const ToDoItem({
    super.key,
    required this.todoModel,
    required this.todoCubit,
  });
}

class _ToDoItemState extends State<ToDoItem> {
  late final TodoModel _todoModel;
  late final TodosCubit _todoCubit;
  bool _isChecked = false;

  @override
  void initState() {
    super.initState();
    _todoModel = widget.todoModel;
    _todoCubit = widget.todoCubit;
    _isChecked = _todoModel.taskCompleted;
  }

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat('d MMMM, HH:mm');

    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 0),
      child: Slidable(
        startActionPane: ActionPane(motion: const StretchMotion(), children: [
          SlidableAction(
            onPressed: (value) async {
              await _todoCubit.deleteTask(_todoModel);
            },
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
                  value: _isChecked,
                  onChanged: (value) async {
                    setState(() {
                      _isChecked = value!;
                      _todoModel.taskCompleted = _isChecked;
                    });
                    await _todoCubit.deleteTask(_todoModel);
                  },
                  side: const BorderSide(color: Colors.white),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _todoModel.taskName,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontSize: 20,
                        decoration: _todoModel.taskCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        decorationColor: Colors.white,
                        decorationThickness: 3,
                      ),
                    ),
                    Text(
                      _todoModel.taskDescription,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        decorationColor: Colors.white,
                        decorationThickness: 3,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          formatter.format(_todoModel.taskDate),
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Text(
                          _todoModel.taskCategory,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16),
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
