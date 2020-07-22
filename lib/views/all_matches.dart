import 'package:flutter/material.dart';
import 'package:trident/models/match_models.dart';
import 'package:trident/services/database_services.dart';
import 'package:trident/views/edit_match.dart';
import 'package:trident/views/post_result.dart';

class AllMatches extends StatefulWidget {
  @override
  _AllMatchesState createState() => _AllMatchesState();
}

class _AllMatchesState extends State<AllMatches> {
  @override
  Widget build(BuildContext context) {
    double unitHeightValue = MediaQuery.of(context).size.height * 0.01;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Manage Matches',
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
      body: StreamBuilder<List<Matches>>(
          stream: DatabaseService().allMatches,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return Padding(
                        padding: const EdgeInsets.all(15.0),
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
                                      'Game : ' + snapshot.data[index].game ??
                                          '',
                                      style: TextStyle(
                                          fontSize: unitHeightValue * 2),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'id : ' + snapshot.data[index].id ?? '',
                                      style: TextStyle(
                                          fontSize: unitHeightValue * 2),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'matchNo : ' +
                                              snapshot.data[index].matchNo ??
                                          '',
                                      style: TextStyle(
                                          fontSize: unitHeightValue * 2),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'status : ' +
                                              snapshot.data[index].status ??
                                          '',
                                      style: TextStyle(
                                          fontSize: unitHeightValue * 2.5,
                                          color: Colors.red.shade900),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('maxParticipants : ' +
                                            snapshot.data[index].maxParticipants
                                                .toString() ??
                                        ''),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                        'name : ' + snapshot.data[index].name ??
                                            ''),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('prizePool : ' +
                                            snapshot.data[index].prizePool ??
                                        ''),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('perKill : ' +
                                            snapshot.data[index].perKill
                                                .toString() ??
                                        ''),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('ticket : ' +
                                            snapshot.data[index].ticket
                                                .toString() ??
                                        ''),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('time : ' +
                                            snapshot.data[index].time
                                                .toDate()
                                                .toLocal()
                                                .toString() ??
                                        ''),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: RaisedButton(
                                      color: Colors.red,
                                      colorBrightness: Brightness.light,
                                      onPressed: () {
                                        String id = snapshot.data[index].id;
                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .push(MaterialPageRoute(
                                                builder: (context) =>
                                                    EditMatch(matchId: id)));
                                      },
                                      child: Text('Edit Match'),
                                      textColor: Colors.white,
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: RaisedButton(
                                      color: Colors.green,
                                      colorBrightness: Brightness.light,
                                      onPressed: () {
                                        String id = snapshot.data[index].id;
                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .push(MaterialPageRoute(
                                                builder: (context) =>
                                                    PostResult(matchId: id)));
                                      },
                                      child: _buttonFunctionName(
                                          snapshot.data[index].resultOut),
                                      textColor: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            )));
                  });
            } else {
              return Center(
                child: Text('Somthing must have happened'),
              );
            }
          }),
    );
  }

  _buttonFunctionName(result) {
    if (result) {
      return Text('Edit results');
    } else {
      return Text('Post Result');
    }
  }
}
