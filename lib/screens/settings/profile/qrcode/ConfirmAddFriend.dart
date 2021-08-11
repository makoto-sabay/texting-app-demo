import 'package:flutter/material.dart';
import 'package:messaging_app/screens/settings/profile/qrcode/ScanQRcode.dart';


class ConfirmAddFriend extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To confirm the scan results'),
      ),
      body: _buildConfirmAddFriend(context),
    );
  }

  Widget _buildConfirmAddFriend(BuildContext context) {
    final arguments =
    ModalRoute.of(context)!.settings.arguments as ConfirmAddFriendArguments?;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text('Type: ${arguments!.type} Data: ${arguments.data}'),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Scan again'),
          ),
          ElevatedButton(
            // これまでのstackを削除して最初の画面に戻る
            onPressed: () => Navigator.pushNamedAndRemoveUntil(
                context, 'EditProfile', (route) => false),
            child: const Text('Back to first page'),
          ),
        ],
      ),
    );
  }
}