import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trident/models/match_models.dart';
import 'package:trident/services/database_services.dart';
import 'package:trident/top_bar.dart';
import 'package:trident/widgets/match_lists.dart';

class OngoingGamesTab extends StatefulWidget {
  @override
  _OngoingGamesTabState createState() => _OngoingGamesTabState();
}

class _OngoingGamesTabState extends State<OngoingGamesTab> {
  final DatabaseService databaseService = DatabaseService();
  @override
  Widget build(BuildContext context) {
    double unitHeightValue = MediaQuery.of(context).size.height * 0.01;
    return StreamProvider<List<Matches>>.value(
      initialData: List(),
      value: databaseService.ongoingMatches,
      child: SafeArea(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            extendBody: true,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(80),
              child: Stack(
                children: <Widget>[
                  TopBar(),
                  Align(
                    alignment: Alignment.center,
                    child: AutoSizeText(
                      'LiveTournaments',
                      style: TextStyle(
                          color: Colors.white, fontSize: unitHeightValue * 2.5),
                    ),
                  )
                ],
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
              child: MatchLists(),
            ),
          ),
        ),
      ),
    );
  }
}
