import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../Model/todo_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();
  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'todo.db');

    return await openDatabase(
      path,
      version: 4,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE todos('
          'id INTEGER PRIMARY KEY AUTOINCREMENT, '
          'taskName TEXT, '
          'taskCompleted INTEGER, '
          'isVisible INTEGER, '
          'taskDescription TEXT, '
          'taskDate TEXT, '
          'taskCategory TEXT)',
        );
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 3) {
          await db.execute(
            'ALTER TABLE todos ADD COLUMN taskDescription TEXT',
          );
          await db.execute(
            'ALTER TABLE todos ADD COLUMN taskDate TEXT',
          );
          if (oldVersion < 4) {
            await db.execute(
              'ALTER TABLE todos ADD COLUMN taskCategory TEXT',
            );
          }
        }
      },
    );
  }

  Future<void> insertTodo(TodoModel todo) async {
    final db = await database;
    await db.insert(
      'todos',
      todo.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<TodoModel>> getTodos() async {
    await Future.delayed(const Duration(milliseconds: 750)); // delay

    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('todos');

    return List.generate(maps.length, (i) {
      return TodoModel.fromMap(maps[i]);
    });
  }

  Future<void> updateTodo(TodoModel todo) async {
    final db = await database;
    await db.update(
      'todos',
      todo.toMap(),
      where: 'id = ?',
      whereArgs: [todo.id],
    );
  }

  Future<void> deleteTodo() async {
    final db = await database;
    await db.execute(
      'DELETE FROM todos WHERE taskCompleted = ?',
      [1],
    );
  }

  Future<void> deleteDatabaseFile() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'todo.db');
    await deleteDatabase(path);
  }
}
