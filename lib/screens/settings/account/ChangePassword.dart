import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:messaging_app/screens/constants.dart';
import 'package:messaging_app/functions/LoginHandler.dart';
import 'package:messaging_app/screens/login/LoginPage.dart';
import 'package:messaging_app/functions/PasswordHandler.dart';
import 'package:messaging_app/repository/AppUserInfo.dart';
import 'package:messaging_app/screens/settings/SettingPage.dart';


class ChangePassword extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PasswordHandler(FirebaseAuth.instance),
      child: ChangePasswordApp(),
    );
  }
}

class ChangePasswordApp extends StatefulWidget {
  @override
  _ChangePasswordAppState createState() => _ChangePasswordAppState();
}


class _ChangePasswordAppState extends State<ChangePasswordApp> {
  User? user = FirebaseAuth.instance.currentUser;
  AppUserInfo appUserInfo = AppUserInfo();

  @override
  Widget build(BuildContext context) {
    PasswordHandler pHandler = context.read<PasswordHandler>();
    LoginHandler lHandler = context.read<LoginHandler>();
    appUserInfo.setUser(user!);

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
                'Are you sure that we\'ll send an email to you to change the password?',
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
                appUserInfo.getEmail(),
                style: TextStyle(fontSize: 20),
              ),
            ),
            Container (
              width: 400.0,
              height: 60.0,
            ),
            GestureDetector(
              onTapDown: (TapDownDetails tapDownDetails) async {
                String result = await pHandler.sendEmailForPasswordReset(appUserInfo.getEmail());

                if (result == 'Successful') {
                  debugPrint('Sent Email.');
                  lHandler.logOut();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Sent Email.'),
                    ),
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginPage(),
                    ),
                  );
                }
                else if (result == 'ERROR_INVALID_EMAIL') {
                  debugPrint("ERROR_INVALID_EMAIL");
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Invalid Email.'),
                    ),
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SettingPage(),
                    ),
                  );
                }
                else if (result == 'ERROR_USER_NOT_FOUND') {
                  debugPrint("ERROR_USER_NOT_FOUND");
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Wrong Email.'),
                    ),
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SettingPage(),
                    ),
                  );
                }
                else {
                  debugPrint("Something went wrong.");
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Cannot send email.'),
                    ),
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SettingPage(),
                    ),
                  );
                }
              },
              child: Container(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: Image.asset('assets/images/send-email.png'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  AppBar buildSettingAppBar(BuildContext context) {
    return AppBar (
      leading: BackButton (
        color: Colors.white,
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text('Change Password'),
      backgroundColor: kTitleBackgroundColor,
      automaticallyImplyLeading: true,
    );
  }
}