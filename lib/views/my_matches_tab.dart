import 'package:flutter/material.dart';
import 'package:trident/models/match_models.dart';
import 'package:trident/services/auth_service.dart';
import 'package:trident/services/database_services.dart';
import 'package:trident/widgets/match_tile.dart';

class MyMatchesTab extends StatefulWidget {
  @override
  _MyMatchesTabState createState() => _MyMatchesTabState();
}

class _MyMatchesTabState extends State<MyMatchesTab> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService().uID(),
      builder: (context, snap) {
        if (snap.hasData) {
          return StreamBuilder<List<Matches>>(
              stream: DatabaseService().myMatches(snap.data),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          return MatchTile(
                            matches: snapshot.data[index],
                          );
                        }),
                  );
                } else {
                  return Center(child: Text('No matches to show'));
                }
              });
        } else {
          return Center(child: Text('No matches to show'));
        }
      },
    );
  }
}
