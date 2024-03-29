import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:trident/models/match_models.dart';
import 'package:trident/services/database_services.dart';

class ResultPage extends StatefulWidget {
  final String matchId;
  final int groupNo;
  ResultPage({Key key, @required this.matchId, @required this.groupNo})
      : super(key: key);
  @override
  _ResultPageState createState() => _ResultPageState(matchId, groupNo);
}

class _ResultPageState extends State<ResultPage> {
  String matchId;
  int groupNo;
  _ResultPageState(this.matchId, this.groupNo);
  @override
  Widget build(BuildContext context) {
    double unitHeightValue = MediaQuery.of(context).size.height * 0.01;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Group $groupNo Results',
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
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(8),
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.info_outline,
                        color: Colors.red.shade900,
                      ),
                    ),
                    AutoSizeText(
                      'Rewards are added to wallet within 24 hours',
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(8),
              width: MediaQuery.of(context).size.width,
              child: RaisedButton(
                color: Colors.red.shade900,
                colorBrightness: Brightness.light,
                onPressed: () async {
                  await _sendMail('Results Group $groupNo ');
                },
                child: Text('Help!'),
                textColor: Colors.white,
              ),
            ),
            SingleChildScrollView(
              child: StreamBuilder<List<Results>>(
                  stream: DatabaseService().result(matchId, groupNo.toString()),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.all(8),
                          child: DataTable(
                              columns: [
                                DataColumn(
                                    label: Text(
                                  'Game-Id',
                                  style: TextStyle(color: Colors.red.shade900),
                                )),
                                DataColumn(
                                    label: Text(
                                  'Kills',
                                  style: TextStyle(color: Colors.red.shade900),
                                )),
                                DataColumn(
                                    label: Text(
                                  'Rewards',
                                  style: TextStyle(color: Colors.red.shade900),
                                ))
                              ],
                              rows: snapshot.data
                                  .map((e) => DataRow(cells: <DataCell>[
                                        DataCell(Text(e.gameId)),
                                        DataCell(Text(e.kills.toString())),
                                        DataCell(Text(
                                            '\u20B9 ' + e.reward.toString())),
                                      ]))
                                  .toList()));
                    } else {
                      return Container(
                        child:
                            AutoSizeText('Results have not been uploaded yet!'),
                      );
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> _sendMail(subject) async {
  final Email email = Email(
    subject: 'Subject : ' + subject,
    recipients: ['help.iceagestud@gmail.com'],
  );

  try {
    await FlutterEmailSender.send(email);
  } catch (error) {
    print(error.toString());
  }
}
