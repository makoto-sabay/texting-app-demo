import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:messaging_app/screens/constants.dart';
import 'package:messaging_app/functions/UserHandler.dart';
import 'package:messaging_app/repository/AppUserInfo.dart';


class SetProfileIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserHandler(FirebaseAuth.instance),
      child: SetProfileIconApps(),
    );
  }
}

class SetProfileIconApps extends StatefulWidget {
  @override
  _SetProfileIconAppsState createState() => _SetProfileIconAppsState();
}


class _SetProfileIconAppsState extends State<SetProfileIconApps> {
  late File _image;
  late final _picker = ImagePicker();
  AppUserInfo appUserInfo = AppUserInfo();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Texting Apps',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: buildSettingAppBar(context),
        body: buildProfileIconBody(context),
      ),
    );
  }

  Widget buildProfileIconBody(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    appUserInfo.setUser(user!);

    return Center(
      child: Column (
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            width: 150,
            height: 150,
            margin: const EdgeInsets.only(top: 40),
            child: FutureBuilder(
              future: _getUserImage(appUserInfo),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return CircularProgressIndicator();
                }
                if (snapshot.hasError) {
                  return getDefaultUserWidget();
                }
                if (snapshot.hasData) {
                  return snapshot.data;
                }
                else {
                  return getDefaultUserWidget();
                }
              },
            ),
          ),
          Container(
            width: 400.0,
            height: 10.0,
          ),
          Container(
            child: GestureDetector(
              onTapDown: (TapDownDetails tapDownDetails) async {
                FutureBuilder(
                  future: _getImageFromGalleryOnPress(),
                  builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return getDefaultUserWidget();
                    }
                    if (snapshot.hasData) {
                      return snapshot.data;
                    }
                    else {
                      return getDefaultUserWidget();
                    }
                  },
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: Image.asset(
                    'assets/images/choose-file.png'
                ),
              ),
            ),
          ),
        ]
      ),
    );
  }


  Future<Widget> _getUserImage(AppUserInfo appUserInfo) async {
    String tmpFilePath = appUserInfo.getPhotoURL();
    if (tmpFilePath == null) {
      tmpFilePath = defaultUserImagePath;
    }
    else if (tmpFilePath == '') {
      tmpFilePath = defaultUserImagePath;
    }
    else if (tmpFilePath == 'Not Set') {
      tmpFilePath = defaultUserImagePath;
    }
    else {
      //
    }

    return Container(
      child: Image.asset(
        tmpFilePath,
        cacheWidth:120,
        cacheHeight:120,
      ),
    );
  }


  Future<Widget> _getImageFromGalleryOnPress() async {
    final _pickedFile = await _picker.getImage(source: ImageSource.gallery);

    String tmpFilePath;
    if (_pickedFile != null) {
      tmpFilePath =  _pickedFile.path;
    }
    else{
      tmpFilePath = defaultUserImagePath;
    }

    return Container(
      child: Image.asset(
        tmpFilePath,
        cacheWidth:120,
        cacheHeight:120,
      ),
    );
  }



  Widget getDefaultUserWidget() {
    return Container(
      child: Image.asset(
        defaultUserImagePath,
        cacheWidth:120,
        cacheHeight:120,
      ),
    );
  }


  AppBar buildSettingAppBar(BuildContext context) {
    return AppBar (
      leading: BackButton (
        color: Colors.white,
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text('Set Profile Icon'),
      backgroundColor: kTitleBackgroundColor,
      automaticallyImplyLeading: true,
    );
  }
}