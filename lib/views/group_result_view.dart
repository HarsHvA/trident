import 'package:flutter/material.dart';
import 'package:trident/views/result_page.dart';

class GroupResults extends StatefulWidget {
  final String matchId;
  final int noOfgroups;
  GroupResults({Key key, @required this.matchId, @required this.noOfgroups})
      : super(key: key);
  @override
  _GroupResultsState createState() => _GroupResultsState(matchId, noOfgroups);
}

class _GroupResultsState extends State<GroupResults> {
  String matchId;
  int noOfGroups;
  _GroupResultsState(this.matchId, this.noOfGroups);
  @override
  Widget build(BuildContext context) {
    double unitHeightValue = MediaQuery.of(context).size.height * 0.01;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Results',
          style: TextStyle(color: Colors.white),
        ),
        elevation: 0,
        brightness: Brightness.light,
        backgroundColor: Colors.red.shade900,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            size: unitHeightValue * 2,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
            itemCount: noOfGroups,
            itemBuilder: (context, index) {
              return Container(
                padding: EdgeInsets.all(8),
                width: MediaQuery.of(context).size.width,
                child: RaisedButton(
                  color: Colors.red.shade900,
                  colorBrightness: Brightness.light,
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true)
                        .push(MaterialPageRoute(
                            builder: (context) => ResultPage(
                                  matchId: matchId,
                                  groupNo: index,
                                )));
                  },
                  child: Text('Group $index'),
                  textColor: Colors.white,
                ),
              );
            }),
      ),
    );
  }
}
