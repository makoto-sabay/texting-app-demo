import 'package:flutter/material.dart';
import 'package:messaging_app/screens/constants.dart';


class LoadingApps extends StatefulWidget {
  @override
  _TitleAppsState createState() => _TitleAppsState();
}

class _TitleAppsState extends State<LoadingApps> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kTitleBackgroundColor,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Image.asset('assets/images/title.png'),
          ]
        )
      )
    );
  }
}
