import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:messaging_app/screens/constants.dart';
import 'package:messaging_app/functions/UserHandler.dart';
import 'package:messaging_app/screens/settings/profile/EditProfile.dart';
import 'package:messaging_app/screens/settings/profile/qrcode/ScanQRcode.dart';


class QRcodePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserHandler(FirebaseAuth.instance),
      child: QRcodePageApps(),
    );
  }
}



class QRcodePageApps extends StatefulWidget {
  @override
  _QRcodePageAppState createState() => _QRcodePageAppState();
}



class _QRcodePageAppState extends State<QRcodePageApps> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Texting Apps',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: buildSettingAppBar(context),
        body: buildQRPagebody(context),
      ),
    );
  }


  Widget buildQRPagebody(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          getQRImage(),
          Container (
            width: 300,
            child: Text('Your friend will add you as a friend when your friend scans this QR code.'),
          ),
          getScanButton(),
        ],
      ),
    );
  }


  Widget getScanButton() {
    return Container(
      child: GestureDetector(
        onTapDown: (TapDownDetails tapDownDetails) async {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ScanQRcode(),
            ),
          );
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.0),
          child: Image.asset('assets/images/scan-qrcode.png'),
        ),
      ),
    );
  }


  Widget getQRImage() {
    return QrImage(
      data: 'Texting Apps QR Code',
      version: QrVersions.auto,
      size: 320,
      gapless: false,
      errorStateBuilder: (cxt, err) {
        return Container(
          child: Center(
            child: Text(
              'Something went wrong.',
              textAlign: TextAlign.center,
            ),
          ),
        );
      },
    );
  }


  AppBar buildSettingAppBar(BuildContext context) {
    return AppBar (
      leading: BackButton (
        color: Colors.white,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditProfile(),
              ),
            );
          }
      ),
      title: Text('My QR code'),
      backgroundColor: kTitleBackgroundColor,
      automaticallyImplyLeading: true,
    );
  }
}

