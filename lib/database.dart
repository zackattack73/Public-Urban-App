import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';

class DatabaseHelper {
  static final _databaseName = "MyDatabase.db";
  static final _databaseVersion = 1;

  static final tableObjets = 'Objets';
  static final tableQuestions = 'Questions';
  static final tableRep = 'Rep';

  static final columnId = '_id';
  static final columnIdNotAuto = 'id';
  static final columnType = 'type';
  static final columnLong = 'long';
  static final columnLat = 'lat';
  static final columnRep = 'rep';
  static final columnIdRep = 'idrep';
  static final columnQuest = 'quest';
  static final columnTypeRep = 'typerep';
  static final columnIdQuest = 'idquest';
  static final columnPathImg = 'pathimg';
  static final columnDate = 'date';
  static final columnOrientation = 'orientation';
  static final columnAdresse = 'adresse';
  static final columnTimeAnswer = 'timeanswer';
  // make this a singleton class
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $tableObjets (
            $columnId INTEGER PRIMARY KEY,
            $columnType TEXT NOT NULL,
            $columnLong TEXT NOT NULL,
            $columnLat TEXT NOT NULL,
            $columnIdRep INTEGER NOT NULL,
            $columnPathImg TEXT NOT NULL,
            $columnDate TEXT NOT NULL,
            $columnAdresse TEXT NOT NULL,
            $columnOrientation TEXT NOT NULL
          )
          ''');
    await db.execute('''
          CREATE TABLE $tableQuestions (
            $columnId INTEGER PRIMARY KEY,
            $columnType TEXT NOT NULL,
            $columnQuest TEXT NOT NULL,
            $columnTypeRep TEXT NOT NULL
          )
          ''');
    await db.execute('''
          CREATE TABLE $tableRep (
            $columnId INTEGER PRIMARY KEY,
            $columnIdNotAuto INTEGER NOT NULL,
            $columnIdQuest INTEGER NOT NULL,
            $columnTimeAnswer TEXT NOT NULL,
            $columnRep TEXT NOT NULL
          )
          ''');

    insertQuest() async {
      Map<String, dynamic> row = {
        columnType: "Banc",
        columnQuest: "Comment trouvez vous le confort de ce banc ?",
        columnTypeRep: "Note"
      };
      await db.insert(tableQuestions, row);

      Map<String, dynamic> row2 = {
        columnType: "Banc",
        columnQuest: "Etes-vous satisfait de l'ergonomie de ce banc ?",
        columnTypeRep: "Note"
      };
      await db.insert(tableQuestions, row2);

      Map<String, dynamic> row3 = {
        columnType: "Banc",
        columnQuest: "Comment évaluez vous la propreté de ce banc ?",
        columnTypeRep: "Note"
      };
      await db.insert(tableQuestions, row3);

      Map<String, dynamic> row4 = {
        columnType: "Banc",
        columnQuest: "Comment jugez vous l'environnement sonore de ce banc ?",
        columnTypeRep: "Note"
      };
      await db.insert(tableQuestions, row4);

      Map<String, dynamic> row5 = {
        columnType: "Banc",
        columnQuest: "Comment est votre sentiment de sécurité ?",
        columnTypeRep: "Note"
      };
      await db.insert(tableQuestions, row5);
    }

    insertQuest();
  }

  //Ajoute un objet
  Future<int> insertObjet(String type, String long , String lat, int IDrep, String PathImg, String date, String adresse, String orientation) async {
    Map<String, dynamic> row = {
    columnType: type,
    columnLong: long,
    columnLat : lat,
    columnIdRep : IDrep,
    columnPathImg : PathImg,
    columnDate : date,
    columnAdresse : adresse,
      columnOrientation : orientation,
    };
    Database db = await instance.database;
    return await db.insert(tableObjets, row);
  }
  //Ajoute une réponse
  Future<int> insertRep(int id, int IDquest , String rep, String time) async {
    Map<String, dynamic> row = {
      columnIdNotAuto: id,
      columnIdQuest: IDquest,
      columnTimeAnswer : time,
      columnRep : rep
    };
    Database db = await instance.database;
    return await db.insert(tableRep, row);
  }

  // Renvoie le dernier ID utilisé dans les réponses
  Future<int> getLastIdRep() async {
    Database db = await instance.database;
    var results = await db
        .rawQuery('SELECT MAX($columnIdNotAuto) FROM $tableRep');
print(results);
    if (results.first != null) {
      return results.first["MAX(id)"];
    } else {
      print("WTF ID IS 0");
      return 0;
    }
  }

  // Renvoie les questions d'un type d'objet
  Future<List> getQuestions(String type) async {
    Database db = await instance.database;
    var result = await db.rawQuery('SELECT * FROM $tableQuestions WHERE $columnType = "$type"');
    return result.toList();
  }

  // Renvoie les objets d'un type donné
  Future<List> getObjets(String type) async {
    Database db = await instance.database;
    var result = await db.rawQuery('SELECT * FROM $tableObjets WHERE $columnType = "$type"');
    return result.toList();
  }

  // Renvoie les réponses d'un id donné
  Future<List> getReponses(int ID) async {
    Database db = await instance.database;
    var result = await db.rawQuery('SELECT * FROM $tableRep WHERE $columnIdNotAuto = $ID');
    return result.toList();
  }

  void deleteObject(int ID) async {
    Database db = await instance.database;
    // TODO Delete rep from DB
    //var idrepQuery = await db.rawQuery('SELECT * FROM $tableObjets WHERE $columnId = $ID');
    //String idrep = idrepQuery.toList().toString();
    //print(idrep);
    var result1 = await db.rawQuery('DELETE FROM $tableObjets WHERE $columnId = "$ID"');
    //var result2 = await db.rawQuery('DELETE FROM $tableRep WHERE $columnIdNotAuto = $idrep');
    print(result1.toString());
  }

}