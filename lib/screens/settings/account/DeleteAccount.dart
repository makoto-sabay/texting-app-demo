import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:messaging_app/functions/DBHelper.dart';
import 'package:messaging_app/functions/LoginHandler.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:messaging_app/screens/constants.dart';
import 'package:messaging_app/screens/login/LoginPage.dart';
import 'package:messaging_app/functions/AccountHandler.dart';
import 'package:messaging_app/repository/AppUserInfo.dart';
import 'package:messaging_app/screens/settings/SettingPage.dart';


class DeleteAccount extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AccountHandler(FirebaseAuth.instance),
      child: DeleteAccountApp(),
    );
  }
}

class DeleteAccountApp extends StatefulWidget {
  @override
  _DeleteAccountAppState createState() => _DeleteAccountAppState();
}


class _DeleteAccountAppState extends State<DeleteAccountApp> {
  final DBHelper? dbHelper = DBHelper.instance;
  User? user = FirebaseAuth.instance.currentUser;
  AppUserInfo appUserInfo = AppUserInfo();

  @override
  Widget build(BuildContext context) {
    LoginHandler lHandler = context.read<LoginHandler>();
    AccountHandler aHandler = context.read<AccountHandler>();
    appUserInfo.setUser(user!);
    var email = appUserInfo.getEmail();

    return Scaffold(
      appBar: buildSettingAppBar(context),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(
              'Caution',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: kCautionColor,
              ),
            ),
            Container (
              width: 400.0,
              height: 60.0,
            ),
            Container (
              width: 300.0,
              height: 120.0,
              child: Text(
                'Are you sure that you want to delete your account? You cannot restore it.',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            Container (
              width: 400.0,
              height: 60.0,
            ),
            FittedBox(
              fit: BoxFit.fitWidth,
              child: Text(
                email,
                style: TextStyle(fontSize: 20),
              ),
            ),
            Container (
              width: 400.0,
              height: 60.0,
            ),
            GestureDetector(
              onTapDown: (TapDownDetails tapDownDetails) async {
                deleteAccount(aHandler, lHandler, email);
              },
              child: Container(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: Image.asset('assets/images/delete-account.png'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  void deleteAccount(AccountHandler aHandler, LoginHandler lHandler, String email) async{
    String result = await aHandler.deleteAccount(user);

    if (result == 'Successful') {
      dbHelper!.deleteUserStatusData(email);
      dbHelper!.deleteFriendInfo(email);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ),
      );
    }
    else if (result == 'Error') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error occurred.'),
        ),
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SettingPage(),
        ),
      );
    }
    else if (result == 'null') {
      debugPrint("ERROR_USER_NOT_FOUND");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('User Not Found'),
        ),
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ),
      );
    }
    else {
      debugPrint("Something went wrong.");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Cannot delete.'),
        ),
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SettingPage(),
        ),
      );
    }
  }

  AppBar buildSettingAppBar(BuildContext context) {
    return AppBar (
      leading: BackButton (
        color: Colors.white,
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text('Delete Account'),
      backgroundColor: kTitleBackgroundColor,
      automaticallyImplyLeading: true,
    );
  }
}