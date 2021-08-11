import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:messaging_app/functions/FriendHandler.dart';
import 'package:messaging_app/repository/AppUserInfo.dart';
import 'package:messaging_app/repository/Message.dart';
import 'package:messaging_app/screens/Constants.dart';


class BuildMessageListView extends StatelessWidget {
  Message message;
  AppUserInfo? appUserInfo;
  FriendInfo? friendInfo;

  BuildMessageListView({
    Key? key,
    required this.appUserInfo,
    required this.friendInfo,
    required this.message,
  }) : super(key: key);


  /**
   * Caution: Not yet implemented
   *  MessageType.video
   *  MessageType.autio
   */
  @override
  Widget build(BuildContext context) {
    Widget getMessages(Message message) {
      switch (message.messageType) {
        case MessageType.text:
          return TextMessage(message: message);
        case MessageType.image:
          return ImageMessage(message: message);
        default:
          return SizedBox();
      }
    }

    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: SizedBox(
        width: 400,
        child: SingleChildScrollView(
          child: Row(
            mainAxisAlignment: message.isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              if (!message.isSender) ...[
                  CircleAvatar(
                    radius: 18,
                    backgroundImage: AssetImage(friendInfo!.imageFile),
                  ),
                  SizedBox(width: 10),
                ],
              getMessages(message),
              if (message.isSender) ... [
                SizedBox(width: 10),
                CircleAvatar(
                  radius: 18,
                  backgroundImage: AssetImage(appUserInfo!.getPhotoURL()), // Need null check
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}

class ImageMessage extends StatelessWidget {
  const ImageMessage({
    Key? key,
    this.message,
  }) : super(key: key);

  final Message? message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 10,
      ),
      child: Image.asset(
          message!.text,
          width: 100,
          height: 100,
        ),
    );
  }

}



class TextMessage extends StatelessWidget {
  const TextMessage({
    Key? key,
    this.message,
  }) : super(key: key);

  final Message? message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: kPrimaryColor.withOpacity(message!.isSender ? 1 : 0.1),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        message!.text,
        style: TextStyle(
          color: message!.isSender ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}

/**
 * Demo Message
 **/
List demoMessages = [
  /*
  Message(
    text: 'Hi. What\'s up?',
    messageType: MessageType.text,
    messageStatus: MessageStatus.viewed,
    isSender: false,
  */
];


