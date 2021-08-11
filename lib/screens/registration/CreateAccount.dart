import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:messaging_app/screens/constants.dart';
import 'package:messaging_app/functions/DBHelper.dart';
import 'package:messaging_app/screens/login/LoginPage.dart';
import 'package:messaging_app/functions/AccountHandler.dart';


class CreateAccount extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider (
      create: (context) => AccountHandler(FirebaseAuth.instance),
      child: CreateAccountApps(),
    );
  }
}


class CreateAccountApps extends StatefulWidget {
  @override
  _CreateAccountAppsState createState() => _CreateAccountAppsState();
}


class _CreateAccountAppsState extends State<CreateAccountApps> {
  final dbHelper = DBHelper.instance;

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    FocusNode myFocusNode1 = new FocusNode();
    FocusNode myFocusNode2 = new FocusNode();
    AccountHandler handler = context.read<AccountHandler>();

    return Scaffold(
        backgroundColor: kCreateAccountBGColor,
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
                    child: Center (
                      child: Container(
                        child: Image.asset('assets/images/create-account.png'),
                      ),
                    )
                  ),
                  Stack (
                    children: <Widget>[
                      Column (
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Container(
                            width: 400.0,
                            child: new TextFormField(
                              autofocus: false,
                              focusNode: myFocusNode1,
                              style: new TextStyle(
                                fontSize: 21.0,
                                height: 1.6,
                                color: Colors.black
                              ),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Email',
                                labelStyle: TextStyle(
                                  color: myFocusNode1.hasFocus ? Colors.blue : Colors.black
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                focusedBorder:OutlineInputBorder(
                                  borderSide: const BorderSide(color: Colors.white, width: 2.0),
                                ),
                                hintText: 'Enter your email.'
                              ),
                              validator: handler.emptyEmailChecker,
                              onSaved: (value) => handler.email = value!,
                            ),
                          ),
                          Container(
                            width: 400.0,
                            height: 15.0,
                          ),
                          Container(
                            width: 400.0,
                            child: new TextFormField(
                              autofocus: false,
                              obscureText: true,
                              focusNode: myFocusNode2,
                              style: new TextStyle(
                                fontSize: 21.0,
                                height: 1.6,
                                color: Colors.black
                              ),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Password',
                                labelStyle: TextStyle(
                                  color: myFocusNode2.hasFocus ? Colors.blue : Colors.black
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                focusedBorder:OutlineInputBorder(
                                  borderSide: const BorderSide(color: Colors.white, width: 2.0),
                                ),
                                hintText: 'Enter your secure password.'
                              ),
                              validator: handler.emptyPasswordChecker,
                              onSaved: (value) => handler.password = value!,
                            ),
                          ),
                          Container(
                          width: 400.0,
                          height: 20.0,
                          ),
                          GestureDetector (
                            onTapDown: (TapDownDetails tapDownDetails) async {
                              handler.setMessage('');
                              FocusScope.of(context).requestFocus(FocusNode());

                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                var response = await handler.isEmail();

                                if(response) {
                                  handler.setMessage('You cannot use this email.');
                                }
                                else {
                                  var flag = await handler.createAccount();
                                  _insertData(handler.email);
                                  if(flag) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Check your Email and verify.'),
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
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                      content: Text('You cannot create your account.'),
                                      ),
                                    );
                                  }
                                }
                              }
                            },
                            child: Container(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16.0),
                                child: Image.asset(
                                  'assets/images/create-button.png'
                                ),
                              ),
                            ),
                          ),
                          Container (
                          width: 400.0,
                          height: 60.0,
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 16, 0, 8),
                            child: Text(
                              handler.message,
                              style: TextStyle(
                                fontSize: 16,
                                color: kForgetPasswordMColor,
                              ),
                            ),
                          ),
                          Container (
                            width: 400.0,
                            height: 60.0,
                          ),
                          Container (
                            child: (
                              TextButton (
                                style: flatButtonStyle,
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => LoginPage(),
                                    ),
                                  );
                                },
                                child: Text('Login'),
                              )
                            ),
                          ),
                          Container (
                            width: 400.0,
                            height: 10.0,
                          ),
                        ]
                      ),
                    ]
                  ),
                ]
              )
            )
          )
        )
    );
  }


  void _insertData(String email) async {
    Map<String, dynamic> row = {
      DBHelper.cEmail : email,
      DBHelper.cStatusMessage  : 'Not Set',
    };
    final id = await dbHelper!.insert(row);
  }


  final ButtonStyle flatButtonStyle = TextButton.styleFrom(
    primary: Color.fromRGBO(234, 201, 71, 1.0),
    minimumSize: Size(160, 40),
    padding: EdgeInsets.symmetric(horizontal: 16.0),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(2.0)),
    ),
  );
}