import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:messaging_app/screens/constants.dart';
import 'package:messaging_app/functions/UserHandler.dart';
import 'package:messaging_app/screens/settings/SettingPage.dart';
import 'package:messaging_app/screens/settings/profile/EditProfile.dart';


class DisplayName extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserHandler(FirebaseAuth.instance),
      child: DisplayNameApps(),
    );
  }
}


class DisplayNameApps extends StatefulWidget {
  @override
  _DisplayNameAppsState createState() => _DisplayNameAppsState();
}


class _DisplayNameAppsState extends State<DisplayNameApps> {
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    FocusNode myFocusNode = new FocusNode();
    UserHandler handler = context.read<UserHandler>();

    return Scaffold (
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(55),
        child: buildSettingAppBar(context),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: SingleChildScrollView (
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Padding (
                  padding: const EdgeInsets.only(
                    left: 0, right: 0, top: 60.0, bottom: 20.0
                  ),
                ),
                Container(
                  width: 300.0,
                  child: Center(
                    child: new TextFormField(
                      autofocus: false,
                      focusNode: myFocusNode,
                      initialValue: handler.getDisplayName(),
                      style: new TextStyle(
                        fontSize: 21.0,
                        height: 1.6,
                        color: Colors.black
                      ),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelStyle: TextStyle(
                          color: myFocusNode.hasFocus ? Colors.blue : Colors.black
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        focusedBorder:OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white, width: 2.0),
                        ),
                        hintText: 'Enter your display name.'
                      ),
                      validator: handler.emptyDisplayNameChecker,
                      onSaved: (value) => handler.displayName = value!,
                    ),
                  ),
                ),
                Container (
                  width: 400.0,
                  height: 20.0,
                ),
                GestureDetector (
                  onTapDown: (TapDownDetails tapDownDetails) async {
                    handler.setMessage('');
                    FocusScope.of(context).requestFocus(FocusNode());
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      String result = await handler.updateDisplayName();

                      if (result == 'Successful') {
                        showSaveDispNameDialog();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Successful.'),
                          ),
                        );
                      }
                      else if (result == 'Not Set') {
                        debugPrint("Not Set");
                        handler.setMessage('Please enter your display name.');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Not Set'),
                          ),
                        );
                      }
                      else if (result == 'USER NOT FOUND') {
                        debugPrint("ERROR_USER_NOT_FOUND");
                        handler.setMessage('Wrong Email.');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('USER NOT FOUND'),
                          ),
                        );
                      }
                      else {
                        debugPrint("Something went wrong.");
                        handler.setMessage('Cannot set your display name.');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Cannot set your display name.'),
                          ),
                        );
                      }
                    }
                  },
                  child: Container(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16.0),
                      child: Image.asset(
                          'assets/images/save-app-info.png'
                      ),
                    ),
                  ),
                ),
              ]
            ),
          ),
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
              builder: (context) => EditProfile(),
            ),
          );
        }
      ),
      title: Text('Display Name'),
      backgroundColor: kTitleBackgroundColor,
      automaticallyImplyLeading: true,
    );
  }


  Future<Null> showSaveDispNameDialog() async {
    String returnStr = await showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text('Notice'),
          content: Text('Your display name has changed.'),
          actions: <Widget>[
            OutlinedButton(
              child: Text('OK'),
              onPressed: () => Navigator.of(context, rootNavigator: true).pop('OK'),
            ),
          ],
        );
      },
    );
    debugPrint("$returnStr");
    if(returnStr == null){
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SettingPage(),
        ),
      );
    }
    else if(returnStr == 'OK'){
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditProfile(),
        ),
      );
    }
    else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditProfile(),
        ),
      );
    }
  }
}