import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

import 'package:flutter/widgets.dart';
import 'models/task.dart';

class DatabaseHelper {
  Future<Database> database() async {
    WidgetsFlutterBinding.ensureInitialized();

    return openDatabase(
      join(await getDatabasesPath(), 'todo4.db'),
      onCreate: (db, version) async {
        return db.execute(
          'CREATE TABLE tasks(id INTEGER PRIMARY KEY, title TEXT, description TEXT, status INTEGER, deadline TEXT, noti INTEGER)',
        );
      },
      version: 1,
    );
  }

  Future<int> insertTask(Task task) async {
    int _taskId = 0;
    Database _db = await database();
    await _db
        .insert('tasks', task.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace)
        .then((value) => _taskId = value);
    return _taskId;
  }

  Future<List<Task>> getTaks() async {
    Database _db = await database();
    List<Map<String, dynamic>> taskMap = await _db.query('tasks');
    return List.generate(taskMap.length, (index) {
      return Task(
          id: taskMap[index]['id'],
          title: taskMap[index]['title'],
          description: taskMap[index]['description'],
          status: taskMap[index]['status'],
          deadline: taskMap[index]['deadline'],
          noti: taskMap[index]['noti']);
    });
  }

  Future<void> updateTitleTask(int id, String title) async {
    Database _db = await database();
    await _db.rawUpdate("UPDATE tasks SET title = '$title' WHERE id = '$id'");
  }

  Future<void> updateDescriptionTask(int id, String description) async {
    Database _db = await database();
    await _db.rawUpdate(
        "UPDATE tasks SET description = '$description' WHERE id = '$id'");
  }

  Future<void> deleteTask(int id) async {
    Database _db = await database();
    await _db.rawDelete("DELETE FROM tasks WHERE id = '$id'");
  }

  Future<void> updateStatus(int id, int status) async {
    Database _db = await database();
    await _db.rawUpdate("UPDATE tasks SET status = '$status' WHERE id = '$id'");
  }

  Future<void> updateDeadline(int id, String deadline) async {
    Database _db = await database();
    await _db.rawUpdate("UPDATE tasks SET deadline = '$deadline' WHERE id = '$id'");
  }

   Future<void> updateNotification(int id, int noti) async {
    Database _db = await database();
    await _db.rawUpdate("UPDATE tasks SET noti = '$noti' WHERE id = '$id'");
  }
}
