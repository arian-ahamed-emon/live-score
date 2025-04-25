import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:live_score/screens/cricket_score.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  List<CricketScore> _cricketScoreList = [];
  bool _inProgress = false;

  Future<void> _getScoreData() async {
    _inProgress = true;
    setState(() {});
    _cricketScoreList.clear();
    final QuerySnapshot snapshot =
        await _firebaseFirestore.collection('cricket').get();
    for (DocumentSnapshot doc in snapshot.docs) {
      _cricketScoreList.add(
        CricketScore.fromJson(doc.id,doc.data() as Map<String, dynamic>),
      );
    }
    _inProgress = false;
    setState(() {});
  }
@override
  void initState() {
    super.initState();
    _getScoreData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Live Score'), centerTitle: true),
      body: Visibility(
          visible: _inProgress == false,
          replacement: Center(child: CircularProgressIndicator()),
          child: ListView.builder(
            itemBuilder: (context, index) {
              CricketScore cricketScore = _cricketScoreList[index];
              return Column(
                children: [
                  SizedBox(height: 10,),
                  Image.asset('assets/images/banner.jpg'),
                  SizedBox(height: 10,),
                  ListTile(
                  leading: Badge(backgroundColor: _indiecatorColor(cricketScore.isMatchRunning)),
                  title: Text('MatchId:${cricketScore.matchId}'),
                  subtitle: Text('Team 1 :${cricketScore.teamOneName}\nTeam 2:${cricketScore.teamTwoName}'),
                  trailing: Text('${cricketScore.teamOneScore}/${cricketScore.teamTwoScore}'),
                ),
              ]
              );
            },
            itemCount: _cricketScoreList.length,
          ),
        ),

    );
  }

  Color _indiecatorColor(bool isMatchRunning) {
    return isMatchRunning ? Colors.green : Colors.grey;
  }
}
