import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';



class UserHandler extends ChangeNotifier {
  String displayName = '';
  String message = '';
  final FirebaseAuth firebaseAuth;
  UserHandler(this.firebaseAuth);


  String? getUserId() {
    User? user = firebaseAuth.currentUser;
    late String? userId;
    if(user != null){
      userId = user.uid;
    }
    return userId;
  }

  String? getEmail(){
    User? user = firebaseAuth.currentUser;
    late String? email;
    if(user != null){
      email = user.email;
    }
    return email;
  }

  String? emptyDisplayNameChecker(String? name) {
    if (name == null || name.isEmpty) {
      return 'Please input your display name.';
    }
    return null;
  }

  String? getDisplayName() {
    User? user = firebaseAuth.currentUser;
    late String? displayName;
    if(user != null){
      displayName = user.displayName;
    }
    else{
      displayName = 'Not Set';
    }
    return displayName;
  }


  Future<String> updateDisplayName() async {
    User? user = firebaseAuth.currentUser;
    if(user != null){
      if(displayName == null){
        user.updateDisplayName('Not Set');
        return 'Not Set';
      }
      else {
        user.updateDisplayName(displayName);
        return 'Successful';
      }
    }
    return 'USER NOT FOUND';
  }


  String? emptyStatusMessageChecker(String? name) {
    if (name == null || name.isEmpty) {
      return '';
    }
    return null;
  }

  void setMessage(String str) {
    message = str;
    notifyListeners();
  }



  Future<String> updatePhotoURL(String? photoURL) async {
    User? user = firebaseAuth.currentUser;
    if(user != null){
      if(photoURL == null){
        user.updateDisplayName('Not Set');
        return 'Not Set';
      }
      else {
        user.updateDisplayName(photoURL);
        return 'Successful';
      }
    }
    return 'PHOTO URL NOT FOUND';
  }
}