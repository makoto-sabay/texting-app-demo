import 'package:flutter/material.dart';
import 'package:messaging_app/screens/constants.dart';
import 'package:messaging_app/repository/AppUserInfo.dart';
import 'package:messaging_app/functions/FriendHandler.dart';
import 'package:messaging_app/screens/message/BuildMessageListView.dart';


class MessagePage extends StatelessWidget {
  AppUserInfo? appUserInfo;
  FriendInfo? friendInfo;

  MessagePage(AppUserInfo aInfo, FriendInfo fInfo) {
    this.appUserInfo = aInfo;
    this.friendInfo = fInfo;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: buildMessagePageBody(),
    );
  }


  Widget buildMessagePageBody() {
    return Column (
      children: [
        buildAllMessages(),
        InputTextBox(),
      ],
    );
  }


  Widget buildAllMessages() {
    return Expanded (
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView.builder(
          itemCount: demoMessages.length,
          itemBuilder: (context, index) =>
            BuildMessageListView(
                appUserInfo: appUserInfo,
                friendInfo: friendInfo,
                message: demoMessages[index],
            ),
        ),
      ),
    );
  }


  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: friendPageColor,
      automaticallyImplyLeading: true,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage: AssetImage(friendInfo!.imageFile),
          ),
          SizedBox(
            width: kAppsPadding
          ),
          Text(
            friendInfo!.friendName,
            style: TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }
}



class InputTextBox extends StatelessWidget {
  const InputTextBox({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: kAppsPadding,
        vertical: kAppsPadding / 2,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 4),
            blurRadius: 24,
            color: friendPageColor.withOpacity(0.25),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: kAppsPadding,
                ),
                decoration: BoxDecoration(
                  color: friendPageColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Write a Message',
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.send_rounded, color: friendPageColor),
              onPressed: () {
                // Not yet implemented
              },
            ),
            IconButton(
              icon: Icon(Icons.mic_rounded, color: friendPageColor),
              onPressed: () {
                // Not yet implemented
              },
            )
          ],
        ),
      ),
    );
  }
}