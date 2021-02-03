import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:wordy/common/app_enums.dart';
import 'package:wordy/common/cache_params.dart';
import 'package:wordy/persistent/database_helper.dart';
import 'package:wordy/persistent/database_table_params.dart';

class PracticePage extends StatefulWidget {
  PracticePage({Key key, this.practiceType}) : super(key: key);

  final PracticeType practiceType;

  @override
  _PracticePageState createState() => _PracticePageState(practiceType: practiceType);
}

class _PracticePageState extends State<PracticePage> {
  final dbHelper = DatabaseHelper.instance;
  FlutterTts flutterTts = FlutterTts();
  FlutterTts flutterTtsBase = FlutterTts();

  String transCode = "ro-RO";
  String baseCode = "en-US";


  PracticeType practiceType;
  String title;
  int maxTextRow = 1;
  int maxTextSize = 32;
  bool showAnswer = false;
  bool initRead = false;

  bool isLoadingDb = true;
  List<Map<String, dynamic>> queryRes = [];
  int index = 0;
  int oldIndex = 0;
  bool isFirstLoad = true;
  Map<String, dynamic> currentRec;

  int startNumber = 0;
  int endNumber = 0;

  bool selectIndex = true;
  Random random = Random();

  String currentBase = '';
  String currentTrans = '';
  int currentId = -1;

  String titleColor;

  _PracticePageState({this.practiceType}) {
    if(practiceType == PracticeType.WORDS_GREEN ||
       practiceType == PracticeType.CONVERSATIONS_GREEN ||
       practiceType == PracticeType.PHRASES_GREEN
    ) {
      titleColor = 'GREEN';
    } else if(practiceType == PracticeType.WORDS_RED ||
        practiceType == PracticeType.CONVERSATIONS_RED ||
        practiceType == PracticeType.PHRASES_RED
    ) {
      titleColor = 'RED';
    } else if(practiceType == PracticeType.WORDS_YELLOW ||
        practiceType == PracticeType.CONVERSATIONS_YELLOW ||
        practiceType == PracticeType.PHRASES_YELLOW
    ) {
      titleColor = 'YELLOW';
    } else if(practiceType == PracticeType.WORDS_GREY ||
        practiceType == PracticeType.CONVERSATIONS_GREY ||
        practiceType == PracticeType.PHRASES_GREY
    ) {
      titleColor = 'GREY';
    }

    String initType;
    switch (practiceType) {
      case PracticeType.WORDS:
        initType = 'words';
        break;
      case PracticeType.PHRASES:
        initType = 'phrases';
        break;
      case PracticeType.CONVERSATIONS:
        initType = 'conversation';
        break;
      case PracticeType.WORDS_GREEN:
        initType = 'words';
        titleColor = 'GREEN';
        break;
      case PracticeType.PHRASES_GREEN:
        initType = 'phrases';
        titleColor = 'GREEN';
        break;
      case PracticeType.CONVERSATIONS_GREEN:
        initType = 'conversation';
        titleColor = 'GREEN';
        break;
      case PracticeType.WORDS_YELLOW:
        initType = 'words';
        titleColor = 'YELLOW';
        break;
      case PracticeType.PHRASES_YELLOW:
        initType = 'phrases';
        titleColor = 'YELLOW';
        break;
      case PracticeType.CONVERSATIONS_YELLOW:
        initType = 'conversation';
        titleColor = 'YELLOW';
        break;
      case PracticeType.WORDS_RED:
        initType = 'words';
        titleColor = 'RED';
        break;
      case PracticeType.PHRASES_RED:
        initType = 'phrases';
        titleColor = 'RED';
        break;
      case PracticeType.CONVERSATIONS_RED:
        initType = 'conversation';
        titleColor = 'RED';
        break;
      case PracticeType.WORDS_GREY:
        initType = 'words';
        titleColor = 'GREY';
        break;
      case PracticeType.PHRASES_GREY:
        initType = 'phrases';
        titleColor = 'GREY';
        break;
      case PracticeType.CONVERSATIONS_GREY:
        initType = 'conversation';
        titleColor = 'GREY';
        break;

    }

    if(initType == 'words') {
      title = 'Words';
      maxTextRow = 1;
      maxTextSize = 32;
    } else if(initType == 'phrases') {
      title = 'Phrases';
      maxTextRow = 3;
      maxTextSize = 26;
    } if(initType == 'conversation') {
      title = 'Conversations';
      maxTextRow = 4;
      maxTextSize = 22;
    }
  }

  @override
  void initState() {
    setTTS().then((ttsRes) {
      loadRecFromDb().then((res) {
        setState(() {
          isLoadingDb = false;
        });
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool endOfLesson = false;
    if (queryRes.length > 0) {
      oldIndex = index;
      if (startNumber == 0) {
        startNumber++;
      }
      if (selectIndex) {
        if(practiceType == PracticeType.CONVERSATIONS) {
          if(index != 0) {
            index++;
          }
        } else {
          index = random.nextInt(queryRes.length);
        }
        selectIndex = false;
      }

      if(isFirstLoad) {
        initRead = true;
      }

      currentBase = queryRes[index]['base'];
      currentTrans = queryRes[index]['trans'];
      currentId = queryRes[index]['_id'];
      currentRec = queryRes[index];

      if(initRead) {
        Future.delayed(Duration(milliseconds: 140)).then((_) async {
          readBase();
        });
      }
    } else {
      endOfLesson = true;
    }

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).backgroundColor),
        backgroundColor: Theme.of(context).accentColor.withOpacity(0.7),
        title: Text(title + '  ' + (endNumber > 0 ? ('(' + startNumber.toString() + '/' + endNumber.toString() + ')') : '')),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              moveToLastScreen();
            }),
        actions: titleColor != null ? [
          titleColor == 'GREEN' ? Container(
            height: 30,
            width: 50,
            color: Colors.greenAccent,
            child: Icon(
              Icons.done,
              color: Colors.white,
              size: 22,
            ),
          ) : titleColor == 'YELLOW' ?
          Container(
            height: 30,
            width: 50,
            color: Colors.yellow,
            child: Icon(
              Icons.info_outline,
              color: Colors.white,
              size: 22,
            ),
          ) : titleColor == 'RED' ?
          Container(
            height: 30,
            width: 50,
            color: Colors.redAccent,
            child: Icon(
              Icons.clear,
              color: Colors.white,
              size: 22,
            ),
          ) : titleColor == 'GREY' ?
          Container(
            height: 30,
            width: 50,
            color: Colors.grey[400],
            child: Icon(
              Icons.update,
              color: Colors.white,
              size: 22,
            ),
          ) : null
        ] : null,
      ),
      floatingActionButton: isLoadingDb || endOfLesson
          ? null
          : FloatingActionButton(
              onPressed: () {
                setState(() {
                  showAnswer = true;
                });
                readTrans();
              },
              child: Icon(Icons.settings_voice),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: isLoadingDb
          ? Center(
              child: SizedBox(
                child: CircularProgressIndicator(),
                height: 60.0,
                width: 60.0,
              ),
            )
          : endOfLesson
              ? ListView(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 25, right: 25, top: 20, bottom: 15),
                      padding: EdgeInsets.all(10),
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.blueAccent.withOpacity(0.3), width: 4),
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      child: Center(
                          child: AutoSizeText(
                        'End of lesson',
                        style: TextStyle(fontSize: 32, color: Colors.grey),
                        minFontSize: 15,
                        maxLines: maxTextRow,
                      )),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 25, right: 25, bottom: 30),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  moveToLastScreen();
                                },
                                child: Container(
                                  width: (MediaQuery.of(context).size.width - 50 - 10) / 2,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[400],
                                    border: Border.all(color: Colors.grey[400].withOpacity(0.3), width: 4),
                                    borderRadius: BorderRadius.all(Radius.circular(5)),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.arrow_back,
                                        color: Colors.white,
                                        size: 22,
                                      ),
                                      SizedBox(
                                        width: 1,
                                      ),
                                      Text(
                                        "Go back  ",
                                        style: TextStyle(color: Colors.white, fontSize: 18),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              GestureDetector(
                                  onTap: () {
                                    restartLesson();
                                  },
                                  child: Container(
                                    width: (MediaQuery.of(context).size.width - 50 - 10) / 2,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: Colors.blueAccent,
                                      border: Border.all(color: Colors.blueAccent.withOpacity(0.3), width: 4),
                                      borderRadius: BorderRadius.all(Radius.circular(5)),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.play_circle_filled,
                                          color: Colors.white,
                                          size: 22,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          "Go again  ",
                                          style: TextStyle(color: Colors.white, fontSize: 18),
                                        )
                                      ],
                                    ),
                                  ))
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                )
              : ListView(
                  children: [
                    Stack(
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 25, right: 25, top: 20, bottom: 15),
                          padding: EdgeInsets.all(10),
                          height: 200,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.blueAccent.withOpacity(0.3), width: 4),
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                          child: Center(
                              child: AutoSizeText(
                                currentBase,
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 32, color: Colors.blueAccent),
                                minFontSize: 15,
                                maxLines: maxTextRow,
                              )),
                        ),
                        Positioned(
                          left: 40,
                          top: 35,
                          child: GestureDetector(
                            onTap: () {
                              readBase();
                            },
                            child: Icon(Icons.volume_up, color: Colors.blueAccent),
                          )
                        )
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 25, right: 25, bottom: 15),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  scoreRecord(3);
                                },
                                child: Container(
                                  width: (MediaQuery.of(context).size.width - 50 - 10) / 2,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: Colors.redAccent,
                                    border: Border.all(color: Colors.redAccent.withOpacity(0.3), width: 4),
                                    borderRadius: BorderRadius.all(Radius.circular(5)),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.clear,
                                        color: Colors.white,
                                        size: 22,
                                      ),
                                      SizedBox(
                                        width: 1,
                                      ),
                                      Text(
                                        "Don't know  ",
                                        style: TextStyle(color: Colors.white, fontSize: 18),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              GestureDetector(
                                  onTap: () {
                                    scoreRecord(1);
                                  },
                                  child: Container(
                                    width: (MediaQuery.of(context).size.width - 50 - 10) / 2,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: Colors.greenAccent,
                                      border: Border.all(color: Colors.greenAccent.withOpacity(0.3), width: 4),
                                      borderRadius: BorderRadius.all(Radius.circular(5)),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.done,
                                          color: Colors.white,
                                          size: 22,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          "Too easy  ",
                                          style: TextStyle(color: Colors.white, fontSize: 18),
                                        )
                                      ],
                                    ),
                                  ))
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                  onTap: () {
                                    scoreRecord(2);
                                  },
                                  child: Container(
                                    width: (MediaQuery.of(context).size.width - 50 - 10) / 2,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: Colors.yellow,
                                      border: Border.all(color: Colors.yellow.withOpacity(0.3), width: 4),
                                      borderRadius: BorderRadius.all(Radius.circular(5)),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.info_outline,
                                          color: Colors.white,
                                          size: 22,
                                        ),
                                        SizedBox(
                                          width: 4,
                                        ),
                                        Text(
                                          "Not so sure",
                                          style: TextStyle(color: Colors.white, fontSize: 18),
                                        )
                                      ],
                                    ),
                                  )),
                              SizedBox(
                                width: 10,
                              ),
                              GestureDetector(
                                onTap: () {
                                  scoreRecord(null);
                                },
                                child: Container(
                                    width: (MediaQuery.of(context).size.width - 50 - 10) / 2,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[400],
                                      border: Border.all(color: Colors.grey[400].withOpacity(0.3), width: 4),
                                      borderRadius: BorderRadius.all(Radius.circular(5)),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.update,
                                          color: Colors.white,
                                          size: 22,
                                        ),
                                        SizedBox(
                                          width: 4,
                                        ),
                                        Text(
                                          "Next time  ",
                                          style: TextStyle(color: Colors.white, fontSize: 18),
                                        )
                                      ],
                                    )),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    showAnswer ? Container(
                      margin: EdgeInsets.only(left: 25, right: 25, top: 0, bottom: 20),
                      padding: EdgeInsets.all(10),
                      height: 170,
                      decoration: BoxDecoration(
                        color: Colors.blueAccent.withOpacity(0.9),
                        border: Border.all(color: Colors.blueAccent.withOpacity(0.3), width: 4),
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      child: Column(
                        children: [
                          Container(
                            height: 20,
                            child: Center(
                                child: Text('Answer', style: TextStyle(color: Colors.white, fontSize: 22, decoration: TextDecoration.underline),)
                            ),
                          ),
                          Container(
                            height: 122,
                            child: Center(
                                child: AutoSizeText(
                                  currentTrans,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 32, color: Colors.white),
                                  minFontSize: 15,
                                  maxLines: maxTextRow,
                                )),
                          ),
                        ],
                      ),
                    ) : SizedBox.shrink(),
                  ],
                ),
    );
  }

  void navToPracticePage(PracticeType practiceType) async {
    var result = await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return PracticePage(practiceType: practiceType);
    }));

    if (result != null) {}
  }

  Future<void> moveToLastScreen() async {
    return Navigator.pop(context);
  }

  Future<void> loadRecFromDb() async {
    //await Future.delayed(Duration(seconds: 5));
    switch (practiceType) {
      case PracticeType.WORDS:
        queryRes = await dbHelper.getVocabularyByType(CacheParams.wordsType);
        break;
      case PracticeType.PHRASES:
        queryRes = await dbHelper.getVocabularyByType(CacheParams.phrasesType);
        break;
      case PracticeType.CONVERSATIONS:
        queryRes = await dbHelper.getVocabularyByType(CacheParams.conversationsType);
        break;

      case PracticeType.WORDS_GREEN:
        queryRes = await dbHelper.getVocabularyByTypeAndScore(CacheParams.wordsType, 1);
        break;
      case PracticeType.PHRASES_GREEN:
        queryRes = await dbHelper.getVocabularyByTypeAndScore(CacheParams.phrasesType, 1);
        break;
      case PracticeType.CONVERSATIONS_GREEN:
        queryRes = await dbHelper.getVocabularyByTypeAndScore(CacheParams.conversationsType, 1);
        break;

      case PracticeType.WORDS_YELLOW:
        queryRes = await dbHelper.getVocabularyByTypeAndScore(CacheParams.wordsType, 2);
        break;
      case PracticeType.PHRASES_YELLOW:
        queryRes = await dbHelper.getVocabularyByTypeAndScore(CacheParams.phrasesType, 2);
        break;
      case PracticeType.CONVERSATIONS_YELLOW:
        queryRes = await dbHelper.getVocabularyByTypeAndScore(CacheParams.conversationsType, 2);
        break;

      case PracticeType.WORDS_RED:
        queryRes = await dbHelper.getVocabularyByTypeAndScore(CacheParams.wordsType, 3);
        break;
      case PracticeType.PHRASES_RED:
        queryRes = await dbHelper.getVocabularyByTypeAndScore(CacheParams.phrasesType, 3);
        break;
      case PracticeType.CONVERSATIONS_RED:
        queryRes = await dbHelper.getVocabularyByTypeAndScore(CacheParams.conversationsType, 3);
        break;

      case PracticeType.WORDS_GREY:
        queryRes = await dbHelper.getVocabularyByTypeAndScore(CacheParams.wordsType, null);
        break;
      case PracticeType.PHRASES_GREY:
        queryRes = await dbHelper.getVocabularyByTypeAndScore(CacheParams.phrasesType, null);
        break;
      case PracticeType.CONVERSATIONS_GREY:
        queryRes = await dbHelper.getVocabularyByTypeAndScore(CacheParams.conversationsType, null);
        break;
    }
    queryRes = queryRes.toList();
    endNumber = queryRes.length;
  }

  void scoreRecord(int scoreId) async {
    // 1 = too easy
    // 2 = not so sure
    // 3 = dont know
    // null = next time
    if (scoreId != null) {
      Map<String, dynamic> obj = {"_id": currentRec['_id'], "base": currentRec['base'], "trans": currentRec['trans'], "type_id": currentRec['type_id'], "group_id": currentRec['group_id'], "score": scoreId};

      await dbHelper.update(obj, DatabaseTableParams.vocabularyTableName);
    }
    await flutterTts.stop();
    isFirstLoad = true;
    setState(() {
      queryRes.removeAt(index);
      selectIndex = true;
      showAnswer = false;
      if (endNumber != startNumber) {
        startNumber++;
      }
    });
  }

  void restartLesson() {
    flutterTts.stop();
    setState(() {
      isLoadingDb = true;
      startNumber = 0;
      showAnswer = false;
    });
    loadRecFromDb().then((res) {
      setState(() {
        isLoadingDb = false;
      });
    });
  }

  Future<void> setTTS() async {
    await flutterTts.setLanguage(transCode);
    await flutterTts.setSpeechRate(1.0);
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.0);
  }

  void readBase() async {
    await flutterTts.setLanguage(baseCode);
    flutterTts.speak(currentBase);
    initRead = false;
    if(isFirstLoad) {
      isFirstLoad = false;
    }
  }

  void readTrans() async {
    await flutterTts.setLanguage(transCode);
    flutterTts.speak(currentTrans);
  }
}
