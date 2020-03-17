import 'dart:async';

import './Clip.dart';
import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import './Project.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  final String tableProject = 'ProjectTable';
  final String columnId = 'id';
  final String columnTitle = 'title';
  final String columnDescription = 'description';
  final String columnPath = 'path';

  final String tableClip = 'ClipTable';
  final String clipId = 'clipId';
  final String projectId = 'projectId';
  final String clipTitle = 'title';
  final String clipDescription = 'description';
  final String clipPath = 'path';
  final String clipColor = 'color';
  final String clip = 'description';
  final String clipStartTime = 'startTime';
  final String clipEndTime = 'endTime';

  static Database _db;

  DatabaseHelper.internal();

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();

    return _db;
  }

  initDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'LeanEdit.db');

    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  void _onCreate(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $tableProject($columnId INTEGER PRIMARY KEY AUTOINCREMENT, $columnTitle TEXT, $columnDescription TEXT, $columnPath TEXT)');
    await db.execute(
        'CREATE TABLE $tableClip($clipId INTEGER PRIMARY KEY AUTOINCREMENT, $clipTitle TEXT, $clipDescription TEXT, $clipPath TEXT,$clipColor TEXT,$clipStartTime TEXT, $clipEndTime TEXT, $projectId INTEGER, FOREIGN KEY($projectId) REFERENCES $tableProject($columnId) )');
  }

  Future<int> saveClip(Clip data) async {
    var dbClient = await db;
    debugPrint(data.toString());
    var result = await dbClient.insert(tableClip, data.toMap());

    return result;
  }

  Future<int> saveProject(Project note) async {
    var dbClient = await db;
    var result = await dbClient.insert(tableProject, note.toMap());

    return result;
  }

  Future<List> getAllClip(int id) async {
    var dbClient = await db;
    var result = await dbClient.query(tableClip,
        columns: [
          clipId,
          clipTitle,
          clipDescription,
          clipPath,
          clipColor,
          clipStartTime,
          clipEndTime
        ],
        where: '$projectId = ?',
        whereArgs: [id]);

    // var result = await dbClient.query('SELECT COUNT(*) FROM $tableClip');
    // var result = await dbClient.rawInsert(
    //     'INSERT INTO $tab ($columnTitle, $columnDescription) VALUES (\'${note.title}\', \'${note.description}\')');

    return result;
  }

  Future<List> getAllProjects() async {
    var dbClient = await db;
    var result = await dbClient.query(tableProject,
        columns: [columnId, columnTitle, columnDescription, columnPath]);

    return result.toList();
  } 

  Future<Clip> getClip(int id) async {
    var dbClient = await db;
    List<Map> result = await dbClient.query(tableClip,
        columns: [
          clipId,
          projectId,
          clipTitle,
          clipDescription,
          clipPath,
          clipColor,
          clipStartTime,
          clipEndTime
        ],
        where: '$clipId = ?',
        whereArgs: [id]);
    if (result.length > 0) {
      return new Clip.fromMap(result.first);
    }

    return null;
  }

  Future<Project> getProject(int id) async {
    var dbClient = await db;
    List<Map> result = await dbClient.query(tableProject,
        columns: [columnId, columnTitle, columnDescription, columnPath],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (result.length > 0) {
      return new Project.fromMap(result.first);
    }

    return null;
  }

  Future<int> deleteClip(int cid) async {
    debugPrint(cid.toString());
    var dbClient = await db;
    var ret = await dbClient
        .delete(tableClip, where: '$clipId >= ?', whereArgs: [cid]);

    debugPrint(ret.toString());
    return ret;
  }

  Future<int> deleteProject(int id) async {
    var dbClient = await db;
    debugPrint('Result');
    var ret = await dbClient
        .delete(tableProject, where: '$columnId = ?', whereArgs: [id]);

    return ret;
  }

  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }
}
