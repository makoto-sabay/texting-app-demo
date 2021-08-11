enum MessageType {
  text,
  audio,
  image,
  video
}

enum MessageStatus {
  notSent,
  notView,
  viewed
}

class Message {
  final String text;
  final MessageType messageType;
  final MessageStatus messageStatus;
  final bool isSender;

  Message({
    this.text = '',
    required this.messageType,
    required this.messageStatus,
    required this.isSender,
  });
}



