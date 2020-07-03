import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:trident/models/match_models.dart';

class MatchTile extends StatelessWidget {
  final Matches matches;
  MatchTile({this.matches});

  @override
  Widget build(BuildContext context) {
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
                                  style: TextStyle(
                                      fontSize: 25, color: Colors.white),
                                ),
                                AutoSizeText(matches.game,
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.white)),
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
                                        fontSize: 15,
                                        color: Colors.white),
                                  )),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: AutoSizeText(
                                    "100" + "/" + matches.maxParticipants,
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.white)),
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
                                    fontSize: 20, color: Colors.white)),
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
                      defaultColumnWidth: FixedColumnWidth(
                          MediaQuery.of(context).size.width / 3),
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
                                  child: AutoSizeText("2 July 2020 at 23:00")))
                        ]),
                        TableRow(children: [
                          TableCell(
                              verticalAlignment:
                                  TableCellVerticalAlignment.middle,
                              child: Center(
                                  child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: SizedBox(
                                  height: 20,
                                  child:
                                      ImageIcon(AssetImage("assets/cup.png")),
                                ),
                              ))),
                          TableCell(
                              verticalAlignment:
                                  TableCellVerticalAlignment.fill,
                              child: Center(
                                  child: AutoSizeText(
                                      "\u20B9" + matches.prizePool)))
                        ]),
                      ],
                    ),
                    Container(
                      alignment: Alignment.bottomRight,
                      child: RaisedButton(
                          disabledColor: Colors.green,
                          child: Text("Join"),
                          onPressed: null),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
