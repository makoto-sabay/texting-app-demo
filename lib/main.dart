import 'package:flutter/material.dart';
import 'package:messaging_app/functions/DBHelper.dart';
import 'package:messaging_app/screens/settings/account/ChangePassword.dart';
import 'package:messaging_app/screens/settings/account/DeleteAccount.dart';
import 'package:messaging_app/screens/settings/profile/DisplayName.dart';
import 'package:messaging_app/screens/settings/profile/EditProfile.dart';
import 'package:messaging_app/screens/settings/profile/StatusMessage.dart';
import 'package:messaging_app/screens/settings/profile/qrcode/QRcodePage.dart';
import 'package:messaging_app/screens/settings/profile/qrcode/ScanQRcode.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:messaging_app/functions/LoginHandler.dart';
import 'package:messaging_app/screens/password/ForgetPassword.dart';
import 'package:messaging_app/screens/registration/CreateAccount.dart';
import 'package:messaging_app/screens/settings/SettingPage.dart';
import 'package:messaging_app/screens/error/TextingAppErrorPage.dart';
import 'package:messaging_app/screens/title/LoadingApps.dart';
import 'package:messaging_app/screens/index/IndexPage.dart';
import 'package:messaging_app/screens/login/LoginPage.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        Provider<LoginPage>(create: (_) => LoginPage()),
        Provider<ForgetPassword>(create: (_) => ForgetPassword()),
        Provider<CreateAccount>(create: (_) => CreateAccount()),
        Provider<IndexPage>(create: (_) => IndexPage()),
        Provider<SettingPage>(create: (_) => SettingPage()),
        Provider<ChangePassword>(create: (_) => ChangePassword()),
        Provider<DeleteAccount>(create: (_) => DeleteAccount()),
        Provider<EditProfile>(create: (_) => EditProfile()),
        Provider<DisplayName>(create: (_) => DisplayName()),
        Provider<StatusMessage>(create: (_) => StatusMessage()),
        Provider<QRcodePage>(create: (_) => QRcodePage()),
        Provider<ScanQRcode>(create: (_) => ScanQRcode()),
      ],
      child: TextingApps(),
    )
  );
}

class TextingApps extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp (
      debugShowCheckedModeBanner: false,
      home: TextingAppsMain(),
    );
  }
}


class TextingAppsMain extends StatelessWidget {
  final dbHelper = DBHelper.instance;
  LoginHandler handler = LoginHandler(FirebaseAuth.instance);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder (
        future: handler.isLoggedIn(context),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return LoadingApps();
          }

          if (snapshot.hasError) {
            return TextingAppErrorPage();
          }

          if (!snapshot.data) {
            return LoginPage();
          }
          else {
            return IndexPage();
          }
        }
    );
  }
}





