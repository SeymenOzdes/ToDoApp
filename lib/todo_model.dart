class TodoModel {
  final int? id;
  final String taskName;
  final bool taskCompleted;

  const TodoModel(
      {required this.id,
       required this.taskName,
       required this.taskCompleted
       });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'taskName': taskName,
      'taskCompleted': taskCompleted ? 1 : 0,
    };
  }

  factory TodoModel.fromMap(Map<String, dynamic> map) {
    return TodoModel(
      id: map['id'] as int?,
      taskName: map['taskName'] as String,
      taskCompleted: map['taskCompleted'] == 1,
    );
  }
}
