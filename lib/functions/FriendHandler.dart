import 'package:flutter/material.dart';
import 'package:messaging_app/functions/DBHelper.dart';
import 'package:messaging_app/screens/constants.dart';

class FriendHandler {
  final DBHelper? dbHelper = DBHelper.instance;
  String email = '';

  FriendHandler(String email) {
    this.email = email;
  }


  Future<int> getNumberFriends() async {
    if(email == null || email == ''){
      return 0;
    }
    try{
      List<Map<dynamic, dynamic>>? list = await dbHelper!.queryAllRowsFromFriendInfo(email);
      if(list == null) {
        return 0;
      }
      int length = list.length;
      return length;
    }
    catch(e) {
      debugPrint(e.toString());
      return 0;
    }
  }


  Future<List<FriendInfo>?> getAllFriends() async {
    late List<Map<dynamic, dynamic>>? list;
    List<FriendInfo> friendList = <FriendInfo>[];

    if(email == null || email == ''){
      FriendInfo friendInfo = FriendInfo();
      friendInfo.friendId = 'No Friends';
      friendInfo.loginUserEmail = 'No Friends';
      friendList. add(friendInfo);
      return await friendList;
    }
    list = await dbHelper!.queryAllRowsFromFriendInfo(email);
    if(list == null){
      FriendInfo friendInfo = FriendInfo();
      friendInfo.friendId = 'No Friends';
      friendInfo.loginUserEmail = email;
      friendList. add(friendInfo);
      return await friendList;
    }
    int length = list.length;
    for(int i=0; i<length; i++){
      Map<dynamic, dynamic> tmpMap = list.elementAt(i);
      FriendInfo friendInfo = FriendInfo();
      friendInfo.friendId = tmpMap[DBHelper.cFriendId];
      friendInfo.loginUserEmail = tmpMap[DBHelper.cLoginUserEmail];
      friendInfo.friendName = tmpMap[DBHelper.cFriendName];
      friendInfo.imageFile = getStringImageFilePath(tmpMap[DBHelper.cImageFile]);
      friendInfo.lastMessage = tmpMap[DBHelper.cLastMessage];
      friendInfo.date = tmpMap[DBHelper.cDate];
      friendInfo.activeStatus = convertActiveStatus(tmpMap[DBHelper.cActiveStatus]);
      friendList.add(friendInfo);
    }
    return await friendList;
  }


  String getStringImageFilePath(String imageFile){
    if(imageFile == null) {
      return defaultUserImagePath;
    }
    else if(imageFile == '') {
      return defaultUserImagePath;
    }
    else if(imageFile == 'No Image' || imageFile == 'Not Set') {
      return defaultUserImagePath;
    }
    return 'assets/images/friends/' + imageFile.toString();
  }


  bool convertActiveStatus(String activeStatus){
    if(activeStatus == 'true') {
      return true;
    }
    return false;
  }
}



class FriendInfo {
  String friendId = '';
  String loginUserEmail = '';
  String friendName = '';
  String imageFile = '';
  String lastMessage = '';
  String date = '';
  bool activeStatus = false;
}