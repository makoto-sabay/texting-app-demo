import 'package:flutter/material.dart';
import 'package:messaging_app/repository/AppUserInfo.dart';
import 'package:messaging_app/screens/constants.dart';
import 'package:messaging_app/functions/FriendHandler.dart';
import 'package:messaging_app/screens/message/MessagePage.dart';


class FriendPage extends StatelessWidget {
  FriendInfo? friendInfo;
  AppUserInfo? appUserInfo;

  FriendPage(AppUserInfo uInfo, FriendInfo fInfo){
    this.appUserInfo = uInfo;
    this.friendInfo = fInfo;
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Texting Apps',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: buildFriendPageBar(context),
        body: buildFriendPageBody(context),
      ),
    );
  }

  Widget buildFriendPageBody(BuildContext context) {
    return Container(
      child: Column (
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          getFriendImage(context),
          getFriendName(context),
          buildButton(context),
        ],
      ),
    );
  }


  Widget getFriendImage(BuildContext context) {
    String imageFile = friendInfo!.imageFile;
    if(imageFile == '' || imageFile == 'Not Set') {
      imageFile = defaultUserImagePath;
    }
    return Center (
      child: SizedBox(
        width: 180,
        height: 180,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.0),
          child: Image.asset(imageFile),
        ),
      ),
    );
  }


  Widget getFriendName(BuildContext context) {
    return Center (
      child: Text(
        friendInfo!.friendName,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }


  Widget buildButton(BuildContext context) {
    return Center (
      child: SizedBox(
        width: 300,
        child: GestureDetector(
          onTapDown: (TapDownDetails tapDownDetails) async {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MessagePage(appUserInfo!, friendInfo!),
              ),
            );
          },
          child: Container(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: Image.asset('assets/images/text-your-friend.png'),
            ),
          ),
        ),
      ),
    );
  }


  AppBar buildFriendPageBar(BuildContext context) {
    return AppBar (
      leading: BackButton (
        color: Colors.white,
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text('Your Friend'),
      backgroundColor: friendPageColor,
      automaticallyImplyLeading: true,
    );
  }
}
