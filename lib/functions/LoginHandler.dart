import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class LoginHandler extends ChangeNotifier {
  String email = '';
  String password = '';
  String message = '';
  bool loginStatus = false;
  final FirebaseAuth firebaseAuth;

  LoginHandler(this.firebaseAuth);

  void setMessage(String str) {
    message = str;
    notifyListeners();
  }


  Future<bool> getLoginStatus(BuildContext context) async {
    await isLoggedIn(context);
    return Future.value(loginStatus);
  }

  String? emptyEmailChecker(String? email) {
    if (email == null || email.isEmpty) {
      return 'Please input your email.';
    }
    return null;
  }

  String? emptyPasswordChecker(String? password) {
    if (password == null || password.isEmpty) {
      return 'Please input your valid password.';
    }
    return null;
  }


  Future<bool> isLoggedIn(BuildContext context) async {
    bool result = false;
    User? user = firebaseAuth.currentUser;
    if (user != null) {
      result = true;
    }
    return await Future.value(result);
  }


  Future<bool> login() async {
    try {
      final UserCredential userCredential = await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      final _isVerified = await firebaseAuth.currentUser!.emailVerified;
      if (!_isVerified) {
        firebaseAuth.currentUser!.sendEmailVerification();
        await firebaseAuth.signOut();
        return Future.value(false);
      }
      return Future.value(true);
    }
    catch (e) {
      debugPrint('Login: Exception Occurred.');
      debugPrint(e.toString());
      return Future.value(false);
    }
  }


  Future<void> logOut() async {
    await firebaseAuth.signOut();
  }

}

