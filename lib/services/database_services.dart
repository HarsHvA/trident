import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:trident/models/match_models.dart';
import 'package:trident/models/participant_models.dart';
import 'package:trident/models/transaction_models.dart';
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

  final CollectionReference participantsGroupCollection =
      Firestore.instance.collection('participantsGroup');

  final CollectionReference userMatchHistoryCollection =
      Firestore.instance.collection('userMatchHistory');

  final CollectionReference resultsCollection =
      Firestore.instance.collection('results');

  final CollectionReference transactionCollection =
      Firestore.instance.collection('transaction');

  final CollectionReference pendingTransactionCollection =
      Firestore.instance.collection('pendingTransaction');

  final CollectionReference groupCollection =
      Firestore.instance.collection('group');

  Future updateUserData(String name, String email, int wallet, int gems) async {
    try {
      await CloudFunctions.instance
          .getHttpsCallable(functionName: 'addUserData')
          .call(<String, dynamic>{'name': name, 'email': email});
    } catch (e) {
      print(e.toString());
    }
  }

  Future updateUserProfile(
      String name, String pubg, String cod, String freefire) async {
    try {
      await CloudFunctions.instance
          .getHttpsCallable(functionName: 'updateUserData')
          .call(<String, dynamic>{
        'name': name,
        'pubg': pubg,
        'cod': cod,
        'freefire': freefire
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future updateUserGameName(game, id) async {
    try {
      await CloudFunctions.instance
          .getHttpsCallable(functionName: 'updateUserGameName')
          .call(<String, dynamic>{'game': game, 'id': id});
    } catch (e) {
      print(e.toString());
    }
  }

  Future addMatchParticipants(matchId, gameName, name, game, matchNo) async {
    try {
      await CloudFunctions.instance
          .getHttpsCallable(functionName: 'addMatchParticipants')
          .call(<String, dynamic>{
        'name': name,
        'gameName': gameName,
        'matchId': matchId,
        'game': game,
        'matchNo': matchNo
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future addToParticipantsGroup(matchId, gameName, name, game, groupId) async {
    try {
      await CloudFunctions.instance
          .getHttpsCallable(functionName: 'addMatchParticipantsGroup')
          .call(<String, dynamic>{
        'name': name,
        'gameName': gameName,
        'matchId': matchId,
        'game': game,
        'groupId': groupId
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future addCoinsToWallet(newGems) async {
    String userId = await AuthService().uID();
    int gems = await usersCollection.document(userId).get().then((value) {
      return value.data['gems'] ?? 0;
    });
    newGems += gems;
    try {
      await CloudFunctions.instance
          .getHttpsCallable(functionName: 'addCoinsToWallet')
          .call(<String, dynamic>{'newGems': newGems});
    } catch (e) {
      print(e.toString());
    }
  }

  Future<bool> checkMatchJoined(matchId) async {
    bool joined = false;
    String userId = await AuthService().uID();
    CollectionReference userMatchTokens =
        Firestore.instance.collection('userMatchTokens');

    await userMatchTokens.document(matchId).get().then((value) {
      joined = value.data[userId]['joined'] ?? false;
    });

    if (joined) {
      return true;
    } else {
      return false;
    }
  }

  Future<int> getGroupId(matchId) async {
    int groupCode;
    String userId = await AuthService().uID();
    CollectionReference userMatchTokens =
        Firestore.instance.collection('userMatchTokens');

    await userMatchTokens.document(matchId).get().then((value) {
      groupCode = value.data[userId]['groupId'] ?? null;
    });
    return groupCode;
  }

  Future<int> getGroupLength(matchId, groupId) async {
    int length = 0;
    await participantsGroupCollection.document(matchId).get().then((value) {
      List list = value.data[groupId];
      length = list.length ?? 0;
    });
    return length;
  }

  Future generateUserMatchToken(matchId, id) async {
    try {
      await CloudFunctions.instance
          .getHttpsCallable(functionName: 'generateUserMatchToken')
          .call(<String, dynamic>{'matchId': matchId, 'id': id});
    } catch (e) {
      print(e.toString());
    }
  }

  Future sendWithdrawlrequest(amount, time, mode, mobileNo) async {
    String userId = await AuthService().uID();
    CollectionReference userTransactionCollection = Firestore.instance
        .collection('users')
        .document(userId)
        .collection('transactions');
    await userTransactionCollection.add({
      'uid': userId,
      'status': 'pending',
      'amount': amount,
      'mode': mode,
      'mobileNo': mobileNo
    });
  }

  Future addWithdrawlrequest(amount, time, mode, mobileNo) async {
    String userId = await AuthService().uID();
    await pendingTransactionCollection.add({
      'uid': userId,
      'status': 'pending',
      'amount': amount,
      'mode': mode,
      'mobileNo': mobileNo
    });
  }

  Future addToSubscribedGames(
    matchId,
    game,
    name,
    imageUrl,
    matchNo,
    prizePool,
    time,
  ) async {
    try {
      await CloudFunctions.instance
          .getHttpsCallable(functionName: 'addToSubscribedGames')
          .call(<String, dynamic>{
        'game': game,
        'name': name,
        'imageUrl': imageUrl,
        'matchNo': matchNo,
        'prizePool': prizePool,
        'time': time,
        'matchId': matchId
      });
    } catch (e) {
      print(e.toString());
    }
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
          resultOut: e.data['result'] ?? false,
          roomId: e.data['roomId'] ?? '',
          roomPassword: e.data['roomPassword'] ?? '');
    }).toList();
  }

  Stream<List<Results>> result(matchId, groupNo) {
    // print(matchId);
    return resultsCollection.document(matchId).snapshots().map((event) {
      List<Results> result = [];
      List list = event.data[groupNo];
      for (var i = 0; i < list.length; i++) {
        result.add(Results(
            gameId: list[i]['gameId'],
            kills: list[i]['kills'].toString(),
            reward: list[i]['reward'].toString()));
      }
      return result;
    });
  }

  Stream<RoomDetailsModel> getRoomDetails(matchId, id) {
    return groupCollection.document(matchId).snapshots().map((event) {
      return RoomDetailsModel(
          roomId: event.data[id]['roomId'] ?? '',
          id: event.data[id]['id'] ?? '',
          roomPassword: event.data[id]['roomPassword'] ?? '',
          time: event.data[id]['time']);
    });
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

  Future<int> getParticipantsListLength(matchId) async {
    int length = 0;
    try {
      await participantsCollection.document(matchId).get().then((value) {
        List list = value.data['participants'];
        length = list.length;
      });
    } catch (e) {
      length = 0;
    }
    return length;
  }

  Stream<List<UserTransactions>> getUserPendingTransaction(userId) {
    CollectionReference userTransactionCollection = Firestore.instance
        .collection('users')
        .document(userId)
        .collection('transactions');
    return userTransactionCollection
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .map((event) {
      return event.documents.map((e) {
        return UserTransactions(
            mode: e.data['mode'] ?? '',
            amount: e.data['amount'].toString() ?? '',
            mobileNo: e.data['mobileNo'].toString() ?? '');
      }).toList();
    });
  }

  Stream<List<UserTransactions>> getUserCompletedTransaction(userId) {
    CollectionReference userTransactionCollection = Firestore.instance
        .collection('users')
        .document(userId)
        .collection('transactions');
    return userTransactionCollection
        .where('status', isEqualTo: 'completed')
        .snapshots()
        .map((event) {
      return event.documents.map((e) {
        return UserTransactions(
            mode: e.data['mode'] ?? '',
            amount: e.data['amount'].toString() ?? '',
            mobileNo: e.data['mobileNo'].toString() ?? '');
      }).toList();
    });
  }

  Stream<List<Matches>> get ongoingMatches {
    return matchesCollection
        .where('status', isEqualTo: 'Live')
        .orderBy('time', descending: false)
        .snapshots()
        .map(_matchListFromSnapShot);
  }

  Stream<List<MyMatches>> myMatches(userId) {
    CollectionReference subscribedMatchesCollection = Firestore.instance
        .collection('users')
        .document(userId)
        .collection('subscribedGames');
    return subscribedMatchesCollection.snapshots().map((event) {
      return event.documents.map((e) {
        return MyMatches(
            game: e.data['game'] ?? '',
            name: e.data['name'] ?? '',
            imageUrl: e.data['imageUrl'] ?? '',
            matchNo: e.data['matchNo'] ?? '',
            prizePool: e.data['prizePool'] ?? '',
            id: e.documentID,
            time: e.data['time'] ?? '');
      }).toList();
    });
  }

  Stream<List<Matches>> get upcomingMatches {
    return matchesCollection
        .where('status', isEqualTo: 'Upcoming')
        .orderBy('time', descending: false)
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
          id: value.documentID,
          roomId: value.data['roomId'],
          roomPassword: value.data['roomPassword'],
          description: value.data['description'],
          noOfGroups: value.data['noOfGroups'] ?? 0);
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
    int gems;
    String pubgId;
    String codId;
    String freefireId;
    await usersCollection.document(userId).get().then((value) {
      name = value.data['name'];
      email = value.data['email'];
      walletMoney = value.data['walletAmount'];
      gems = value.data['gems'];
      pubgId = value.data['PUBG Mobile'];
      codId = value.data['CallOfDuty'];
      freefireId = value.data['Freefire'];
    });
    return User(
      name: name ?? '',
      email: email ?? '',
      walletMoney: walletMoney ?? 0,
      gems: gems ?? 0,
      pubgId: pubgId,
      freefireId: freefireId,
      codId: codId,
    );
  }
}
