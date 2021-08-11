import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:messaging_app/screens/constants.dart';
import 'package:messaging_app/functions/DBHelper.dart';
import 'package:messaging_app/functions/UserHandler.dart';
import 'package:messaging_app/repository/AppUserInfo.dart';
import 'package:messaging_app/screens/settings/profile/EditProfile.dart';


class StatusMessage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserHandler(FirebaseAuth.instance),
      child: StatusMessageApps(),
    );
  }
}


class StatusMessageApps extends StatefulWidget {
  @override
  _StatusMessageAppsState createState() => _StatusMessageAppsState();
}



class _StatusMessageAppsState extends State<StatusMessageApps> {
  final DBHelper? dbHelper = DBHelper.instance;
  User? user = FirebaseAuth.instance.currentUser;
  AppUserInfo appUserInfo = AppUserInfo();

  @override
  Widget build(BuildContext context) {
    appUserInfo.setUser(user!);

    return Scaffold (
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(55),
        child: buildStatusMessageBar(context),
      ),
      body: Center(
        child: FutureBuilder<String>(
          future: dbHelper!.getStatusMessage(appUserInfo.email),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            return StatusMessageBody(context);
          }
        )
      ),
    );
  }

  AppBar buildStatusMessageBar(BuildContext context) {
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
      title: Text('Status Message'),
      backgroundColor: kTitleBackgroundColor,
      automaticallyImplyLeading: true,
    );
  }


  Future<Null> showSaveDispStatusMessageDialog() async {
    String returnStr = await showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text('Notice'),
          content: Text('Your status message has changed.'),
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
    if(returnStr == 'OK'){
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


  Widget StatusMessageBody(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    FocusNode myFocusNode = new FocusNode();
    UserHandler handler = context.read<UserHandler>();
    String email = appUserInfo.email;

    return Scaffold (
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
                            hintText: 'Enter your current status.'
                        ),
                        //validator: handler.emptyStatusMessageChecker,
                        onSaved: (value) => handler.message = value!,
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
                        String result = await updateCurrentStatus(email, handler.message);

                        if (result == 'Successful') {
                          showSaveDispStatusMessageDialog();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Successful.'),
                            ),
                          );
                        }
                        else if (result == 'Failed') {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Cannot update your status.'),
                            ),
                          );
                        }
                        else {
                          debugPrint("Something went wrong.");
                          handler.setMessage('Cannot set your status message.');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Cannot set your status message.'),
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


  Future<String> updateCurrentStatus(String email, String statusMessage) async {
    int updateRow = 0;
    int insertRow = 0;
    if(email == null || email == ''){
      return 'Failed';
    }
    updateRow = await dbHelper!.updateStatusMessage(email, statusMessage);

    if(updateRow == 0) {
      insertRow = await dbHelper!.insertStatusMessage(email, statusMessage);
      if(insertRow == 0) {
        return 'Failed';
      }
    }
    return 'Successful';
  }
}

