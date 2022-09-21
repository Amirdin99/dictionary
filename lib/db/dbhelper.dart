import 'dart:io';

import 'package:dictionary/models/dictionary_data.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  DbHelper._();

  static const databaseName = 'dictionary.db';
  static const databaseVersion = 1;

  DbHelper._databasePrivateContructor();

  static final DbHelper instance = DbHelper._databasePrivateContructor();

  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    }
    _database = await initialize();
    return _database;

   // return initialize();
  }

  initialize() async {
    var databasepath = await getDatabasesPath();
    String path = join(databasepath, databaseName);
    var exist = await databaseExists(path);

    if (!exist) {
      print("Copy database to storage");

      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (ex) {
        print(ex);
      }
//copy
      ByteData data = await rootBundle.load(join("assets", databaseName));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      // write

      await File(path).writeAsBytes(bytes, flush: true);

      return await openDatabase(path, version: databaseVersion);
    } else {
      print("opening existing db");
      return await openDatabase(path, version: databaseVersion);
    }
  }

  //insert

  Future<int> insertWords(DictionaryData dictionaryData) async {
    final db = await database;
    var res = db!.insert(DbHelper.databaseName, dictionaryData.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return res;
  }

  // select

  Future<List<DictionaryData>> getSelectWords(String query) async {
    var db = await database;
    final List<Map<String, dynamic>> maps = await db!.query(
        DictionaryData.tableName1,
         where: 'word like ?',
         whereArgs: ['${query}%']);


    print(maps);
    return List.generate(maps.length, (index) {
      print(maps[index]);
      print("ishladi");
      return DictionaryData.fromJson(maps[index]);
    });
  }

  Future<List<DictionaryData>> getFavouriteWords(String query) async {
    var db = await database;
    final List<Map<String, dynamic>> maps = await db!.rawQuery(
        'select * from entries  where favourite = 0 AND word like ?',
        ['${query}%']);
    print(maps);
    return List.generate(maps.length, (index) {
      print(maps[index]);
      return DictionaryData.fromJson(maps[index]);
    });
  }

  //update

  Future<int> setFavourite(DictionaryData dictionaryData) async {
    var db = await database;

    return db!.update(
      DictionaryData.tableName1,
      dictionaryData.toJson(),
      where: 'id ?',
      whereArgs: [dictionaryData.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
