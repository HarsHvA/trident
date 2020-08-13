import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';
import 'package:trident/models/match_models.dart';
import 'package:trident/services/database_services.dart';

class JoinGroupPage extends StatefulWidget {
  final String matchId;
  final int noOfGroups;
  final String game;

  JoinGroupPage(
      {Key key,
      @required this.matchId,
      @required this.noOfGroups,
      @required this.game})
      : super(key: key);
  @override
  _JoinGroupPageState createState() =>
      _JoinGroupPageState(matchId, noOfGroups, game);
}

class _JoinGroupPageState extends State<JoinGroupPage> {
  int numberOfGroups;
  String matchId;
  String game;
  _JoinGroupPageState(this.matchId, this.numberOfGroups, this.game);

  ProgressDialog pr;
  @override
  Widget build(BuildContext context) {
    double unitHeightValue = MediaQuery.of(context).size.height * 0.01;
    double unitWidthValue = MediaQuery.of(context).size.width * 0.01;
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
          'Join match group',
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
            itemCount: numberOfGroups,
            itemBuilder: (context, index) {
              return StreamBuilder<RoomDetailsModel>(
                  stream: DatabaseService()
                      .getRoomDetails(matchId, index.toString()),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Card(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Table(
                                      defaultColumnWidth:
                                          FixedColumnWidth(unitWidthValue * 33),
                                      border: TableBorder.all(
                                          color: Colors.black26,
                                          width: 1,
                                          style: BorderStyle.solid),
                                      children: [
                                        TableRow(children: [
                                          TableCell(
                                              verticalAlignment:
                                                  TableCellVerticalAlignment
                                                      .middle,
                                              child: Center(
                                                  child: Padding(
                                                padding:
                                                    const EdgeInsets.all(2.0),
                                                child: SizedBox(
                                                  height: unitHeightValue * 2.5,
                                                  child: Center(
                                                      child: Text('Group')),
                                                ),
                                              ))),
                                          TableCell(
                                              verticalAlignment:
                                                  TableCellVerticalAlignment
                                                      .fill,
                                              child: Center(
                                                  child:
                                                      Text(index.toString())))
                                        ]),
                                        TableRow(children: [
                                          TableCell(
                                              verticalAlignment:
                                                  TableCellVerticalAlignment
                                                      .middle,
                                              child: Center(
                                                  child: Padding(
                                                padding:
                                                    const EdgeInsets.all(2.0),
                                                child: SizedBox(
                                                  height: unitHeightValue * 2.5,
                                                  child: Center(
                                                      child: Text('Time')),
                                                ),
                                              ))),
                                          TableCell(
                                              verticalAlignment:
                                                  TableCellVerticalAlignment
                                                      .fill,
                                              child: Center(
                                                  child: Text(_gameTime(snapshot
                                                      .data.time
                                                      .toDate()))))
                                        ]),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  alignment: Alignment.bottomRight,
                                  width: unitWidthValue * 20,
                                  child: RaisedButton(
                                    color: Colors.green,
                                    child: Text(
                                      'Join',
                                      style: TextStyle(
                                          fontSize: unitHeightValue * 2),
                                    ),
                                    onPressed: () async {
                                      pr.show();
                                      int length = await _getGroupavailability(
                                          index.toString());
                                      if (length < 100) {
                                        try {
                                          await DatabaseService()
                                              .generateUserMatchToken(
                                                  matchId, index);
                                          await DatabaseService()
                                              .getUserData(game)
                                              .then((value) async {
                                            await DatabaseService()
                                                .addToParticipantsGroup(
                                                    matchId,
                                                    value.gameName,
                                                    value.name,
                                                    game,
                                                    index.toString());
                                          });
                                          Toast.show('successful', context);
                                          pr.hide();
                                          Navigator.of(context).pop();
                                        } catch (e) {
                                          pr.hide();
                                          Toast.show(e.toString(), context,
                                              duration: Toast.LENGTH_LONG);
                                        }
                                      } else {
                                        pr.hide();
                                        Toast.show('Group full choose another',
                                            context);
                                      }
                                    },
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    } else {
                      return CircularProgressIndicator();
                    }
                  });
            }),
      ),
    );
  }

  _gameTime(time) {
    return DateFormat.yMMMd().add_jm().format(time);
  }

  _getGroupavailability(groupId) async {
    try {
      return await DatabaseService().getGroupLength(matchId, groupId);
    } catch (e) {
      Toast.show(e.toString(), context);
      print(e);
      return 0;
    }
  }
}
