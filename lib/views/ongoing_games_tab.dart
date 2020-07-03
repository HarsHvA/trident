import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trident/models/match_models.dart';
import 'package:trident/services/database_services.dart';
import 'package:trident/widgets/match_lists.dart';

class OngoingGamesTab extends StatefulWidget {
  @override
  _OngoingGamesTabState createState() => _OngoingGamesTabState();
}

class _OngoingGamesTabState extends State<OngoingGamesTab> {
  final DatabaseService databaseService = DatabaseService();
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Matches>>.value(
      initialData: List(),
      value: databaseService.matches,
      child: Scaffold(
        extendBody: true,
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: MatchLists(),
        ),
      ),
    );
  }
}
