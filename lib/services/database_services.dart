import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trident/models/match_models.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  final CollectionReference usersCollection =
      Firestore.instance.collection('users');

  final CollectionReference matchesCollection =
      Firestore.instance.collection('customMatchRooms');

  Future updateUserData(String name, String email, String wallet) async {
    return await usersCollection
        .document(uid)
        .setData({'name': name, 'email': email, 'walletAmount': wallet});
  }

  List<Matches> _matchListFromSnapShot(QuerySnapshot querySnapshot) {
    return querySnapshot.documents.map((e) {
      return Matches(
        game: e.data['game'] ?? '',
        name: e.data['name'] ?? '',
        status: e.data['status'] ?? '',
        ticket: e.data['ticket'] ?? '',
        imageUrl: e.data['imageUrl'] ?? '',
        map: e.data['map'] ?? '',
        matchNo: e.data['matchNo'] ?? '',
        maxParticipants: e.data['maxParticipants'] ?? '',
        perKill: e.data['perKill'] ?? '',
        prizePool: e.data['prizePool'] ?? '',
      );
    }).toList();
  }

  Stream<List<Matches>> get matches {
    return matchesCollection.snapshots().map(_matchListFromSnapShot);
  }
}
