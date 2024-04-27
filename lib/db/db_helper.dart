import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_crud/models/task.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._instance();

  static Database? _db = null;
  DatabaseHelper._instance();

  String tableTask = 'taskTable'; // Updated table name+
  String colId = 'id';
  String colName = 'name';
  String colDate = 'date';
  String colDescription = 'description';
  String colPriority = 'priority';
  String colStatus = 'status';

  Future<Database?> get db async {
    if (_db == null) {
      _db = await _initDb();
    }
    return _db;
  }

  Future<Database> _initDb() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path + '/todo_list.db';
    final todoListDb =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return todoListDb;
  }

  void _createDb(Database db, int version) async {
    await db.execute('''CREATE TABLE $tableTask(
      $colId INTEGER PRIMARY KEY AUTOINCREMENT,
      $colName TEXT,
      $colDescription TEXT,
      $colDate TEXT,
      $colPriority TEXT,
      $colStatus INTEGER)
    ''');
  }

  Future<List<Map<String, dynamic>>> getTaskMapList() async {
    Database? db = await this.db;
    final List<Map<String, dynamic>> result = await db!.query(tableTask);
    return result;
  }

  Future<List<Task>> getTaskList() async {
    final List<Map<String, dynamic>> taskMapList = await getTaskMapList();
    final List<Task> taskList =
        taskMapList.map((taskMap) => Task.fromMap(taskMap)).toList();
    taskList.sort((a, b) => a.date!.compareTo(b.date!));
    return taskList;
  }

  Future<int> insertTask(Task task) async {
    Database? db = await this.db;
    final int result = await db!.insert(tableTask, task.toMap());
    return result;
  }

  Future<int> updateTask(Task task) async {
    Database? db = await this.db;
    final int result = await db!.update(tableTask, task.toMap(),
        where: '$colId = ?', whereArgs: [task.id]);
    return result;
  }

  Future<int> deleteTask(int id) async {
    Database? db = await this.db;
    final int result =
        await db!.delete(tableTask, where: '$colId = ?', whereArgs: [id]);
    return result;
  }
}
