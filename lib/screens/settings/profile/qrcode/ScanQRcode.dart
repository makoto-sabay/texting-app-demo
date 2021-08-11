import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:messaging_app/screens/constants.dart';
import 'package:messaging_app/functions/UserHandler.dart';
import 'package:messaging_app/screens/settings/profile/EditProfile.dart';
import 'package:messaging_app/screens/settings/profile/qrcode/QRcodePage.dart';


class ScanQRcode extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserHandler(FirebaseAuth.instance),
      child: ScanQRcodeApps(),
    );
  }
}

class ScanQRcodeApps extends StatefulWidget {
  @override
  _ScanQRcodeAppsState createState() => _ScanQRcodeAppsState();
}

class _ScanQRcodeAppsState extends State<ScanQRcodeApps> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  bool _isScanned = false;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller?.pauseCamera();
    }
    else if (Platform.isIOS) {
      controller?.resumeCamera();
    }
  }


  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
      _transitionToNextScreen(describeEnum(scanData.format), scanData.code);
    });
  }


  Future<void> _transitionToNextScreen(String type, String data) async {
    if (!_isScanned) {
      controller?.pauseCamera();
      _isScanned = true;

      await Navigator.pushNamed(
        context,
        'ConfirmAddFriend',
        arguments: ConfirmAddFriendArguments(type: type, data: data),
      ).then(
        (value) {
          controller?.resumeCamera();
          _isScanned = false;
        },
      );
    }
  }


  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Texting Apps',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: buildQRAppBar(context),
        body: buildScanQRcodeBody(context),
      ),
    );
  }


  Widget buildScanQRcodeBody(BuildContext context) {
    return Center(
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          scanQRcode(),
          Container (
            width: 300,
            child: Text('You\'ll add your friend when you scan your friend\'s QR code.'),
          ),
          getMyQRcodeButton(),
        ],
      ),
    );
  }


  Widget scanQRcode() {
    return Container(
      height: 400,
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: (result != null)
                  ? Text('Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}')
                  : Text('Scan a code'),
            ),
          )
        ],
      ),
    );
  }


  Widget getMyQRcodeButton() {
    return Container(
      child: GestureDetector(
        onTapDown: (TapDownDetails tapDownDetails) async {
          dispose();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => QRcodePage(),
            ),
          );
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.0),
          child: Image.asset('assets/images/my-qrcode.png'),
        ),
      ),
    );
  }


  AppBar buildQRAppBar(BuildContext context) {
    return AppBar (
      leading: BackButton (
        color: Colors.white,
        onPressed: () {
          dispose();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditProfile(),
            ),
          );
        }
      ),
      title: Text('Scan QR code'),
      backgroundColor: kTitleBackgroundColor,
      automaticallyImplyLeading: true,
    );
  }
}

@immutable
class ConfirmAddFriendArguments {
  const ConfirmAddFriendArguments ({required this.type, required this.data});
  final String type;
  final String data;
}