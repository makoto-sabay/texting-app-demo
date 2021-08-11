import 'package:flutter/material.dart';
import 'package:messaging_app/screens/constants.dart';
import 'package:messaging_app/screens/settings/SettingPage.dart';
import 'package:messaging_app/screens/settings/account/ChangePassword.dart';
import 'package:messaging_app/screens/settings/account/DeleteAccount.dart';

class Account extends StatefulWidget {
  @override
  _AccountState createState() => _AccountState();
}


class _AccountState extends State<Account> {
  final List<String> entries = <String>[
    'Change Password',
    'Delete Account',
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Texting Apps',
      debugShowCheckedModeBanner: false,
      home: Scaffold (
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
                onTap: () {
                  switch (index) {
                    case 0: {
                      showChangePasswordDialog();
                    }
                    break;
                    case 1: {
                      showDeleteAccountDialog();
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

  Future<Null> showChangePasswordDialog() async {
    String returnStr = await showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text('Alert'),
          content: Text('Would you like to change your password?'),
          actions: <Widget>[
            OutlinedButton(
              child: Text('No'),
              onPressed: () => Navigator.of(context, rootNavigator: true).pop('No'),
            ),
            OutlinedButton(
              child: Text('Yes'),
              onPressed: () => Navigator.of(context, rootNavigator: true).pop('Yes'),
            ),
          ],
        );
      },
    );
    if(returnStr == null){
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Account(),
        ),
      );
    }
    else if(returnStr == 'No'){
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SettingPage(),
        ),
      );
    }
    else if(returnStr == 'Yes') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChangePassword(),
        ),
      );
    }
    else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Account(),
        ),
      );
    }
  }


  Future<Null> showDeleteAccountDialog() async {
    String returnStr = await showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text('Alert'),
          content: Text('Are you sure that you want to delete your account?'),
          actions: <Widget>[
            OutlinedButton(
              child: Text('No'),
              onPressed: () => Navigator.of(context, rootNavigator: true).pop('No'),
            ),
            OutlinedButton(
              child: Text('Yes'),
              onPressed: () => Navigator.of(context, rootNavigator: true).pop('Yes'),
            ),
          ],
        );
      },
    );
    if(returnStr == null){
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Account(),
        ),
      );
    }
    else if(returnStr == 'No'){
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SettingPage(),
        ),
      );
    }
    else if(returnStr == 'Yes') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DeleteAccount(),
        ),
      );
    }
    else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Account(),
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
      title: Text('Account'),
      backgroundColor: kTitleBackgroundColor,
      automaticallyImplyLeading: true,
    );
  }



}