import 'package:flutter/material.dart';
import 'package:messaging_app/screens/index/IndexPage.dart';
import 'package:messaging_app/screens/friends/FriendsListPage.dart';
import 'package:messaging_app/screens/settings/AboutThisApp.dart';
import 'package:messaging_app/screens/settings/account/Account.dart';
import 'package:messaging_app/screens/settings/profile/EditProfile.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:messaging_app/screens/constants.dart';
import 'package:messaging_app/functions/LoginHandler.dart';
import 'package:messaging_app/screens/login/LoginPage.dart';



class SettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LoginHandler(FirebaseAuth.instance),
      child: SettingPageApps(),
    );
  }
}

class SettingPageApps extends StatefulWidget {
  @override
  _SettingPageApps createState() => _SettingPageApps();
}

class _SettingPageApps extends State<SettingPageApps> {
  final List<String> entries = <String>[
    'Edit Profile',
    'Account',
    'About this app',
    'Log out'
  ];
  final List<Icon> iconsList = <Icon>[
    Icon(Icons.person_rounded),
    Icon(Icons.manage_accounts_rounded),
    Icon(Icons.perm_device_information_rounded),
    Icon(Icons.logout)
  ];
  int _selectedIndex = 2;

  @override
  Widget build(BuildContext context) {
    LoginHandler handler = context.read<LoginHandler>();

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
                leading: iconsList.elementAt(index),
                title: Text(entries.elementAt(index)),
                onTap: () {
                  switch(index) {
                    case 0: {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditProfile(),
                        ),
                      );
                    }
                    break;

                    case 1: {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Account(),
                        ),
                      );
                    }
                    break;

                    case 2: {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AboutThisAppPage(),
                        ),
                      );
                    }
                    break;

                    case 3: {
                      showLogOutDialog(handler);
                    }
                    break;
                    Navigator.of(context).pop();
                  }
                },
              )
            );
          },
        ),
        bottomNavigationBar: buildAppBottomNavigationBar(),
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
              builder: (context) => IndexPage(),
            ),
          );
        }
      ),
      title: Text('Settings'),
      backgroundColor: kTitleBackgroundColor,
      automaticallyImplyLeading: true,
    );
  }


  Future<Null> showLogOutDialog(LoginHandler handler) async {
    String returnStr = await showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text('Logout'),
          content: Text('Are you sure that you want to log out?'),
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

    }
    else if(returnStr == 'No'){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Canceled.'),
        ),
      );
    }
    else if(returnStr == 'Yes') {
      handler.logOut();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Logout Successful'),
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
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Account(),
        ),
      );
    }
  }


  BottomNavigationBar buildAppBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _selectedIndex,
      onTap: (value) {
        setState(() {
          _selectedIndex = value;
        });
        switch(_selectedIndex) {
          case 0: {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => IndexPage(),
              ),
            );
          }
          break;

          case 1: {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FriendsListPage(),
              ),
            );
          }
          break;

          case 2:{
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SettingPage(),
              ),
            );
          }
          break;
        }
      },
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.people_alt_rounded), label: "Friends"),
        BottomNavigationBarItem(icon: Icon(Icons.settings_rounded), label: "Settings"),
//      BottomNavigationBarItem(icon: Icon(Icons.call), label: "Calls"),
      ],
    );
  }
}