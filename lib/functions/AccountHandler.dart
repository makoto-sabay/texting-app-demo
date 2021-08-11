import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';



class AccountHandler extends ChangeNotifier {
  String email = '';
  String password = '';
  String message = '';
  final FirebaseAuth firebaseAuth;

  AccountHandler(this.firebaseAuth);

  void setMessage(String str) {
    message = str;
    notifyListeners();
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

  Future<bool> isEmail() async {
    User? user = firebaseAuth.currentUser;

    if (user!= null && !user.emailVerified) {
      return Future.value(true);
    }
    else {
      return Future.value(false);
    }
  }


  Future<bool> createAccount() async {
    try {
      final user = await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      if (user != null) {
        await firebaseAuth.currentUser!.sendEmailVerification();
        return Future.value(true);
      }
      else {
        debugPrint('Create Account: Failed');
        return Future.value(false);
      }
    }
    catch (e) {
      debugPrint('Create Account: Exception Occurred.');
      debugPrint(e.toString());
      return Future.value(false);
    }
  }


  Future<String> deleteAccount(User? user) async {
    if(User == null){
      return 'null';
    }
    try {
      await user!.delete();
      return 'Successful';
    }
    catch (error) {
      debugPrint("Delete Account: Exception occurred.");
      debugPrint(error.toString());
      return 'Error';
    }
  }
}