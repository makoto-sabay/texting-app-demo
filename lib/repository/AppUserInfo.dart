import 'package:firebase_auth/firebase_auth.dart';
import 'package:messaging_app/screens/constants.dart';


class AppUserInfo {
  User? user;
  var userId;
  var displayName;
  var email;
  var photoURL;
  var emailVerified;
  var statusMessage = 'Not Set';


  void setUser(User user){
    if(user != null){
      this.user = user;
      this.userId = user.uid;
      this.displayName = user.displayName;
      this.email = user.email;
      this.photoURL = user.photoURL;
      this.emailVerified = user.emailVerified;
    }
    else {
      this.userId = '';
      this.displayName = 'NULL USER';
      this.email = 'Unknown Email';
      this.photoURL = defaultUserImagePath;
      this.emailVerified = false;
    }
  }


  String getUserId(){
    if(userId == null){
      return 'USER ID';
    }
    if(userId == ''){
      return 'USER ID';
    }
    return userId;
  }

  String getDisplayName(){
    if(displayName == null){
      return 'Not Set';
    }
    if(displayName == '') {
      return 'Not Set';
    }
    return displayName;
  }

  String getEmail(){
    if(email == null){
      return 'Not Set';
    }
    if(email == '') {
      return 'Not Set';
    }
    return email;
  }

  String getPhotoURL(){
    if(photoURL == null){
      return defaultUserImagePath;
    }
    if(photoURL == '') {
      return defaultUserImagePath;
    }
    return photoURL;
  }

  String getEmailVerified(){
    return emailVerified;
  }


  void setStatusMessage(String? message){
    this.statusMessage = message!;
  }

  String getStatusMessage() {
    if(statusMessage == null){
      return 'Not Set';
    }
    return statusMessage;
  }
}

