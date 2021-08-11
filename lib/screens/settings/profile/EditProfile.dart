import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:messaging_app/screens/constants.dart';
import 'package:messaging_app/functions/DBHelper.dart';
import 'package:messaging_app/functions/UserHandler.dart';
import 'package:messaging_app/repository/AppUserInfo.dart';
import 'package:messaging_app/screens/settings/SettingPage.dart';
import 'package:messaging_app/screens/settings/profile/DisplayName.dart';
import 'package:messaging_app/screens/settings/profile/StatusMessage.dart';
import 'package:messaging_app/screens/settings/profile/SetProfileIcon.dart';
import 'package:messaging_app/screens/settings/profile/qrcode/QRcodePage.dart';


class EditProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserHandler(FirebaseAuth.instance),
      child: EditProfileApps(),
    );
  }
}

class EditProfileApps extends StatefulWidget {
  @override
  _EditProfileAppState createState() => _EditProfileAppState();
}


class _EditProfileAppState extends State<EditProfileApps> {
  final dbHelper = DBHelper.instance;
  String _StatuMessage = '';
  AppUserInfo appUserInfo = AppUserInfo();

  _EditProfileAppState() {
    User? user = FirebaseAuth.instance.currentUser;
    appUserInfo.setUser(user!);
    getCurrentStatusMessage(appUserInfo.email).then((val) => setState(() {
      _StatuMessage = val;
    }));
  }

  final List<String> entries = <String>[
    'Display Name',
    'Status Message',
    'Set profile icon',
    'QR code'
  ];


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Texting Apps',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: buildSettingAppBar(context),
        body: ListView.builder (
          padding: const EdgeInsets.all(8),
          physics: BouncingScrollPhysics(),
          itemCount: entries.length,
          itemBuilder: (BuildContext context, int index) {
            return Container (
              height: 60,
              child: ListTile (
                title: Text(entries.elementAt(index)),
                subtitle: Text(
                  getProfileList(appUserInfo).elementAt(index),
                  style: TextStyle(
                    color: kSubTitleListColor,
                  ),
                ),
                onTap: () {
                  switch (index) {
                    case 0:
                      {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DisplayName(),
                          ),
                        );
                      }
                      break;

                    case 1:
                      {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StatusMessage(),
                          ),
                        );
                      }
                      break;

                    case 2:
                      {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SetProfileIcon(),
                          ),
                        );
                      }
                      break;

                    case 3:
                      {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => QRcodePage(),
                          ),
                        );
                      }
                      break;
                  }
                }
              )
            );
          }
        ),
      ),
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
              builder: (context) => SettingPage(),
            ),
          );
        }
      ),
      title: Text('Edit Profile'),
      backgroundColor: kTitleBackgroundColor,
      automaticallyImplyLeading: true,
    );
  }


  Future<String> getCurrentStatusMessage(String email) async {
    return await dbHelper!.getStatusMessage(email);
  }


  List<String> getProfileList(AppUserInfo appUserInfo){
    var DispName = 'Not Set';
    var StatusMessage = 'Not Set';
    var ProfIcon = 'Not Set';
    var QRcode = '';

    if(appUserInfo == null) {

    }
    else {
      DispName = appUserInfo.getDisplayName();
      StatusMessage = _StatuMessage;
      ProfIcon = appUserInfo.getPhotoURL();
    }

    final List<String> subEty = <String>[
      DispName,
      StatusMessage,
      ProfIcon,
      QRcode
    ];
    return subEty;
  }
  
}