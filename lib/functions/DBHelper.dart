import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DBHelper {
  static final _databaseVersion = 1;
  static final _databaseName = "database/texting_app.db";

  static final tableUserStatus = 'UserStatus';
  static final cEmail = 'Email';
  static final cStatusMessage = 'StatusMessage';

  static final tableFriendInfo = 'FriendInfo';
  static final cFriendId = 'FriendId';
  static final cFriendName = 'FriendName';
  static final cImageFile = 'ImageFile';
  static final cLastMessage = 'LastMessage';
  static final cDate = 'Date';
  static final cActiveStatus = 'ActiveStatus';
  static final cLoginUserEmail = 'LoginUserEmail';


  final List<String> columnsToSelect = [
    DBHelper.cStatusMessage,
  ];

  DBHelper._privateConstructor();
  static final DBHelper? instance = DBHelper._privateConstructor();

  static Database? _database;
  Future<Database?> get database async {
    if (_database != null) {
    }
    else {
      _database = await _initDatabase();
    }
    return Future.value(_database);
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path, version: _databaseVersion, onCreate: _onCreate);
  }


  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableUserStatus (
        $cEmail TEXT PRIMARY KEY,
        $cStatusMessage TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE $tableFriendInfo (
        $cFriendId TEXT,
        $cLoginUserEmail TEXT,
        $cFriendName TEXT,
        $cLastMessage TEXT,
        $cImageFile TEXT,
        $cDate TEXT,
        $cActiveStatus TEXT,
        PRIMARY KEY ($cFriendId, $cLoginUserEmail)
      )
    ''');
  }


  Future<int> insert(Map<String, dynamic> row) async {
    Database? db = await instance!.database;
    return await db!.insert(tableUserStatus, row);
  }

  Future<int> insertStatusMessage(String email, String statusMessage) async {
    if(email == null) {
      return 0;
    }
    Map<String, dynamic> row = {
      cEmail: email,
      cStatusMessage : statusMessage
    };

    Database? db = await instance!.database;
    return await db!.insert(tableUserStatus, row);
  }


  Future<List<Map<dynamic, dynamic>>?> queryAllRowsFromFriendInfo(String email) async {
    Database? db = await instance!.database;
    List<Map> result = await db!.rawQuery('SELECT * FROM FriendInfo WHERE LoginUserEmail = ?', ['${email}']);
    return result;
  }


  Future<String> getStatusMessage(String? email) async {
    Database? db = await instance!.database;
    List<Map> result = await db!.rawQuery('SELECT StatusMessage FROM UserStatus WHERE Email = ?', ['${email}']);
    if(result == null) {
      return Future.value('');
    }
    else if(result.isEmpty) {
      return Future.value('Not Set');
    }
    else {
      Object tmp = result.elementAt(0).values.first;
      return Future.value(tmp.toString());
    }
  }

  Future<int> update(Map<String, dynamic> row) async {
    Database? db = await instance!.database;
    String email = row[cEmail];
    return await db!.update(tableUserStatus, row, where: '$cEmail = ?', whereArgs: [email]);
  }


  Future<int> updateStatusMessage(String email, String statusMessage) async {
    if(email == null) {
      return 0;
    }
    Map<String, dynamic> row = {
      cEmail: email,
      cStatusMessage : statusMessage
    };

    Database? db = await instance!.database;
    return await db!.update(tableUserStatus, row, where: '$cEmail = ?', whereArgs: [email]);
  }


  Future<int> deleteUserStatusData(String email) async {
    Database? db = await instance!.database;
    return await db!.delete(tableUserStatus, where: '$cEmail = ?', whereArgs: [email]);
  }


  Future<int> deleteFriendInfo(String email) async {
    Database? db = await instance!.database;
    return await db!.delete(tableFriendInfo, where: '$cLoginUserEmail = ?', whereArgs: [email]);
  }


}