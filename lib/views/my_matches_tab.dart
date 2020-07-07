import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trident/models/match_models.dart';
import 'package:trident/services/database_services.dart';
import 'package:trident/widgets/match_lists.dart';

class MyMatchesTab extends StatefulWidget {
  @override
  _MyMatchesTabState createState() => _MyMatchesTabState();
}

class _MyMatchesTabState extends State<MyMatchesTab> {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Matches>>.value(
      initialData: List(),
      value: DatabaseService().myMatches,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
        child: MatchLists(),
      ),
    );
    ;
  }
}
