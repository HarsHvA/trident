import 'dart:ffi';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:trident/models/constants.dart';
import 'package:trident/models/match_models.dart';
import 'package:trident/services/database_services.dart';
import 'package:trident/views/match_details_page.dart';

class MatchTile extends StatelessWidget {
  final Matches matches;
  MatchTile({this.matches});

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
                        child: Image.network(
                          matches.imageUrl,
                          // 'https://resize.indiatvnews.com/en/resize/newbucket/1200_-/2020/02/pubg-1580537222.jpg',
                          //'https://cdn.vox-cdn.com/thumbor/eGwtGUFjQR-OqWIYuBZkEA0LXIs=/0x0:2560x1440/1200x675/filters:focal(1076x516:1484x924)/cdn.vox-cdn.com/uploads/chorus_image/image/66532267/kv.0.jpg',
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
                      Positioned.fill(
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: AutoSizeText(
                                    matches.status,
                                    style: TextStyle(
                                        backgroundColor: Colors.red.shade900,
                                        fontSize: unitHeightValue * 1.5,
                                        color: Colors.white),
                                  )),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: AutoSizeText(
                                    "100" + "/" + matches.maxParticipants,
                                    style: TextStyle(
                                        fontSize: unitHeightValue * 2.5,
                                        color: Colors.white)),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: AutoSizeText(
                                "\u20B9" + matches.perKill + "/kill",
                                style: TextStyle(
                                    fontSize: unitHeightValue * 2.5,
                                    color: Colors.white)),
                          ),
                        ),
                      )
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
                                "2 July 2020 at 23:00",
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
                                      ImageIcon(AssetImage("assets/cup.png")),
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
                          "Join",
                          style: TextStyle(fontSize: unitHeightValue * 2),
                        ),
                        onPressed: () {
                          _showbottomsheet(context);
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
                              // _gameId(context);
                              Navigator.of(context, rootNavigator: true)
                                  .push(MaterialPageRoute(
                                      builder: (context) => MatchesDetailsPage(
                                            matchId: matches.id,
                                            match: matches,
                                          )));
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
}
