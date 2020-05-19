import 'dart:io';
import 'package:flutter/cupertino.dart';

import '../models/transaction.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

final String tableExpense = 'expenses';
final String columnId = '_id';
final String columnTitle = 'title';
final String columnDate = 'date';
final String columnAmount = 'amount';

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();

  static Database _database;

  Future<Database> get database async {
    if (_database != null)
      return _database;

    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }
  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path =  documentsDirectory.path+ "expenses.db";
    return await openDatabase(path, version: 1, onOpen: (db) {
    }, onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE $tableExpense ("
          "$columnId INTEGER PRIMARY KEY AUTOINCREMENT,"
          "$columnTitle TEXT NOT NULL,"
          "$columnDate TEXT NOT NULL,"
          "$columnAmount DOUBLE"
          ")");
    });
  }

  addNewTask(Expense task) async {
    final db = await database;
    var res = await db.insert(tableExpense, task.toMap());
    return res;
  }

  getTask(int id) async {
    final db = await database;
    var res =await  db.query(tableExpense, where: "$columnId = ?", whereArgs: [id]);
    return res.isNotEmpty ? Expense.fromMap(res.first) : null ;
  }

  getAllTasks() async {
    final db = await database;
    var res = await db.query(tableExpense, orderBy: '$columnId DESC');
    List<Expense> list = [];
    for (int i=0; i<res.length; i++){
      list.add(Expense.fromMap(res[i]));
    }
    return list;
  }

  updateClient(Expense task) async {
    final db = await database;
    var res = await db.update(tableExpense, task.toMapUpdate(),
        where: "$columnId = ?", whereArgs: [task.id]);
    return res;
  }

  deleteExpense(int id) async {
    final db = await database;
    var d = await db.delete(tableExpense, where: '$columnId = ?', whereArgs: [id]);
    return d;
  }

}