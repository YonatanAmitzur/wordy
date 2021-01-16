import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wordy/common/cache_params.dart';
import 'package:wordy/pages/home_page.dart';
import 'package:wordy/persistent/database_helper.dart';
import 'package:wordy/persistent/database_table_params.dart';

class StartPage extends StatefulWidget {
  StartPage({Key key}) : super(key: key);

  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {

  final dbHelper = DatabaseHelper.instance;
  bool navNext = false;

  @override
  void initState() {
    getApplicationDocumentsDirectory().then((Directory documentsDirectory) {
      String dbPath = join(documentsDirectory.path, DatabaseTableParams.databaseName);
      dbHelper.databaseExistsCheck(dbPath).then((bool isExist) {
        if(isExist != null && isExist) {
          _loadFromAsset().then((vocabularyJson) {
//            dbHelper.deleteDatabaseExec(dbPath).then((value) {
//              int stop = 1;
//            });
            updateDb(vocabularyJson).then((value) {
              setState(() {
                navNext = true;
              });
            });
          });
          //delete database
        } else {
          dbHelper.database.then((db) {
            _loadFromAsset().then((vocabularyJson) {
              initDb(vocabularyJson).then((value) {
                setState(() {
                  navNext = true;
                });
              });
            });
          });
        }

      });

    });
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {

    if(navNext) {
      Future.delayed(Duration(milliseconds: 100)).then((_) async {
        navToHomePage(context);
      });
    }

    return Scaffold(
      body: Center(
        child: Text('Loading...', style: TextStyle(fontSize: 50, color: Colors.blueAccent, fontWeight: FontWeight.bold),),
      ),
    );
  }

  void navToHomePage(BuildContext context) async {
    var result = await Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return HomePage();
    }));

    if (result != null) {}
  }

  Future<String> _loadFromAsset() async {
    return await rootBundle.loadString("assets/vocabulary.json");
  }

  Future<void> initDb(String vocabularyJson) async {
    Map<String, dynamic> vocabularyMap = jsonDecode(vocabularyJson);
    String jsonVersion = vocabularyMap['version'];
    Map<String, dynamic> jsonConversations = vocabularyMap['conversations'];
    Map<String, dynamic> jsonWords = vocabularyMap['words'];
    Map<String, dynamic> jsonPhrases = vocabularyMap['phrases'];
    await dbHelper.insert({DatabaseTableParams.paramsTableColumnVersion: jsonVersion}, DatabaseTableParams.paramsTableName);
    List<Map<String, dynamic>> sections = [jsonWords, jsonPhrases, jsonConversations];
    List<int> sectionsIds = [CacheParams.wordsType, CacheParams.phrasesType, CacheParams.conversationsType];
    for(int j = 0; j < sections.length; j++) {
      List<String> sectionKeysIds = sections[j].keys.toList();
      for(int i = 0; i < sectionKeysIds.length; i++) {
        String id = sectionKeysIds[i];
        Map<String, dynamic> sectionKeys = sections[j][id];
        String base = sectionKeys['base'];
        String trans = sectionKeys['trans'];
        Map<String, dynamic> row = {
          DatabaseTableParams.tableColumnId: int.parse(id),
          DatabaseTableParams.vocabularyTableColumnBase: base,
          DatabaseTableParams.vocabularyTableColumnTrans: trans,
          DatabaseTableParams.vocabularyTableColumnGroupId: sectionKeys[DatabaseTableParams.vocabularyTableColumnGroupId] != null ? DatabaseTableParams.vocabularyTableColumnGroupId : null,
          DatabaseTableParams.vocabularyTableColumnTypeId: sectionsIds[j],
          DatabaseTableParams.vocabularyTableColumnScore: null,
        };
        await dbHelper.insert(row, DatabaseTableParams.vocabularyTableName);
      }
    }
  }

  Future<void> updateDb(String vocabularyJson) async {
    Map<String, dynamic> vocabularyMap = jsonDecode(vocabularyJson);
    String jsonVersion = vocabularyMap['version'];
    String currentDbVersion = await dbHelper.getVersion();
    if(jsonVersion != currentDbVersion) {
      List<Map<String, dynamic>> vocabularyDbRows = await dbHelper.queryAllRows(DatabaseTableParams.vocabularyTableName);
      Map<int, Map<String,dynamic>> mapVocabularyDbRows = {};
      for(int j = 0; j < vocabularyDbRows.length; j++) {
        mapVocabularyDbRows[vocabularyDbRows[j][DatabaseTableParams.tableColumnId]] = vocabularyDbRows[j];
      }

      Map<int, int> scoreMap = {};

      Map<String, dynamic> jsonConversations = vocabularyMap['conversations'];
      Map<String, dynamic> jsonWords = vocabularyMap['words'];
      Map<String, dynamic> jsonPhrases = vocabularyMap['phrases'];
      for(int i = 0; i < jsonConversations.length; i++) {
        List<String> jsonConversationsKeys = jsonConversations.keys.toList();
        for(int k = 0; k < jsonConversationsKeys.length; k++) {
          int currentKey = int.parse(jsonConversationsKeys[k]);
          if(mapVocabularyDbRows[currentKey] != null) {
            int score = mapVocabularyDbRows[currentKey][DatabaseTableParams.vocabularyTableColumnScore];
            scoreMap[mapVocabularyDbRows[currentKey][DatabaseTableParams.tableColumnId]] = score;
          }
        }
      }
      for(int i = 0; i < jsonWords.length; i++) {
        List<String> jsonWordsKeys = jsonWords.keys.toList();
        for(int k = 0; k < jsonWordsKeys.length; k++) {
          int currentKey = int.parse(jsonWordsKeys[k]);
          if(mapVocabularyDbRows[currentKey] != null) {
            int score = mapVocabularyDbRows[currentKey][DatabaseTableParams.vocabularyTableColumnScore];
            scoreMap[mapVocabularyDbRows[currentKey][DatabaseTableParams.tableColumnId]] = score;
          }
        }
      }
      for(int i = 0; i < jsonPhrases.length; i++) {
        List<String> jsonPhrasesKeys = jsonPhrases.keys.toList();
        for(int k = 0; k < jsonPhrasesKeys.length; k++) {
          int currentKey = int.parse(jsonPhrasesKeys[k]);
          if(mapVocabularyDbRows[currentKey] != null) {
            int score = mapVocabularyDbRows[currentKey][DatabaseTableParams.vocabularyTableColumnScore];
            scoreMap[mapVocabularyDbRows[currentKey][DatabaseTableParams.tableColumnId]] = score;
          }
        }
      }
      await dbHelper.deleteAllRows(DatabaseTableParams.vocabularyTableName);
      List<Map<String, dynamic>> sections = [jsonWords, jsonPhrases, jsonConversations];
      List<int> sectionsIds = [CacheParams.wordsType, CacheParams.phrasesType, CacheParams.conversationsType];
      for(int j = 0; j < sections.length; j++) {
        List<String> sectionKeysIds = sections[j].keys.toList();
        for(int i = 0; i < sectionKeysIds.length; i++) {
          String id = sectionKeysIds[i];
          Map<String, dynamic> sectionKeys = sections[j][id];
          Map<String, dynamic> row = {
            DatabaseTableParams.tableColumnId: int.parse(id),
            DatabaseTableParams.vocabularyTableColumnBase: sectionKeys['base'],
            DatabaseTableParams.vocabularyTableColumnTrans: sectionKeys['trans'],
            DatabaseTableParams.vocabularyTableColumnGroupId: sectionKeys['group_id'],
            DatabaseTableParams.vocabularyTableColumnTypeId: sectionsIds[j],
            DatabaseTableParams.vocabularyTableColumnScore: scoreMap[int.parse(id)],
          };
          await dbHelper.insert(row, DatabaseTableParams.vocabularyTableName);
        }
      }
      await dbHelper.updateVersion(jsonVersion, currentDbVersion);
    }
  }
}
