import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'database_table_params.dart';

class DatabaseHelper {

  // make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DatabaseTableParams.databaseName);
    return await openDatabase(path,
        version: DatabaseTableParams.databaseVersion,
        onCreate: _onCreate);
  }


  static final columnTrans = 'trans';

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE ${DatabaseTableParams.vocabularyTableName} (
            ${DatabaseTableParams.tableColumnId} INTEGER PRIMARY KEY,
            ${DatabaseTableParams.vocabularyTableColumnBase} TEXT NOT NULL,
            ${DatabaseTableParams.vocabularyTableColumnTrans} TEXT NOT NULL,
            ${DatabaseTableParams.vocabularyTableColumnTypeId} INTEGER NOT NULL,
            ${DatabaseTableParams.vocabularyTableColumnGroupId} TEXT NULL,
            ${DatabaseTableParams.vocabularyTableColumnScore} INTEGER NULL
          )
          ''');
    await db.execute('''
          CREATE TABLE ${DatabaseTableParams.paramsTableName} (
            ${DatabaseTableParams.tableColumnId} INTEGER PRIMARY KEY,
            ${DatabaseTableParams.paramsTableColumnVersion} TEXT NOT NULL
          )
          ''');
  }

  Future<int> insert(Map<String, dynamic> row, String tableName) async {
    Database db = await instance.database;
    return await db.insert(tableName, row);
  }

  Future<String> getVersion() async {
    Database db = await instance.database;
    List<Map<String,dynamic>> res = await db.rawQuery('SELECT * FROM ${DatabaseTableParams.paramsTableName}');
    if(res != null && res.length > 0) {
      return res[0][DatabaseTableParams.paramsTableColumnVersion].toString();
    }
    return null;
  }

  Future<List<Map<String,dynamic>>> getVocabularyByType(int type) async {
    Database db = await instance.database;
    List<Map<String,dynamic>> res = await db.rawQuery(''
        'SELECT * '
        'FROM ${DatabaseTableParams.vocabularyTableName} '
        'WHERE ${DatabaseTableParams.vocabularyTableColumnTypeId} = ? '
        'AND (${DatabaseTableParams.vocabularyTableColumnScore} IS NULL '
        'OR ${DatabaseTableParams.vocabularyTableColumnScore} != 1)'
        , [type]);
    if(res != null && res.length > 0) {
      return res;
    }
    return [];
  }


  Future<List<Map<String,dynamic>>> getVocabularyByTypeAndScore(int type, int score) async {
    Database db = await instance.database;
    List<Map<String,dynamic>> res;
    if(score == null) {
      res = await db.rawQuery(''
          'SELECT * '
          'FROM ${DatabaseTableParams.vocabularyTableName} '
          'WHERE ${DatabaseTableParams.vocabularyTableColumnTypeId} = ? '
          'AND ${DatabaseTableParams.vocabularyTableColumnScore} IS NULL'
          , [type]);
    } else {
      res = await db.rawQuery(''
          'SELECT * '
          'FROM ${DatabaseTableParams.vocabularyTableName} '
          'WHERE ${DatabaseTableParams.vocabularyTableColumnTypeId} = ? '
          'AND ${DatabaseTableParams.vocabularyTableColumnScore} = ?'
          , [type, score]);
    }

    if(res != null && res.length > 0) {
      return res;
    }
    return [];
  }

  Future<List<Map<String,dynamic>>> getVocabularyScores() async {
    Database db = await instance.database;
    List<Map<String,dynamic>> res = await db.rawQuery(
        'SELECT '
            '${DatabaseTableParams.vocabularyTableColumnTypeId}, '
            '${DatabaseTableParams.vocabularyTableColumnScore}, '
            'count(*) as score_count '
            'FROM ${DatabaseTableParams.vocabularyTableName} '
            'GROUP BY '
            '${DatabaseTableParams.vocabularyTableColumnTypeId}, '
            '${DatabaseTableParams.vocabularyTableColumnScore}');
    if(res != null && res.length > 0) {
      return res;
    }
    return [];
  }

  Future<int> queryRowCount(String tableName) async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $tableName'));
  }

  Future<int> queryRow(String tableName) async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $tableName'));
  }

  Future<List<Map<String,dynamic>>> queryAllRows(String tableName) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> res = await db.rawQuery('SELECT * FROM $tableName');
    if(res != null && res.length > 0) {
      return res;
    }
    return [];
  }

  Future<int> update(Map<String, dynamic> row, String tableName) async {
    Database db = await instance.database;
    int id = row[DatabaseTableParams.tableColumnId];
    return await db.update(tableName, row, where: '${DatabaseTableParams.tableColumnId} = ?', whereArgs: [id]);
  }

  Future<int> updateVersion(String newVersion, String oldVersion) async {
    Database db = await instance.database;
    int updateRes = await db.rawUpdate('''
    UPDATE ${DatabaseTableParams.paramsTableName} 
    SET ${DatabaseTableParams.paramsTableColumnVersion} = ? 
    WHERE ${DatabaseTableParams.paramsTableColumnVersion} = ?
    ''', [newVersion, oldVersion]);
    return updateRes;
  }

  Future<int> delete(int id, String tableName) async {
    Database db = await instance.database;
    return await db.delete(tableName, where: '${DatabaseTableParams.tableColumnId} = ?', whereArgs: [id]);
  }

  Future<int> deleteAllRows(String tableName) async {
    Database db = await instance.database;
    return await db.delete(tableName);
  }

  Future<void> deleteDatabaseExec(String path) =>
      deleteDatabase(path);

  Future<bool> databaseExistsCheck(String path) async {
    return databaseExists(path);
  }

}