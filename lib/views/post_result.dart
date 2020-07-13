import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';
import 'package:trident/models/match_models.dart';
import 'package:trident/models/participant_models.dart';
import 'package:trident/services/database_services.dart';

class PostResult extends StatefulWidget {
  final String matchId;

  PostResult({Key key, @required this.matchId}) : super(key: key);
  @override
  _PostResultState createState() => _PostResultState(matchId);
}

class _PostResultState extends State<PostResult> {
  String matchId;
  _PostResultState(this.matchId);
  List<Map<String, String>> resultList = [];
  List<String> _kills, _moneyWon = [];
  List<TextEditingController> _killsControllerList =
      List.generate(101, (i) => TextEditingController());
  List<TextEditingController> _moneyControllerList =
      List.generate(101, (i) => TextEditingController());
  ProgressDialog pr;
  @override
  Widget build(BuildContext context) {
    double unitHeightValue = MediaQuery.of(context).size.height * 0.01;
    pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
    pr.style(
      message: "Please wait...",
      borderRadius: 5.0,
      padding: EdgeInsets.all(25),
      backgroundColor: Colors.white,
      progressWidget: CircularProgressIndicator(
        valueColor: new AlwaysStoppedAnimation<Color>(Colors.red.shade900),
      ),
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
      progressTextStyle: TextStyle(
          color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
      messageTextStyle: TextStyle(
          color: Colors.black, fontSize: 12.0, fontWeight: FontWeight.w600),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Post Result',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
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
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            StreamBuilder<Matches>(
                stream: DatabaseService().getMatchDetails(matchId),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: Card(
                              elevation: 10,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'Game : ' + snapshot.data.game ?? '',
                                        style: TextStyle(
                                            fontSize: unitHeightValue * 2),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'id : ' + snapshot.data.id ?? '',
                                        style: TextStyle(
                                            fontSize: unitHeightValue * 2),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'matchNo : ' + snapshot.data.matchNo ??
                                            '',
                                        style: TextStyle(
                                            fontSize: unitHeightValue * 2),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'status : ' + snapshot.data.status ??
                                            '',
                                        style: TextStyle(
                                            fontSize: unitHeightValue * 2.5,
                                            color: Colors.red.shade900),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('maxParticipants : ' +
                                              snapshot.data.maxParticipants
                                                  .toString() ??
                                          ''),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                          'name : ' + snapshot.data.name ?? ''),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('prizePool : ' +
                                              snapshot.data.prizePool ??
                                          ''),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('perKill : ' +
                                              snapshot.data.perKill
                                                  .toString() ??
                                          ''),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('ticket : ' +
                                              snapshot.data.ticket.toString() ??
                                          ''),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('time : ' +
                                              snapshot.data.time
                                                  .toDate()
                                                  .toLocal()
                                                  .toString() ??
                                          ''),
                                    ),
                                  ],
                                ),
                              )),
                        ));
                  } else {
                    return Center(child: Text('Loading Match data'));
                  }
                }),
            StreamBuilder<List<Participants>>(
                stream: DatabaseService().getParticipantList(matchId),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          child: ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: snapshot.data.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  width: MediaQuery.of(context).size.width,
                                  // decoration: BoxDecoration(
                                  //     border:
                                  //         Border.all(color: Colors.black)),
                                  child: Card(
                                    elevation: unitHeightValue * 5,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            'In-GameName : ' +
                                                    snapshot
                                                        .data[index].gameName ??
                                                '',
                                            style: TextStyle(
                                                fontSize: unitHeightValue * 2),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            'Name : ' +
                                                    snapshot.data[index].name ??
                                                '',
                                            style: TextStyle(
                                                fontSize: unitHeightValue * 2),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text('UserId : ' +
                                                  snapshot.data[index].uid ??
                                              ''),
                                        ),
                                        buildTextField(unitHeightValue, index),
                                        Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: RaisedButton(
                                            color: Colors.red,
                                            colorBrightness: Brightness.light,
                                            onPressed: () {
                                              resultList.add({
                                                'playerId': snapshot
                                                    .data[index].gameName,
                                                'kills':
                                                    _killsControllerList[index]
                                                            .text
                                                            .isNotEmpty
                                                        ? _killsControllerList[
                                                                index]
                                                            .text
                                                        : 0.toString(),
                                                'moneyWon':
                                                    _moneyControllerList[index]
                                                            .text
                                                            .isNotEmpty
                                                        ? _moneyControllerList[
                                                                index]
                                                            .text
                                                        : 0.toString()
                                              });
                                            },
                                            child: Text('Add to result'),
                                            textColor: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              })),
                    );
                  } else {
                    return Container(
                      child: Text('Loading participants list...'),
                    );
                  }
                }),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: RaisedButton(
                  color: Colors.red,
                  colorBrightness: Brightness.light,
                  onPressed: () {
                    if (resultList.isEmpty) {
                      Toast.show('Please add data correctly', context);
                    } else {
                      _showResultBottomSheet();
                    }
                  },
                  child: Text('Pubilsh result'),
                  textColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(
    unitHeightValue,
    index,
  ) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Kills',
                style: TextStyle(
                    fontSize: unitHeightValue * 2,
                    fontWeight: FontWeight.w400,
                    color: Colors.black87),
              ),
              SizedBox(
                height: 5,
              ),
              TextField(
                controller: _killsControllerList[index],
                inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                keyboardType: TextInputType.number,
                onSubmitted: (value) {
                  _kills[index] = value;
                },
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey[400])),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey[400])),
                ),
              ),
              SizedBox(
                height: 30,
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'MoneyEarned',
                style: TextStyle(
                    fontSize: unitHeightValue * 2,
                    fontWeight: FontWeight.w400,
                    color: Colors.black87),
              ),
              SizedBox(
                height: 5,
              ),
              TextField(
                controller: _moneyControllerList[index],
                inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                keyboardType: TextInputType.number,
                onSubmitted: (value) {
                  _moneyWon[index] = value;
                },
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey[400])),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey[400])),
                ),
              ),
              SizedBox(
                height: 30,
              ),
            ],
          ),
        ],
      ),
    );
  }

  _postResult() async {
    pr.show();
    CollectionReference resultCollection =
        Firestore.instance.collection('results');

    CollectionReference matchsCollection =
        Firestore.instance.collection('customMatchRooms');
    try {
      await Firestore.instance.runTransaction((transaction) async {
        return await transaction
            .set(resultCollection.document(matchId), {'results': resultList});
      });
      await matchsCollection
          .document(matchId)
          .setData({'result': true}, merge: true);
      pr.hide();
      Toast.show('Successful! result uploaded', context);
      Navigator.pop(context);
      Navigator.pop(context);
    } catch (e) {
      pr.hide();
      Toast.show(e.toString(), context);
    }
  }

  void _showResultBottomSheet() {
    showDialog(
        context: context,
        builder: (BuildContext bc) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('GameId'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('kills'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Winnings'),
                        )
                      ],
                    ),
                    Divider(
                      color: Colors.red.shade900,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          height: 1000,
                          width: 100,
                          child: ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: resultList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Text(
                                    resultList[index]['playerId'] ?? '');
                              }),
                        ),
                        Container(
                            height: 1000,
                            child: VerticalDivider(color: Colors.red)),
                        Container(
                          height: 1000,
                          width: 50,
                          child: ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: resultList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Text(resultList[index]['kills'] ?? '');
                              }),
                        ),
                        Container(
                            height: 1000,
                            child: VerticalDivider(color: Colors.red)),
                        Container(
                          height: 1000,
                          width: 50,
                          child: ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: resultList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Text(
                                    '\u20B9' + resultList[index]['moneyWon'] ??
                                        '');
                              }),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                          'Please make sure all the data is correct and their are no duplicates before submitting.'),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: RaisedButton(
                        color: Colors.red.shade900,
                        colorBrightness: Brightness.light,
                        onPressed: () {
                          resultList.clear();
                          Navigator.pop(context);
                        },
                        child: Text('Reset'),
                        textColor: Colors.white,
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: RaisedButton(
                        color: Colors.green,
                        colorBrightness: Brightness.light,
                        onPressed: () {
                          if (resultList.isEmpty) {
                            Toast.show('Please add data correctly', context);
                          } else {
                            _postResult();
                          }
                        },
                        child: Text('Pubilsh result'),
                        textColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
