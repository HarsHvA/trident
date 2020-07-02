import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class OngoingGamesTab extends StatefulWidget {
  @override
  _OngoingGamesTabState createState() => _OngoingGamesTabState();
}

class _OngoingGamesTabState extends State<OngoingGamesTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBody: true,
        body: Container(
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
                    child: Image.network(
                      'https://cdn.vox-cdn.com/thumbor/eGwtGUFjQR-OqWIYuBZkEA0LXIs=/0x0:2560x1440/1200x675/filters:focal(1076x516:1484x924)/cdn.vox-cdn.com/uploads/chorus_image/image/66532267/kv.0.jpg',
                      fit: BoxFit.fill,
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
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "Solo adventure",
                                  style: TextStyle(fontSize: 25),
                                ),
                                Text("Time: 22:00",
                                    style: TextStyle(fontSize: 20)),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                LinearPercentIndicator(
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  lineHeight: 5.0,
                                  percent: 0.5,
                                  backgroundColor: Colors.grey,
                                  progressColor: Colors.blue,
                                ),
                                Text("100/100",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontSize: 15,
                                    ))
                              ],
                            ),
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
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
