import 'package:flutter/material.dart';
import 'package:messaging_app/screens/constants.dart';

class AboutThisAppPage extends StatefulWidget {
  @override
  _AboutThisAppPageState createState() => _AboutThisAppPageState();
}


class _AboutThisAppPageState extends State<AboutThisAppPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Texting Apps',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: buildSettingAppBar(context),
        body: Center(
          child: Text('©2021 Makoto@Freelancer All rights reserved.'),
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
      title: Text('About This App'),
      backgroundColor: kTitleBackgroundColor,
      automaticallyImplyLeading: true,
    );
  }
}