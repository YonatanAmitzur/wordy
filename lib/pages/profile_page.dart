import 'package:flutter/material.dart';
import 'package:wordy/common/app_enums.dart';
import 'package:wordy/persistent/database_helper.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  final dbHelper = DatabaseHelper.instance;

  int type1ScoreNull;
  int type1Score1;
  int type1Score2;
  int type1Score3;

  int type2ScoreNull;
  int type2Score1;
  int type2Score2;
  int type2Score3;

  int type3ScoreNull;
  int type3Score1;
  int type3Score2;
  int type3Score3;


  @override
  void initState() {
    loadScoreFromDb().then((res) {
      setState(() {
        //isLoadingDb = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).backgroundColor),
        backgroundColor: Theme.of(context).accentColor.withOpacity(0.7),
        title: Text('Score Table'),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              moveToLastScreen();
            }),
      ),
      body: ListView(
        children: [
//          Container(
//            margin: EdgeInsets.only(left: 25, right: 25, top: 25),
//            child: Text(
//              'Your score',
//              style: TextStyle(color: Colors.blueAccent, fontSize: 32),
//            ),
//          ),
//          Container(
//            margin: EdgeInsets.only(left: 25, right: 25),
//            child: Divider(color: Colors.grey,),
//          ),
          Container(
            margin: EdgeInsets.only(left: 25, right: 25, top: 10),
            child: Text(
              'Words',
              style: TextStyle(color: Colors.blueAccent, fontSize: 23),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 25, right: 25, top: 10),
            child: Row(
              children: [
                Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    color: Colors.greenAccent,
                    border: Border.all(color: Colors.greenAccent.withOpacity(0.3), width: 4),
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  child: Icon(
                    Icons.done,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
                SizedBox(width: 6,),
                Text((type1Score1 == null ? '0 ' : type1Score1.toString() + ' ') + 'Easy', style: TextStyle(fontSize: 17),)
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 25, right: 25, top: 10),
            child: Row(
              children: [
                Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    color: Colors.yellow,
                    border: Border.all(color: Colors.yellow.withOpacity(0.3), width: 4),
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  child: Icon(
                    Icons.info_outline,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
                SizedBox(width: 6,),
                Text((type1Score2 == null ? '0 ' : type1Score2.toString() + ' ') + 'Not so sure', style: TextStyle(fontSize: 17),)
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 25, right: 25, top: 10),
            child: Row(
              children: [
                Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    border: Border.all(color: Colors.redAccent.withOpacity(0.3), width: 4),
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  child: Icon(
                    Icons.clear,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
                SizedBox(width: 6,),
                Text((type1Score3 == null ? '0 ' : type1Score3.toString() + ' ') + 'Dont know', style: TextStyle(fontSize: 17),)
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 25, right: 25, top: 10),
            child: Row(
              children: [
                Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    border: Border.all(color: Colors.grey[400].withOpacity(0.3), width: 4),
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  child: Icon(
                    Icons.update,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
                SizedBox(width: 6,),
                Text((type1ScoreNull == null ? '0 ' : type1ScoreNull.toString() + ' ') + 'Next time', style: TextStyle(fontSize: 17),)
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 25, right: 25, top: 10),
            child: Divider(color: Colors.grey,),
          ),
          Container(
            margin: EdgeInsets.only(left: 25, right: 25, top: 6),
            child: Text(
              'Phrases',
              style: TextStyle(color: Colors.blueAccent, fontSize: 23),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 25, right: 25, top: 10),
            child: Row(
              children: [
                Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    color: Colors.greenAccent,
                    border: Border.all(color: Colors.greenAccent.withOpacity(0.3), width: 4),
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  child: Icon(
                    Icons.done,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
                SizedBox(width: 6,),
                Text((type2Score1 == null ? '0 ' : type2Score1.toString() + ' ') + 'Easy', style: TextStyle(fontSize: 17),)
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 25, right: 25, top: 10),
            child: Row(
              children: [
                Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    color: Colors.yellow,
                    border: Border.all(color: Colors.yellow.withOpacity(0.3), width: 4),
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  child: Icon(
                    Icons.info_outline,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
                SizedBox(width: 6,),
                Text((type2Score2 == null ? '0 ' : type2Score2.toString() + ' ') + 'Not so sure', style: TextStyle(fontSize: 17),)
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 25, right: 25, top: 10),
            child: Row(
              children: [
                Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    border: Border.all(color: Colors.redAccent.withOpacity(0.3), width: 4),
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  child: Icon(
                    Icons.clear,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
                SizedBox(width: 6,),
                Text((type2Score3 == null ? '0 ' : type2Score3.toString() + ' ') + 'Dont know', style: TextStyle(fontSize: 17),)
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 25, right: 25, top: 10),
            child: Row(
              children: [
                Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    border: Border.all(color: Colors.grey[400].withOpacity(0.3), width: 4),
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  child: Icon(
                    Icons.update,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
                SizedBox(width: 6,),
                Text((type2ScoreNull == null ? '0 ' : type2ScoreNull.toString() + ' ') + 'Next time', style: TextStyle(fontSize: 17),)
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 25, right: 25, top: 10),
            child: Divider(color: Colors.grey,),
          ),
          Container(
            margin: EdgeInsets.only(left: 25, right: 25, top: 6),
            child: Text(
              'Conversations',
              style: TextStyle(color: Colors.blueAccent, fontSize: 23),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 25, right: 25, top: 10),
            child: Row(
              children: [
                Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    color: Colors.greenAccent,
                    border: Border.all(color: Colors.greenAccent.withOpacity(0.3), width: 4),
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  child: Icon(
                    Icons.done,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
                SizedBox(width: 6,),
                Text((type3Score1 == null ? '0 ' : type3Score1.toString() + ' ') + 'Easy', style: TextStyle(fontSize: 17),)
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 25, right: 25, top: 10),
            child: Row(
              children: [
                Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    color: Colors.yellow,
                    border: Border.all(color: Colors.yellow.withOpacity(0.3), width: 4),
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  child: Icon(
                    Icons.info_outline,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
                SizedBox(width: 6,),
                Text((type3Score2 == null ? '0 ' : type3Score2.toString() + ' ') + 'Not so sure', style: TextStyle(fontSize: 17),)
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 25, right: 25, top: 10),
            child: Row(
              children: [
                Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    border: Border.all(color: Colors.redAccent.withOpacity(0.3), width: 4),
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  child: Icon(
                    Icons.clear,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
                SizedBox(width: 6,),
                Text((type3Score3 == null ? '0 ' : type3Score3.toString() + ' ') + 'Dont know', style: TextStyle(fontSize: 17),)
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 25, right: 25, top: 10),
            child: Row(
              children: [
                Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    border: Border.all(color: Colors.grey[400].withOpacity(0.3), width: 4),
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  child: Icon(
                    Icons.update,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
                SizedBox(width: 6,),
                Text((type3ScoreNull == null ? '0 ' : type3ScoreNull.toString() + ' ') + 'Next time', style: TextStyle(fontSize: 17),)
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> moveToLastScreen() async {
    return Navigator.pop(context);
  }

  Future<void> loadScoreFromDb() async {
    List<Map<String,dynamic>> res = await dbHelper.getVocabularyScores();

    for(int i = 0; i < res.length; i++) {
      Map<String,dynamic> current = res[i];
      if(current['type_id'] == 1) {
        int a =1;
        if (current['score'] == null) {
          type1ScoreNull = current['score_count'];
        } else if(current['score'] == 1) {
          type1Score1 = current['score_count'];
        } else if (current['score'] == 2) {
          type1Score2 = current['score_count'];
        } else if (current['score'] == 3) {
          type1Score3 = current['score_count'];
        }
      } else if(current['type_id'] == 2) {
        if (current['score'] == null) {
          type2ScoreNull = current['score_count'];
        } else if(current['score'] == 1) {
          type2Score1 = current['score_count'];
        } else if (current['score'] == 2) {
          type2Score2 = current['score_count'];
        } else if (current['score'] == 3) {
          type2Score3 = current['score_count'];
        }
      } else if(current['type_id'] == 3) {
        if (current['score'] == null) {
          type3ScoreNull = current['score_count'];
        } else if(current['score'] == 1) {
          type3Score1 = current['score_count'];
        } else if (current['score'] == 2) {
          type3Score2 = current['score_count'];
        } else if (current['score'] == 3) {
          type3Score3 = current['score_count'];
        }
      }

    }

    int stop = 1;
  }
}
