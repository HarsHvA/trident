import 'package:share/share.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';
import 'package:trident/models/match_models.dart';
import 'package:trident/models/participant_models.dart';
import 'package:trident/services/database_services.dart';

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
          else
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
                                  onPressed: () {
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
                                        snapshot.data.time);
                                  },
                                  child: Text('Pay ' +
                                      "\u20B9" +
                                      snapshot.data.ticket.toString()),
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
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                      child: ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount: snapshot.data.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return Container(
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Colors.black)),
                                                child: Center(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                      snapshot.data[index]
                                                              .gameName ??
                                                          '',
                                                      style: TextStyle(
                                                          fontSize:
                                                              unitHeightValue *
                                                                  2),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          })),
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
        });
  }

  _payment(ticket) {
    Toast.show(ticket.toString(), context);
  }

  _gameTime(time) {
    return DateFormat.yMMMd().add_jm().format(time);
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

  _addUserAsParticipants(matchId, game, name, ticket, status, imageUrl, map,
      matchNo, maxParticipants, perKill, prizePool, time) async {
    pr.show();
    try {
      await DatabaseService().getUserData(game).then((value) async {
        await DatabaseService()
            .addMatchParticipants(matchId, value.gameName, value.name);
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
      );
      Toast.show('Match Joined', context);
      pr.hide();
    } catch (e) {
      Toast.show(e.toString(), context);
      print(e.toString());
      pr.hide();
    }
  }
}
