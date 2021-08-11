import 'package:flutter/material.dart';
import 'package:messaging_app/screens/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:messaging_app/screens/index/IndexPage.dart';
import 'package:messaging_app/functions/LoginHandler.dart';
import 'package:messaging_app/screens/friends/FriendsListPage.dart';
import 'package:messaging_app/screens/password/ForgetPassword.dart';
import 'package:messaging_app/screens/registration/CreateAccount.dart';
import 'package:provider/provider.dart';


class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LoginHandler(FirebaseAuth.instance),
      child: LoginPageApps(),
    );
  }
}

class LoginPageApps extends StatefulWidget {
  @override
  _LoginPageApp createState() => _LoginPageApp();
}


class _LoginPageApp extends State<LoginPageApps> {
  final _formKey = GlobalKey<FormState>();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    FocusNode myFocusNode1 = new FocusNode();
    FocusNode myFocusNode2 = new FocusNode();
    LoginHandler handler = context.read<LoginHandler>();

    return Scaffold(
        backgroundColor: kLoginBackgroundColor,
        body: GestureDetector(
            onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
            child: SingleChildScrollView(
              //reverse: true,
              child: Form(
                key: _formKey,
                child: Column(
                    children: <Widget>[
                      Padding(
                          padding: const EdgeInsets.only(
                              left: 0, right: 0, top: 60.0, bottom: 20.0
                          ),
                          child: Center(
                            child: Container(
                              child: Image.asset(
                                  'assets/images/login-logo.png'),
                            ),
                          )
                      ),
                      Stack(
                          children: <Widget>[
                            Column(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceEvenly,
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
                                              color: myFocusNode1.hasFocus
                                                  ? Colors.blue
                                                  : Colors.black
                                          ),
                                          filled: true,
                                          fillColor: Colors.white,
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Colors.white, width: 2.0
                                            ),
                                          ),
                                          hintText: 'Enter your email.'
                                      ),
                                      validator: handler.emptyEmailChecker,
                                      onSaved: (value) =>
                                      handler.email = value!,
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
                                              color: myFocusNode2.hasFocus
                                                  ? Colors.blue
                                                  : Colors.black
                                          ),
                                          filled: true,
                                          fillColor: Colors.white,
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Colors.white,
                                                width: 2.0),
                                          ),
                                          hintText: 'Enter your secure password.'
                                      ),
                                      validator: handler.emptyPasswordChecker,
                                      onSaved: (value) =>
                                      handler.password = value!,
                                    ),
                                  ),
                                  Container(
                                    width: 400.0,
                                    height: 20.0,
                                  ),
                                  GestureDetector(
                                    onTapDown: (TapDownDetails tapDownDetails) async {
                                        handler.setMessage('');
                                        FocusScope.of(context).requestFocus(FocusNode());

                                      if (_formKey.currentState!.validate()) {
                                        _formKey.currentState!.save();
                                        var response = await context.read<
                                            LoginHandler>().login();

                                        if (response) {
                                          Navigator.push(context,
                                            MaterialPageRoute(
                                              builder: (context) => FriendsListPage(),
                                            ),
                                          );

                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text('Login Successful'),
                                            ),
                                          );
                                        }
                                        else {
                                          debugPrint('Wrong Email or Password.');
                                          context.read<LoginHandler>()
                                              .setMessage(
                                              'Cannot login.');
                                        }
                                      }
                                    },
                                    child: Container(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(16.0),
                                        child: Image.asset('assets/images/login-button.png'),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 400.0,
                                    height: 20.0,
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(0, 16, 0, 8),
                                    child: Text(
                                      context
                                          .watch<LoginHandler>()
                                          .message,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.orangeAccent,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 400.0,
                                    height: 60.0,
                                  ),
                                  Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .spaceEvenly,
                                      children: [
                                        TextButton(
                                          style: flatButtonStyle,
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ForgetPassword(),
                                              ),
                                            );
                                          },
                                          child: Text('Forgot Password?'),
                                        ),
                                        TextButton(
                                          style: flatButtonStyle,
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    CreateAccount(),
                                              ),
                                            );
                                          },
                                          child: Text(' Create Account '),
                                        ),
                                      ]
                                  ),
                                  Container(
                                    width: 400.0,
                                    height: 10.0,
                                  ),
                                ]
                            ),
                          ]
                      ),
                    ]
                ),
              ),
            )
        )
    );
  }


  final ButtonStyle flatButtonStyle = TextButton.styleFrom(
    primary: Colors.orangeAccent,
    minimumSize: Size(160, 40),
    padding: EdgeInsets.symmetric(horizontal: 16.0),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(2.0)),
    ),
  );

}
