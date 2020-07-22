import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trident/models/match_models.dart';
import 'package:trident/services/database_services.dart';
import 'package:trident/widgets/match_lists.dart';

class UpcomingMatchesTab extends StatefulWidget {
  @override
  _UpcomingMatchesTabState createState() => _UpcomingMatchesTabState();
}

class _UpcomingMatchesTabState extends State<UpcomingMatchesTab> {
  final DatabaseService databaseService = DatabaseService();
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Matches>>.value(
      initialData: List(),
      value: databaseService.upcomingMatches,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
        child: MatchLists(),
      ),
    );
  }
}
