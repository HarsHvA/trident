import 'package:cloud_firestore/cloud_firestore.dart';
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

  final CollectionReference userMatchHistoryCollection =
      Firestore.instance.collection('userMatchHistory');

  final CollectionReference resultsCollection =
      Firestore.instance.collection('results');

  final CollectionReference pendingTransactionCollection =
      Firestore.instance.collection('transaction');

  final CollectionReference completedTransactionCollection =
      Firestore.instance.collection('completedTransaction');

  Future updateUserData(String name, String email, int wallet, int gems) async {
    return await usersCollection.document(uid).setData(
        {'name': name, 'email': email, 'walletAmount': wallet, 'gems': 0});
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

  Future addCoinsToWallet(newGems) async {
    String userId = await AuthService().uID();
    int gems = await usersCollection.document(userId).get().then((value) {
      return value.data['gems'] ?? 0;
    });
    newGems += gems;
    await Firestore.instance.runTransaction((transaction) async {
      return await transaction
          .update(usersCollection.document(userId), {'gems': newGems});
    });
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

    await userMatchTokens
        .document(matchId)
        .setData({userId: true}, merge: true);
  }

  Future sendWithdrawlrequest(amount, time, mode, mobileNo) async {
    String userId = await AuthService().uID();
    await pendingTransactionCollection.document(userId).setData({
      'transactions': FieldValue.arrayUnion([
        {
          'uid': userId,
          'status': 'pending',
          'amount': amount,
          'time': time.toString(),
          'mode': mode,
          'mobileNo': mobileNo
        }
      ])
    }, merge: true);
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
      roomId,
      roomPassword) async {
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
      'time': time,
      'roomId': roomId ?? '',
      'roomPassword': roomPassword ?? ''
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
          resultOut: e.data['result'] ?? false,
          roomId: e.data['roomId'] ?? '',
          roomPassword: e.data['roomPassword'] ?? '');
    }).toList();
  }

  Stream<List<Results>> result(matchId) {
    // print(matchId);
    return resultsCollection.document(matchId).snapshots().map((event) {
      List<Results> result = [];
      List list = event.data['results'];
      for (var i = 0; i < list.length; i++) {
        result.add(new Results(
            gameId: list[i]['playerId'],
            kills: list[i]['kills'],
            reward: list[i]['moneyWon']));
      }
      return result;
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
    return pendingTransactionCollection
        .document(userId)
        .snapshots()
        .map((event) {
      List<UserTransactions> transactionList = [];
      List list = event.data['transactions'];
      for (var i = 0; i < list.length; i++) {
        if (list[i]['status'] == 'pending') {
          transactionList.add(new UserTransactions(
              mode: list[i]['mode'],
              amount: list[i]['amount'].toString(),
              mobileNo: list[i]['mobileNo'].toString()));
        }
      }
      // print(transactionList);
      return transactionList.isNotEmpty ? transactionList : null;
    });
  }

  Stream<List<UserTransactions>> getUserCompletedTransaction(userId) {
    return completedTransactionCollection
        .document(userId)
        .snapshots()
        .map((event) {
      List<UserTransactions> transactionList = [];
      List list = event.data['transactions'];
      for (var i = 0; i < list.length; i++) {
        if (list[i]['status'] == 'completed') {
          transactionList.add(new UserTransactions(
              mode: list[i]['mode'],
              amount: list[i]['amount'].toString(),
              mobileNo: list[i]['mobileNo'].toString()));
        }
      }
      // print(transactionList);
      return transactionList.isNotEmpty ? transactionList : null;
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
            time: e.data['time'],
            roomId: e.data['roomId'] ?? '',
            roomPassword: e.data['roomPassword'] ?? '');
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
          id: value.documentID,
          roomId: value.data['roomId'],
          roomPassword: value.data['roomPassword'],
          description: value.data['description']);
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
      codId = value.data['COD'];
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
