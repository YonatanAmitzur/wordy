import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wordy/common/app_enums.dart';
import 'package:wordy/pages/practice_page.dart';
import 'package:wordy/pages/profile_page.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  @override
  void initState() {
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome'),
        actions: <Widget>[
          PopupMenuButton(
            offset: Offset(0, 3),
            onSelected: (choice) => { _navToSelectedMenuItem(choice) },
            itemBuilder: (BuildContext context) {
              List<String> menuItems = ['Score Table'];
              return menuItems.map((String choice) {
                return PopupMenuItem(value: choice, child: Text(choice));
              }).toList();
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          GestureDetector(
            onTap: () {
              _navToPracticePage(PracticeType.WORDS);
            },
            child: Container(
              margin: EdgeInsets.only(left: 25, right: 25, top: 25, bottom: 15),
              height: 100,
              decoration: BoxDecoration(
                color: Colors.blueAccent.withOpacity(0.4),
                border: Border.all(color: Colors.blueAccent.withOpacity(0.3), width: 4),
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              child: Center(
                child: Text('Words', style: TextStyle(fontSize: 30, color: Colors.white),),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              _navToPracticePage(PracticeType.PHRASES);
            },
            child: Container(
              margin: EdgeInsets.only(left: 25, right: 25),
              height: 100,
              decoration: BoxDecoration(
                color: Colors.blueAccent.withOpacity(0.4),
                border: Border.all(color: Colors.blueAccent.withOpacity(0.3), width: 4),
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              child: Center(
                child: Text('Phrases', style: TextStyle(fontSize: 30, color: Colors.white),),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              _navToPracticePage(PracticeType.CONVERSATIONS);
            },
            child: Container(
              margin: EdgeInsets.only(left: 25, right: 25, top: 15, bottom: 15),
              height: 100,
              decoration: BoxDecoration(
                color: Colors.blueAccent.withOpacity(0.4),
                border: Border.all(color: Colors.blueAccent.withOpacity(0.3), width: 4),
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              child: Center(
                child: Text('Conversations', style: TextStyle(fontSize: 30, color: Colors.white),),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _navToPracticePage(PracticeType practiceType) async {
    var result = await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return PracticePage(practiceType: practiceType);
    }));

    if (result != null) {}
  }

  _navToSelectedMenuItem(String choice) {
    if(choice == 'Score Table') {
      _navToProfilePage();
    }
  }

  Future<void> _navToProfilePage() async {
    var result = await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ProfilePage();
    }));

    if (result != null) {}
  }
}
