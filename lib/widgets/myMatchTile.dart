import 'package:flutter/material.dart';
import 'package:trident/models/match_models.dart';
import 'package:toast/toast.dart';
import 'package:trident/services/database_services.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:trident/views/match_details_page.dart';

// ignore: must_be_immutable
class MyMatchTile extends StatelessWidget {
  final MyMatches matches;
  MyMatchTile({this.matches});

  String _gameName;
  TextEditingController gameNameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double unitHeightValue = MediaQuery.of(context).size.height * 0.01;
    double unitWidthValue = MediaQuery.of(context).size.width * 0.01;

    return Container(
      child: Center(
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: BorderSide(
              color: Colors.black,
              width: 1.0,
            ),
          ),
          child: Wrap(
            children: <Widget>[
              Card(
                semanticContainer: true,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: Wrap(
                  children: <Widget>[
                    Stack(children: <Widget>[
                      ColorFiltered(
                        colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(0.5), BlendMode.srcOver),
                        child: Image.asset(
                          matches.imageUrl,
                          fit: BoxFit.fill,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                AutoSizeText(
                                  matches.name + " - Match-#" + matches.matchNo,
                                  softWrap: true,
                                  style: TextStyle(
                                      fontSize: unitHeightValue * 2.5,
                                      color: Colors.white),
                                ),
                                AutoSizeText(matches.game,
                                    style: TextStyle(
                                        fontSize: unitHeightValue * 2,
                                        color: Colors.white)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ])
                  ],
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 5,
                margin: EdgeInsets.all(10),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Table(
                      defaultColumnWidth: FixedColumnWidth(unitWidthValue * 33),
                      border: TableBorder.all(
                          color: Colors.black26,
                          width: 1,
                          style: BorderStyle.solid),
                      children: [
                        TableRow(children: [
                          TableCell(
                              child: Center(child: Icon(Icons.access_time))),
                          TableCell(
                              verticalAlignment:
                                  TableCellVerticalAlignment.fill,
                              child: Center(
                                  child: AutoSizeText(
                                matches.time,
                                style:
                                    TextStyle(fontSize: unitHeightValue * 1.5),
                              )))
                        ]),
                        TableRow(children: [
                          TableCell(
                              verticalAlignment:
                                  TableCellVerticalAlignment.middle,
                              child: Center(
                                  child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: SizedBox(
                                  height: unitHeightValue * 2.5,
                                  child:
                                      Center(child: AutoSizeText('Prize pool')),
                                ),
                              ))),
                          TableCell(
                              verticalAlignment:
                                  TableCellVerticalAlignment.fill,
                              child: Center(
                                  child: AutoSizeText(
                                      "\u20B9" + matches.prizePool,
                                      style: TextStyle(
                                          fontSize: unitHeightValue * 1.5))))
                        ]),
                      ],
                    ),
                    Container(
                      alignment: Alignment.bottomRight,
                      width: unitWidthValue * 20,
                      child: RaisedButton(
                        color: Colors.green,
                        child: Text(
                          'View',
                          style: TextStyle(fontSize: unitHeightValue * 2),
                        ),
                        onPressed: () {
                          _getUserGameName(context);
                        },
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showbottomsheet(context) {
    showModalBottomSheet(
        context: context,
        enableDrag: false,
        builder: (BuildContext bc) {
          return Container(
            child: Wrap(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Enter your game Id",
                          style: TextStyle(
                              fontSize: (MediaQuery.of(context).size.height *
                                  0.01 *
                                  4)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: gameNameController,
                          onSubmitted: (newValue) {
                            newValue = _gameName;
                          },
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 0, horizontal: 10),
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey[400])),
                            border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey[400])),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          padding: EdgeInsets.only(top: 3, left: 3),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              border: Border(
                                bottom: BorderSide(color: Colors.black),
                                top: BorderSide(color: Colors.black),
                                left: BorderSide(color: Colors.black),
                                right: BorderSide(color: Colors.black),
                              )),
                          child: MaterialButton(
                            minWidth: double.infinity,
                            height: 60,
                            onPressed: () {
                              _gameId(context);
                            },
                            color: Colors.red,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)),
                            child: Text(
                              "Submit",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 18),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  String getGameId(context) {
    _gameName = gameNameController.text;

    if (_gameName.isNotEmpty) {
      return _gameName;
    } else {
      Toast.show('Please enter a valid name', context);
      return null;
    }
  }

  void _gameId(context) async {
    if (getGameId(context) != null) {
      DatabaseService databaseService = DatabaseService();
      await databaseService.updateUserGameName(
          matches.game, getGameId(context));
      Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
          builder: (context) => MatchesDetailsPage(
                matchId: matches.id,
                match: matches,
              )));
    }
  }

  _getUserGameName(context) async {
    String gameName;
    await DatabaseService().getUserData(matches.game).then((value) {
      gameName = value.gameName;
    });
    if (gameName != null) {
      Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
          builder: (context) => MatchesDetailsPage(
                matchId: matches.id,
                match: matches,
              )));
    } else {
      _showbottomsheet(context);
    }
  }
}
