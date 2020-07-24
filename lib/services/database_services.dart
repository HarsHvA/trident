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

  final CollectionReference userMatchHistoryCollection =
      Firestore.instance.collection('userMatchHistory');

  Future updateUserData(String name, String email, String wallet) async {
    return await usersCollection
        .document(uid)
        .setData({'name': name, 'email': email, 'walletAmount': wallet});
  }

  Future updateUserGameName(game, id) async {
    String userId = await AuthService().uID();
    return await usersCollection.document(userId).updateData({game: id});
  }

  Future addMatchParticipants(matchId, gameName, name, game, matchNo) async {
    String userId = await AuthService().uID();
    return await participantsCollection.document(matchId).setData({
      'participants': FieldValue.arrayUnion([
        {
          'name': name,
          'gameName': gameName,
          'uid': userId,
          'matchId': matchId,
          'game': game,
          'matchNo': matchNo
        }
      ])
    }, merge: true);
  }

  Future<bool> checkIfAdmin() async {
    bool dog = false;
    String userId = await AuthService().uID();
    await usersCollection.document(userId).get().then((value) {
      dog = value.data['dog'] ?? false;
    });
    if (dog) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> checkMatchJoined(matchId) async {
    bool joined = false;
    String userId = await AuthService().uID();
    CollectionReference userMatchTokens =
        Firestore.instance.collection('userMatchTokens');

    await userMatchTokens.document(matchId).get().then((value) {
      joined = value.data[userId] ?? false;
    });

    if (joined) {
      return true;
    } else {
      return false;
    }
  }

  Future generateUserMatchToken(matchId) async {
    String userId = await AuthService().uID();
    CollectionReference userMatchTokens =
        Firestore.instance.collection('userMatchTokens');

    await userMatchTokens.document(matchId).setData({userId: true});
  }

  Future addToSubscribedGames(
    matchId,
    game,
    name,
    ticket,
    status,
    imageUrl,
    map,
    matchNo,
    maxPariticpants,
    perKill,
    prizePool,
    time,
  ) async {
    String userId = await AuthService().uID();
    return await usersCollection
        .document(userId)
        .collection('subscribedGames')
        .document(matchId)
        .setData({
      'game': game ?? '',
      'name': name ?? '',
      'ticket': ticket ?? 0,
      'status': status ?? '',
      'imageUrl': imageUrl ?? '',
      'map': map ?? '',
      'matchNo': matchNo ?? '',
      'maxParticipants': maxPariticpants ?? 0,
      'perKill': perKill ?? 0,
      'prizePool': prizePool ?? '',
      'time': time
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
          maxParticipants: e.data['maxParticipants'] ?? 0,
          perKill: e.data['perKill'] ?? 0,
          prizePool: e.data['prizePool'] ?? '',
          id: e.documentID,
          time: e.data['time'],
          resultOut: e.data['result'] ?? false);
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
      return participantList;
    });
  }

  Stream<List<Matches>> get ongoingMatches {
    return matchesCollection
        .where('status', isEqualTo: 'Live')
        .snapshots()
        .map(_matchListFromSnapShot);
  }

  Stream<List<Matches>> get allMatches {
    return matchesCollection
        .orderBy('time', descending: true)
        .snapshots()
        .map(_matchListFromSnapShot);
  }

  Stream<List<Matches>> myMatches(userId) {
    CollectionReference subscribedMatchesCollection = Firestore.instance
        .collection('users')
        .document(userId)
        .collection('subscribedGames');
    return subscribedMatchesCollection.snapshots().map((event) {
      return event.documents.map((e) {
        return Matches(
            game: e.data['game'] ?? '',
            name: e.data['name'] ?? '',
            status: e.data['status'] ?? '',
            ticket: e.data['ticket'] ?? 0,
            imageUrl: e.data['imageUrl'] ?? '',
            map: e.data['map'] ?? '',
            matchNo: e.data['matchNo'] ?? '',
            maxParticipants: e.data['maxParticipants'] ?? 0,
            perKill: e.data['perKill'] ?? 0,
            prizePool: e.data['prizePool'] ?? '',
            id: e.documentID,
            time: e.data['time']);
      }).toList();
    });
  }

  Stream<List<Matches>> get upcomingMatches {
    return matchesCollection
        .where('status', isEqualTo: 'Upcoming')
        .snapshots()
        .map(_matchListFromSnapShot);
  }

  Stream<Matches> getMatchDetails(id) {
    return matchesCollection.document(id).snapshots().map((value) {
      return Matches(
          game: value.data['game'] ?? '',
          name: value.data['name'] ?? '',
          status: value.data['status'] ?? '',
          imageUrl: value.data['imageUrl'] ?? '',
          ticket: value.data['ticket'] ?? 0,
          map: value.data['map'] ?? '',
          matchNo: value.data['matchNo'] ?? '',
          maxParticipants: value.data['maxParticipants'] ?? 0,
          perKill: value.data['perKill'] ?? 0,
          prizePool: value.data['prizePool'] ?? '',
          time: value.data['time'],
          id: value.documentID);
    });
  }

  Stream<Matches> getCompletedMatchDetails(id) {
    return matchesCollection.document(id).snapshots().map((value) {
      return Matches(
          game: value.data['game'] ?? '',
          name: value.data['name'] ?? '',
          status: value.data['status'] ?? '',
          imageUrl: value.data['imageUrl'] ?? '',
          ticket: value.data['ticket'] ?? 0,
          map: value.data['map'] ?? '',
          matchNo: value.data['matchNo'] ?? '',
          maxParticipants: value.data['maxParticipants'] ?? 0,
          perKill: value.data['perKill'] ?? 0,
          prizePool: value.data['prizePool'] ?? '',
          time: value.data['time'],
          id: value.documentID);
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

  Future<User> getUserInformation() async {
    String userId = await AuthService().uID();
    String name;
    String email;
    int walletMoney;
    usersCollection.document(userId).get().then((value) {
      name = value.data['name'];
      email = value.data['email'];
      walletMoney = value.data['walletAmount'];
    });
    return User(
        name: name ?? '', email: email ?? '', walletMoney: walletMoney ?? 0);
  }
}
