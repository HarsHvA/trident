import 'package:auto_size_text/auto_size_text.dart';
import 'package:share/share.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';
import 'package:trident/models/match_models.dart';
import 'package:trident/models/participant_models.dart';
import 'package:trident/services/database_services.dart';
import 'package:trident/views/result_page.dart';

class MatchesDetailsPage extends StatefulWidget {
  final String matchId;
  final match;

  MatchesDetailsPage({Key key, this.matchId, this.match}) : super(key: key);
  @override
  _MatchesDetailsPageState createState() => _MatchesDetailsPageState(matchId);
}

class _MatchesDetailsPageState extends State<MatchesDetailsPage> {
  String matchId;
  ProgressDialog pr;
  _MatchesDetailsPageState(this.matchId);
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
    return StreamBuilder<Matches>(
        stream: DatabaseService().getMatchDetails(matchId),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(
              child: Text('Loading...'),
            );
          else {
            return SafeArea(
              child: Scaffold(
                  appBar: PreferredSize(
                      preferredSize: Size.fromHeight(60),
                      child: Stack(children: <Widget>[
                        AppBar(
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
                          title: Text(snapshot.data.game),
                        ),
                      ])),
                  body: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              snapshot.data.name +
                                  "- Match-#" +
                                  snapshot.data.matchNo,
                              style: TextStyle(fontSize: unitHeightValue * 2.5),
                            ),
                          ),
                        ),
                        Divider(
                          color: Colors.red.shade900,
                        ),
                        Table(
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
                                      TableCellVerticalAlignment.middle,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("Total players"),
                                  ),
                                ),
                                TableCell(
                                  verticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(snapshot.data.maxParticipants
                                        .toString()),
                                  ),
                                )
                              ]),
                              TableRow(children: [
                                TableCell(
                                  verticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("Time"),
                                  ),
                                ),
                                TableCell(
                                  verticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                        _gameTime(snapshot.data.time.toDate())),
                                  ),
                                )
                              ]),
                              TableRow(children: [
                                TableCell(
                                  verticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("Map"),
                                  ),
                                ),
                                TableCell(
                                  verticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(snapshot.data.map),
                                  ),
                                )
                              ]),
                              TableRow(children: [
                                TableCell(
                                  verticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("PrizePool"),
                                  ),
                                ),
                                TableCell(
                                  verticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(snapshot.data.prizePool),
                                  ),
                                )
                              ]),
                              TableRow(children: [
                                TableCell(
                                  verticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("Per Kill"),
                                  ),
                                ),
                                TableCell(
                                  verticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("\u20B9 " +
                                        snapshot.data.perKill.toString()),
                                  ),
                                )
                              ]),
                              TableRow(children: [
                                TableCell(
                                  verticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("Entry Fees"),
                                  ),
                                ),
                                TableCell(
                                  verticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("\u20B9 " +
                                        snapshot.data.ticket.toString()),
                                  ),
                                )
                              ]),
                            ]),
                        Divider(
                          color: Colors.red.shade900,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: <Widget>[
                              Container(
                                width: MediaQuery.of(context).size.width,
                                child: RaisedButton(
                                  color: Colors.green,
                                  colorBrightness: Brightness.light,
                                  onPressed: () async {
                                    if (snapshot.data.status.toLowerCase() ==
                                        'upcoming') {
                                      pr.show();
                                      bool joined = false;
                                      try {
                                        joined = await DatabaseService()
                                            .checkMatchJoined(matchId);
                                      } catch (e) {
                                        print(e);
                                      }
                                      if (joined) {
                                        pr.hide();
                                        Toast.show(
                                            'You have already joined the match',
                                            context);
                                      } else {
                                        _addUserAsParticipants(
                                            matchId,
                                            snapshot.data.game,
                                            snapshot.data.name,
                                            snapshot.data.ticket,
                                            snapshot.data.status,
                                            snapshot.data.imageUrl,
                                            snapshot.data.map,
                                            snapshot.data.matchNo,
                                            snapshot.data.maxParticipants,
                                            snapshot.data.perKill,
                                            snapshot.data.prizePool,
                                            snapshot.data.time,
                                            snapshot.data.roomId,
                                            snapshot.data.roomPassword);
                                      }
                                    } else {
                                      Navigator.of(context, rootNavigator: true)
                                          .push(MaterialPageRoute(
                                              builder: (context) => ResultPage(
                                                  matchId: matchId)));
                                    }
                                  },
                                  child: Text(_getButtonText(
                                      snapshot.data.status,
                                      snapshot.data.ticket)),
                                  textColor: Colors.white,
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                child: RaisedButton(
                                  color: Colors.red,
                                  colorBrightness: Brightness.light,
                                  onPressed: () {
                                    _shareMatchDetails(
                                        snapshot.data.game,
                                        _gameTime(snapshot.data.time.toDate()),
                                        snapshot.data.prizePool);
                                  },
                                  child: Text('Share match details'),
                                  textColor: Colors.white,
                                ),
                              ),
                              FutureBuilder<bool>(
                                  future: DatabaseService()
                                      .checkMatchJoined(matchId),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<bool> snap) {
                                    switch (snap.connectionState) {
                                      case ConnectionState.waiting:
                                        return Container();

                                      default:
                                        if (snap.hasError) {
                                          return Container();
                                        } else {
                                          if (snap.data) {
                                            return Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: RaisedButton(
                                                color: Colors.black,
                                                colorBrightness:
                                                    Brightness.light,
                                                onPressed: () {
                                                  _showRoomdetailDialog(
                                                      snapshot.data.roomId ??
                                                          'NA',
                                                      snapshot.data
                                                              .roomPassword ??
                                                          'NA');
                                                },
                                                child: Text('Room details'),
                                                textColor: Colors.white,
                                              ),
                                            );
                                          } else {
                                            return Container();
                                          }
                                        }
                                    }
                                  }),
                            ],
                          ),
                        ),
                        Divider(
                          color: Colors.red.shade900,
                        ),
                        Text(
                          'Participants',
                          style: TextStyle(
                              fontSize: unitHeightValue * 2.5,
                              color: Colors.red.shade900),
                        ),
                        Divider(
                          color: Colors.red.shade900,
                        ),
                        StreamBuilder<List<Participants>>(
                            stream:
                                DatabaseService().getParticipantList(matchId),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return SingleChildScrollView(
                                  physics: const NeverScrollableScrollPhysics(),
                                  child: DataTable(
                                      columns: [
                                        DataColumn(
                                            label: Text(
                                          'Game-Id',
                                          style: TextStyle(color: Colors.red),
                                        ))
                                      ],
                                      rows: snapshot.data
                                          .map((e) => DataRow(cells: <DataCell>[
                                                DataCell(Text(e.gameName)),
                                              ]))
                                          .toList()),
                                );
                              } else {
                                return Container(
                                  child: Text('No Participants'),
                                );
                              }
                            }),
                      ],
                    ),
                  )),
            );
          }
        });
  }

  _payment(ticket) async {}

  _gameTime(time) {
    return DateFormat.yMMMd().add_jm().format(time);
  }

  void _showRoomdetailDialog(roomId, roomPassword) {
    showModalBottomSheet(
      enableDrag: false,
      context: context,
      builder: (context) {
        return Wrap(
          children: <Widget>[
            Container(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(8),
                          child: Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.info_outline,
                                  color: Colors.red.shade900,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  'Id and password are made available 10 minutes before the match',
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SelectableText('RoomId : ' + roomId),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SelectableText(
                                    'Password : ' + roomPassword),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  _shareMatchDetails(game, time, prize) {
    // TODO: Add your game installation link here
    Share.share(game +
        ' Tournament on ' +
        time +
        ' with ' +
        '\u20B9' +
        prize +
        ' Prize pool exclusively on | Trident Gaming | download link: ');
  }

  _addUserAsParticipants(
      matchId,
      game,
      name,
      ticket,
      status,
      imageUrl,
      map,
      matchNo,
      maxParticipants,
      perKill,
      prizePool,
      time,
      roomId,
      roomPassword) async {
    try {
      await DatabaseService().getUserData(game).then((value) async {
        await DatabaseService().addMatchParticipants(
            matchId, value.gameName, value.name, game, matchNo);
      });
      await DatabaseService().addToSubscribedGames(
          matchId,
          game,
          name,
          ticket,
          status,
          imageUrl,
          map,
          matchNo,
          maxParticipants,
          perKill,
          prizePool,
          time,
          roomId,
          roomPassword);
      await DatabaseService().generateUserMatchToken(matchId);
      Toast.show('Match Joined', context);
      pr.hide();
    } catch (e) {
      Toast.show(e.toString(), context);
      print(e.toString());
      pr.hide();
    }
  }

  _getButtonText(String status, int ticket) {
    if (status.toLowerCase() == 'upcoming') {
      return 'Pay ' + "\u20B9" + ticket.toString();
    } else {
      return 'Go to Fixtures';
    }
  }
}
