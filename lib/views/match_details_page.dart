import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:share/share.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';
import 'package:trident/models/match_models.dart';
import 'package:trident/models/participant_models.dart';
import 'package:trident/services/auth_service.dart';
import 'package:trident/services/database_services.dart';
import 'package:trident/views/buy_coin.dart';
import 'package:trident/views/group_result_view.dart';
import 'package:trident/views/join_group_page.dart';

class MatchesDetailsPage extends StatefulWidget {
  final String matchId;
  final match;

  MatchesDetailsPage({Key key, this.matchId, this.match}) : super(key: key);
  @override
  _MatchesDetailsPageState createState() => _MatchesDetailsPageState(matchId);
}

class _MatchesDetailsPageState extends State<MatchesDetailsPage> {
  String matchId;
  _MatchesDetailsPageState(this.matchId);

  ProgressDialog pr;
  bool showParticipants = false;

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
            return Scaffold(
              body: Center(
                child: Text('Loading...'),
              ),
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
                                  child: StreamBuilder<List<Participants>>(
                                      stream: DatabaseService()
                                          .getParticipantList(matchId),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          return Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(snapshot.data.length
                                                .toString()),
                                          );
                                        } else {
                                          return Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text('0'),
                                          );
                                        }
                                      }),
                                )
                              ]),
                              TableRow(children: [
                                TableCell(
                                  verticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("Max participats"),
                                  ),
                                ),
                                TableCell(
                                  verticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(snapshot.data.maxParticipants
                                            .toString() ??
                                        0),
                                  ),
                                )
                              ]),
                              TableRow(children: [
                                TableCell(
                                  verticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("Starts on"),
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
                                    child: Text("Entry gems"),
                                  ),
                                ),
                                TableCell(
                                  verticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Text(snapshot.data.ticket.toString()),
                                        Container(
                                            width: unitWidthValue * 3,
                                            height: unitHeightValue * 3,
                                            child:
                                                Image.asset('assets/gems.png')),
                                      ],
                                    ),
                                  ),
                                )
                              ]),
                              TableRow(children: [
                                TableCell(
                                  verticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("status"),
                                  ),
                                ),
                                TableCell(
                                  verticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(snapshot.data.status),
                                  ),
                                )
                              ]),
                              TableRow(children: [
                                TableCell(
                                  verticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("Description"),
                                  ),
                                ),
                                TableCell(
                                  verticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child:
                                        Text(snapshot.data.description ?? ''),
                                  ),
                                )
                              ]),
                            ]),
                        Divider(
                          color: Colors.red.shade900,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FutureBuilder<int>(
                              future: DatabaseService()
                                  .getParticipantsListLength(matchId),
                              builder: (context, snap) {
                                return Column(
                                  children: <Widget>[
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      child: RaisedButton(
                                        color: Colors.green,
                                        colorBrightness: Brightness.light,
                                        onPressed: () async {
                                          if (snapshot.data.noOfGroups > 0) {
                                            if (snapshot.data.status
                                                    .toLowerCase() ==
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
                                                if (snap.hasData) {
                                                  if (snap.data <
                                                      snapshot.data
                                                          .maxParticipants) {
                                                    _getGemsToPlay(
                                                        snapshot.data.ticket,
                                                        matchId,
                                                        snapshot.data.game,
                                                        snapshot.data.name,
                                                        snapshot.data.imageUrl,
                                                        snapshot.data.matchNo,
                                                        snapshot.data.prizePool,
                                                        _gameTime(snapshot
                                                            .data.time
                                                            .toDate()),
                                                        snapshot
                                                            .data.noOfGroups);
                                                  } else {
                                                    pr.hide();
                                                    Toast.show(
                                                        'Match full', context);
                                                  }
                                                } else {
                                                  pr.hide();
                                                  Toast.show(
                                                      'OPPS! something happned',
                                                      context);
                                                }
                                              }
                                            } else {
                                              Navigator.of(context,
                                                      rootNavigator: true)
                                                  .push(MaterialPageRoute(
                                                      builder: (context) =>
                                                          GroupResults(
                                                            matchId: matchId,
                                                            noOfgroups: snapshot
                                                                .data
                                                                .noOfGroups,
                                                          )));
                                            }
                                          } else {
                                            Toast.show(
                                                'OPPS! something happned',
                                                context);
                                          }
                                        },
                                        child: (snapshot.data.status
                                                    .toLowerCase() ==
                                                'upcoming')
                                            ? Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text('Pay '),
                                                  Text(snapshot.data.ticket
                                                      .toString()),
                                                  Container(
                                                      width: unitWidthValue * 3,
                                                      height:
                                                          unitHeightValue * 3,
                                                      child: Image.asset(
                                                          'assets/gems.png')),
                                                ],
                                              )
                                            : Text('Fixtures'),
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
                                              _gameTime(
                                                  snapshot.data.time.toDate()),
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
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    child: RaisedButton(
                                                      color: Colors.black,
                                                      colorBrightness:
                                                          Brightness.light,
                                                      onPressed: () {
                                                        _showRoomdetailDialog(
                                                            snapshot.data
                                                                    .roomId ??
                                                                'NA',
                                                            snapshot.data
                                                                    .roomPassword ??
                                                                'NA');
                                                      },
                                                      child:
                                                          Text('Room details'),
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
                                );
                              }),
                        ),
                        Divider(
                          color: Colors.red.shade900,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            child: RaisedButton(
                              color: Colors.black,
                              colorBrightness: Brightness.light,
                              onPressed: () {
                                setState(() {
                                  if (showParticipants) {
                                    showParticipants = false;
                                  } else {
                                    showParticipants = true;
                                  }
                                });
                              },
                              child: Text('Participants'),
                              textColor: Colors.white,
                            ),
                          ),
                        ),
                        _showParticipantsList(
                            showParticipants, unitHeightValue * 2.5)
                      ],
                    ),
                  )),
            );
          }
        });
  }

  _gameTime(time) {
    return DateFormat.yMMMd().add_jm().format(time);
  }

  _showParticipantsList(show, textSize) {
    if (show) {
      return Column(
        children: [
          Text(
            'Participants',
            style: TextStyle(fontSize: textSize, color: Colors.red.shade900),
          ),
          Divider(
            color: Colors.red.shade900,
          ),
          StreamBuilder<List<Participants>>(
              stream: DatabaseService().getParticipantList(matchId),
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
      );
    } else {
      return Container();
    }
  }

  void _showRoomdetailDialog(roomId, roomPassword) {
    double unitHeightValue = MediaQuery.of(context).size.height * 0.01;
    double unitWidthValue = MediaQuery.of(context).size.width * 0.01;
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
                        FutureBuilder<int>(
                            future: DatabaseService().getGroupId(matchId),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return StreamBuilder<RoomDetailsModel>(
                                    stream: DatabaseService().getRoomDetails(
                                        matchId, snapshot.data.toString()),
                                    builder: (context, snap) {
                                      if (snap.hasData) {
                                        return Container(
                                          child: Column(
                                            children: <Widget>[
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Table(
                                                  defaultColumnWidth:
                                                      FixedColumnWidth(
                                                          unitWidthValue * 33),
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
                                                                const EdgeInsets
                                                                    .all(2.0),
                                                            child: SizedBox(
                                                              height:
                                                                  unitHeightValue *
                                                                      2.5,
                                                              child: Center(
                                                                  child: Text(
                                                                      'Group')),
                                                            ),
                                                          ))),
                                                      TableCell(
                                                          verticalAlignment:
                                                              TableCellVerticalAlignment
                                                                  .fill,
                                                          child: Center(
                                                              child: Text(snapshot
                                                                  .data
                                                                  .toString())))
                                                    ]),
                                                    TableRow(children: [
                                                      TableCell(
                                                          verticalAlignment:
                                                              TableCellVerticalAlignment
                                                                  .middle,
                                                          child: Center(
                                                              child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(2.0),
                                                            child: SizedBox(
                                                              height:
                                                                  unitHeightValue *
                                                                      2.5,
                                                              child: Center(
                                                                  child: Text(
                                                                      'Time')),
                                                            ),
                                                          ))),
                                                      TableCell(
                                                          verticalAlignment:
                                                              TableCellVerticalAlignment
                                                                  .fill,
                                                          child: Center(
                                                              child: Text(
                                                                  _gameTime(snap
                                                                      .data.time
                                                                      .toDate()))))
                                                    ]),
                                                    TableRow(children: [
                                                      TableCell(
                                                          verticalAlignment:
                                                              TableCellVerticalAlignment
                                                                  .middle,
                                                          child: Center(
                                                              child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(2.0),
                                                            child: SizedBox(
                                                              height:
                                                                  unitHeightValue *
                                                                      2.5,
                                                              child: Center(
                                                                  child: Text(
                                                                      'Room id')),
                                                            ),
                                                          ))),
                                                      TableCell(
                                                          verticalAlignment:
                                                              TableCellVerticalAlignment
                                                                  .fill,
                                                          child: Center(
                                                            child: SelectableText(
                                                                snap.data
                                                                        .roomId ??
                                                                    'NA'),
                                                          ))
                                                    ]),
                                                    TableRow(children: [
                                                      TableCell(
                                                          verticalAlignment:
                                                              TableCellVerticalAlignment
                                                                  .middle,
                                                          child: Center(
                                                              child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(2.0),
                                                            child: SizedBox(
                                                              height:
                                                                  unitHeightValue *
                                                                      2.5,
                                                              child: Center(
                                                                  child: Text(
                                                                      'Room password')),
                                                            ),
                                                          ))),
                                                      TableCell(
                                                          verticalAlignment:
                                                              TableCellVerticalAlignment
                                                                  .fill,
                                                          child: Center(
                                                              child: SelectableText(snap
                                                                      .data
                                                                      .roomPassword ??
                                                                  'NA')))
                                                    ]),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      } else {
                                        return CircularProgressIndicator();
                                      }
                                    });
                              } else {
                                return CircularProgressIndicator();
                              }
                            }),
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
    Share.share(game +
        ' Tournament on ' +
        time +
        ' with ' +
        '\u20B9' +
        prize +
        //TODO: Change link
        ' Prize pool exclusively on | Trident Gaming | download link: ' +
        'https://www.iceagedev.com/download');
  }

  _addUserAsParticipants(matchId, game, name, imageUrl, matchNo, prizePool,
      time, noOfGroups) async {
    pr.show();
    try {
      await DatabaseService().getUserData(game).then((value) async {
        await DatabaseService().addMatchParticipants(
            matchId, value.gameName, value.name, game, matchNo);
      });
      await DatabaseService().addToSubscribedGames(
        matchId,
        game,
        name,
        imageUrl,
        matchNo,
        prizePool,
        time,
      );
      pr.hide();
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => JoinGroupPage(
                    matchId: matchId,
                    noOfGroups: noOfGroups,
                    game: game,
                  )));
    } catch (e) {
      Toast.show(e.toString(), context);
      print(e.toString());
      pr.hide();
    }
  }

  Future _getGemsToPlay(gemsRequired, matchId, game, name, imageUrl, matchNo,
      prizePool, time, noOfGroups) async {
    String userId = await AuthService().uID();
    CollectionReference usersCollection =
        Firestore.instance.collection('users');
    int gems = await usersCollection.document(userId).get().then((value) {
      return value.data['gems'] ?? 0;
    });
    if (gems < gemsRequired) {
      pr.hide();
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => BuyCoinPage()));
      Toast.show('You dont have enough gems !', context);
    } else {
      pr.hide();
      gems -= gemsRequired;
      await Firestore.instance.runTransaction((transaction) async {
        return await transaction
            .update(usersCollection.document(userId), {'gems': gems});
      });
      _addUserAsParticipants(
          matchId, game, name, imageUrl, matchNo, prizePool, time, noOfGroups);
    }
  }
}
