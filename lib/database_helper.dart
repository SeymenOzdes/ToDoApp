import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'todo_model.dart';

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

  Future<void> deleteDatabase() async {
    final db = await database;
    await db.execute('DROP TABLE IF EXISTS todos');
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'todo.db');

    return await openDatabase(
      path,
      version: 3,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE todos('
          'id INTEGER PRIMARY KEY AUTOINCREMENT, '
          'taskName TEXT, '
          'taskCompleted INTEGER, '
          'isVisible INTEGER)'
          'taskDescription TEXT, '
          'taskDate TEXT)',
        );
      },
      // onUpgrade: (db, oldVersion, newVersion) async {
      //   if (oldVersion < newVersion) {
      //     await db.execute('ALTER TABLE todos ADD COLUMN isVisible INTEGER DEFAULT 1');
      //   }
      // },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 3) {
          await db.execute(
            'ALTER TABLE todos ADD COLUMN taskDescription TEXT',
          );
          await db.execute(
            'ALTER TABLE todos ADD COLUMN taskDate TEXT',
          );
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
}
