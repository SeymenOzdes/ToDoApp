class TodoModel {
  final int? id;
  final String taskName;
  final bool taskCompleted;
  bool isVisible;
  final String taskDescription;
  final DateTime taskDate;
  final String taskCategory;

  TodoModel({
    this.id,
    required this.taskName,
    required this.taskCompleted,
    this.isVisible = true,
    required this.taskDescription,
    required this.taskDate,
    required this.taskCategory,
  });

  factory TodoModel.fromMap(Map<String, dynamic> map) {
    return TodoModel(
      id: map['id'] as int?,
      taskName: map['taskName'] as String,
      taskCompleted: map['taskCompleted'] == 1,
      isVisible: map['isVisible'] == 1,
      taskDescription: map['taskDescription'] as String? ?? '',
      taskDate:
          DateTime.tryParse(map['taskDate'] as String? ?? '') ?? DateTime.now(),
      taskCategory: map['taskCategory'] as String? ?? '',
    );
  }

  // TodoModel'i bir Map'e dönüştür
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'taskName': taskName,
      'taskCompleted': taskCompleted ? 1 : 0,
      'isVisible': isVisible ? 1 : 0,
      'taskDescription': taskDescription,
      'taskDate': taskDate.toIso8601String(),
      'taskCategory': taskCategory,
    };
  }
}
