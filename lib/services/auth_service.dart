import 'package:firebase_auth/firebase_auth.dart';
import 'package:trident/services/database_services.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Stream<String> get onAuthStateChanged =>
      _firebaseAuth.onAuthStateChanged.map((FirebaseUser user) => user?.uid);
// Email and password signUP
  Future<String> createUserWithEmailAndPassword(
      String email, String password, String name) async {
    final currentUser = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);

    //update the name
    var userUpdateName = UserUpdateInfo();
    userUpdateName.displayName = name;
    await currentUser.user.updateProfile(userUpdateName);
    await currentUser.user.reload();
    DatabaseService(uid: currentUser.user.uid).updateUserData(name, email, '0');
    return currentUser.user.uid;
  }

// SignIn
  Future<String> signIn(String email, String password) async {
    return (await _firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password))
        .user
        .uid;
  }

  signOut() {
    _firebaseAuth.signOut();
  }

  Future sendPasswordResetEmail(String email) async {
    return await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<String> username() async {
    try {
      FirebaseUser user = await _firebaseAuth.currentUser();
      String name = user.displayName;
      return name;
    } catch (e) {
      print(e.message);
      return "";
    }
  }
}
