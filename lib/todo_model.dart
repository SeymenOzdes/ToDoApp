import 'package:flutter/foundation.dart';

class TodoModel {
  final int? id;
  final String taskName;
  final bool taskCompleted;
  bool isVisible; // Yeni özellik

  TodoModel({
    this.id,
    required this.taskName,
    required this.taskCompleted,
    this.isVisible = true, // Varsayılan değeri true olarak ayarla
  });

  // Map'ten bir TodoModel oluştur
  factory TodoModel.fromMap(Map<String, dynamic> map) {
    return TodoModel(
      id: map['id'] as int?,
      taskName: map['taskName'] as String,
      taskCompleted: map['taskCompleted'] == 1,
      isVisible: map['isVisible'] == 1, // Map'ten isVisible'ı oku
    );
  }

  // TodoModel'i bir Map'e dönüştür
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'taskName': taskName,
      'taskCompleted': taskCompleted ? 1 : 0,
      'isVisible': isVisible ? 1 : 0, // Map'e isVisible'ı ekle
    };
  }
}
