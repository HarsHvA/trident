import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trident/models/match_models.dart';
import 'package:trident/top_bar.dart';

class MatchesDetailsPage extends StatefulWidget {
  final String matchId;

  MatchesDetailsPage({Key key, this.matchId}) : super(key: key);
  @override
  _MatchesDetailsPageState createState() => _MatchesDetailsPageState(matchId);
}

class _MatchesDetailsPageState extends State<MatchesDetailsPage> {
  String matchId;
  _MatchesDetailsPageState(this.matchId);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          PreferredSize(preferredSize: Size.fromHeight(100), child: TopBar()),
      body: Center(
        child: Container(
          child: Text(matchId),
        ),
      ),
    );
  }
}
