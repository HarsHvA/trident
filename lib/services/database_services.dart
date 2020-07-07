import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trident/models/match_models.dart';
import 'package:trident/models/participant_models.dart';
import 'package:trident/models/user_model.dart';
import 'package:trident/services/auth_service.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  final CollectionReference usersCollection =
      Firestore.instance.collection('users');

  final CollectionReference matchesCollection =
      Firestore.instance.collection('customMatchRooms');

  final CollectionReference participantsCollection =
      Firestore.instance.collection('participants');

  Future updateUserData(String name, String email, String wallet) async {
    return await usersCollection
        .document(uid)
        .setData({'name': name, 'email': email, 'walletAmount': wallet});
  }

  Future updateUserGameName(game, id) async {
    String userId = await AuthService().uID();
    return await usersCollection.document(userId).updateData({game: id});
  }

  Future addMatchParticipants(matchId, gameName, name) async {
    String userId = await AuthService().uID();
    return await participantsCollection.document(matchId).updateData({
      'participants': FieldValue.arrayUnion([
        {'name': name, 'gameName': gameName, 'uid': userId}
      ])
    });
  }

  List<Matches> _matchListFromSnapShot(QuerySnapshot querySnapshot) {
    return querySnapshot.documents.map((e) {
      return Matches(
          game: e.data['game'] ?? '',
          name: e.data['name'] ?? '',
          status: e.data['status'] ?? '',
          ticket: e.data['ticket'] ?? 0,
          imageUrl: e.data['imageUrl'] ?? '',
          map: e.data['map'] ?? '',
          matchNo: e.data['matchNo'] ?? '',
          maxParticipants: e.data['maxParticipants'] ?? '',
          perKill: e.data['perKill'] ?? '',
          prizePool: e.data['prizePool'] ?? '',
          id: e.documentID,
          time: e.data['time']);
    }).toList();
  }

  Stream<List<Participants>> getParticipantList(matchId) {
    return participantsCollection.document(matchId).snapshots().map((event) {
      List<Participants> participantList = [];
      List list = event.data['participants'];
      for (var i = 0; i < list.length; i++) {
        participantList.add(new Participants(
            gameName: list[i]['gameName'],
            name: list[i]['name'],
            uid: list[i]['uid']));
      }
      print(participantList[1].name);
      return participantList;
    });
  }

  Stream<List<Matches>> get ongoingMatches {
    return matchesCollection
        .where('status', isEqualTo: 'Live')
        .snapshots()
        .map(_matchListFromSnapShot);
  }

  Stream<List<Matches>> get upcomingMatches {
    return matchesCollection
        .where('status', isEqualTo: 'Upcoming')
        .snapshots()
        .map(_matchListFromSnapShot);
  }

  Stream<List<Matches>> get myMatches {
    return matchesCollection
        .where('uid', isEqualTo: uid)
        .snapshots()
        .map(_matchListFromSnapShot);
  }

  Stream<Matches> getMatchDetails(id) {
    return matchesCollection.document(id).snapshots().map((value) {
      return Matches(
          game: value.data['game'] ?? '',
          name: value.data['name'] ?? '',
          status: value.data['status'] ?? '',
          ticket: value.data['ticket'] ?? 0,
          map: value.data['map'] ?? '',
          matchNo: value.data['matchNo'] ?? '',
          maxParticipants: value.data['maxParticipants'] ?? '',
          perKill: value.data['perKill'] ?? '',
          prizePool: value.data['prizePool'] ?? '',
          time: value.data['time']);
    });
  }

  Future<User> getUserData(game) async {
    String userId = await AuthService().uID();
    String name;
    String email;
    String gameName;
    await usersCollection.document(userId).get().then((value) {
      name = value.data['name'];
      email = value.data['email'];
      gameName = value.data[game];
    });
    return User(name: name, email: email, gameName: gameName);
  }
}
