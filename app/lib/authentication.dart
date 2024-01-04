import 'package:firebase_auth/firebase_auth.dart' as f;
import 'package:app/user.dart';

class AuthService {
  final f.FirebaseAuth _firebaseAuth = f.FirebaseAuth.instance;

  Future<User?> signUpUser(
    String email,
    String password,
  ) async {
    try {
      final f.UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      final f.User? firebaseUser = userCredential.user;
      if (firebaseUser != null) {
        return User(
          id: firebaseUser.uid,
          email: firebaseUser.email,
          displayName: firebaseUser.displayName,
        );
      }
    } on f.FirebaseAuthException catch (e) {
      print(e.toString());
    }
    return null;
  }

  Future<void> signOutUser() async {
    final f.User? firebaseUser = _firebaseAuth.currentUser;
    if (firebaseUser != null) {
      await _firebaseAuth.signOut();
    }
  }
}
