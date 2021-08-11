import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';



class PasswordHandler extends ChangeNotifier {
  String email = '';
  String message = '';
  final FirebaseAuth firebaseAuth;

  PasswordHandler(this.firebaseAuth);

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


  Future<String> sendPasswordResetEmail() async {
    try{
      await firebaseAuth.sendPasswordResetEmail(email: email);
      return 'Successful';
    }
    catch (e){
      debugPrint('Send Password Reset Email (from Login): Exception Ocurred.');
      debugPrint(e.toString());
      return 'Error';
    }
  }


  Future<String> sendEmailForPasswordReset(var email) async {
    try{
      await firebaseAuth.sendPasswordResetEmail(email: email);
      return 'Successful';
    }
    catch (e){
      debugPrint('Send Password Reset (from Setting): Exception Ocurred.');
      debugPrint(e.toString());
      return 'Error';
    }
  }

}