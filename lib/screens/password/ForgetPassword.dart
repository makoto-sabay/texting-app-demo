import 'package:flutter/material.dart';
import 'package:messaging_app/screens/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:messaging_app/screens/login/LoginPage.dart';
import 'package:messaging_app/functions/PasswordHandler.dart';
import 'package:messaging_app/screens/registration/CreateAccount.dart';
import 'package:provider/provider.dart';

class ForgetPassword extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PasswordHandler(FirebaseAuth.instance),
      child: ForgetPasswordApps(),
    );
  }
}

class ForgetPasswordApps extends StatefulWidget {
  @override
  _ForgetPasswordApps createState() => _ForgetPasswordApps();
}


class _ForgetPasswordApps extends State<ForgetPasswordApps> {
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    FocusNode myFocusNode = new FocusNode();
    PasswordHandler handler = context.read<PasswordHandler>();

    return Scaffold(
      backgroundColor: kForgetPasswordBGColor,
      body: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: SingleChildScrollView (
              //reverse: true,
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
                                child: Image.asset('assets/images/forget-password.png'),
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
                                        focusNode: myFocusNode,
                                        style: new TextStyle(
                                            fontSize: 21.0,
                                            height: 1.6,
                                            color: Colors.black
                                        ),
                                        decoration: InputDecoration(
                                            border: OutlineInputBorder(),
                                            labelText: 'Email',
                                            labelStyle: TextStyle(
                                                color: myFocusNode.hasFocus ? Colors.blue : Colors.black
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
                                      height: 20.0,
                                    ),
                                    GestureDetector (
                                      onTapDown: (TapDownDetails tapDownDetails) async {
                                        handler.setMessage('');
                                        FocusScope.of(context).requestFocus(FocusNode());
                                        if (_formKey.currentState!.validate()) {
                                          _formKey.currentState!.save();
                                          String result = await handler.sendPasswordResetEmail();;

                                          if (result == 'Successful') {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text('Send Email.'),
                                              ),
                                            );
                                          }
                                          else if (result == 'ERROR_INVALID_EMAIL') {
                                            debugPrint("ERROR_INVALID_EMAIL");
                                            handler.setMessage('Wrong Email.');
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text('Wrong Email.'),
                                              ),
                                            );
                                          }
                                          else if (result == 'ERROR_USER_NOT_FOUND') {
                                            debugPrint("ERROR_USER_NOT_FOUND");
                                            handler.setMessage('Wrong Email.');
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text('Wrong Email.'),
                                              ),
                                            );
                                          }
                                          else {
                                            debugPrint("Something went wrong.");
                                            handler.setMessage('Cannot send email.');
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text('Cannot send email.'),
                                              ),
                                            );
                                          }
                                        }
                                      },
                                      child: Container(
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(16.0),
                                          child: Image.asset(
                                              'assets/images/send-email.png'
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
                                    Row (
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
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
                                          ),
                                          TextButton (
                                            style: flatButtonStyle,
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => CreateAccount(),
                                                ),
                                              );
                                            },
                                            child: Text('Create Account'),
                                          ),
                                        ]
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

  final ButtonStyle flatButtonStyle = TextButton.styleFrom(
    primary: kForgetPasswordMColor,
    minimumSize: Size(160, 40),
    padding: EdgeInsets.symmetric(horizontal: 16.0),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(2.0)),
    ),
  );
}