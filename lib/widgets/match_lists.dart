import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trident/models/match_models.dart';
import 'package:trident/widgets/match_tile.dart';

class MatchLists extends StatefulWidget {
  @override
  _MatchListsState createState() => _MatchListsState();
}

class _MatchListsState extends State<MatchLists> {
  @override
  Widget build(BuildContext context) {
    final matches = Provider.of<List<Matches>>(context);
    return ListView.builder(
        itemCount: matches.length,
        itemBuilder: (context, index) {
          return MatchTile(
            matches: matches[index],
          );
        });
  }
}
