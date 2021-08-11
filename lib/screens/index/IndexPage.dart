import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:messaging_app/functions/FriendHandler.dart';
import 'package:messaging_app/screens/friends/FriendPage.dart';
import 'package:provider/provider.dart';
import 'package:messaging_app/screens/constants.dart';
import 'package:messaging_app/functions/UserHandler.dart';
import 'package:messaging_app/functions/DBHelper.dart';
import 'package:messaging_app/repository/AppUserInfo.dart';
import 'package:messaging_app/screens/friends/FriendsListPage.dart';
import 'package:messaging_app/screens/settings/SettingPage.dart';


class IndexPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserHandler(FirebaseAuth.instance),
      child: IndexPageApps(),
    );
  }
}


class IndexPageApps extends StatefulWidget {
  @override
  _IndexPageAppsState createState() => _IndexPageAppsState();
}


class _IndexPageAppsState extends State<IndexPageApps> {
  User? user = FirebaseAuth.instance.currentUser;
  final dbHelper = DBHelper.instance;
  AppUserInfo appUserInfo = AppUserInfo();
  int _selectedIndex = 0;
  int _selectItem = 1;


  @override
  void initState() {
    super.initState();
    appUserInfo.setUser(user!);
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Texting Apps',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: buildHomeAppBar(context),
        body: buildHomeBody(context),
        bottomNavigationBar: buildAppBottomNavigationBar(),
      ),
    );
  }


  Widget buildHomeBody(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column (
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            buildUserInfo(),
            Container(
              width: 400.0,
              height: 20.0,
            ),
            buildFriendList(context),
          ],
        ),
      ),
    );
  }


  Widget buildFriendList(BuildContext context) {
    FriendHandler friendHandler = FriendHandler(appUserInfo.email);

    return FutureBuilder (
      future: friendHandler.getAllFriends(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          debugPrint(snapshot.error.toString());
          return Center(child: Text("${snapshot.error}"));
        }

        return buildFriendListBody(context, snapshot);
      }
    );
  }

  Widget buildFriendListBody(BuildContext context, AsyncSnapshot snapshot) {
    double screenWidth  = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTapDown: (TapDownDetails tapDownDetails) async {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Center(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 400,
            ),
            child: SizedBox(
              width  : screenWidth * 0.8,
              child: DropdownButton (
                items: getFriendItemList(snapshot, screenWidth),
                value: _selectItem,
                focusColor: kNoticeColor,
                menuMaxHeight: screenHeight * 0.8,
                onChanged: (int? value) {
                  if(value != null && value > 1) {
                    int index = value - 2;
                    moveFriendPage(snapshot, index);
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  void moveFriendPage(AsyncSnapshot snapshot, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FriendPage(appUserInfo, snapshot.data[index]),
      ),
    );
  }

  List<DropdownMenuItem<int>> getFriendItemList(AsyncSnapshot snapshot, double screenWidth) {
    List<DropdownMenuItem<int>> friendItemList = <DropdownMenuItem<int>>[];
    int length = snapshot.data.length;

    friendItemList.add (
      DropdownMenuItem(
        child: Text(
          'Friend: (' + length.toString() +')',
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        value: 1,
      ),
    );
    _selectItem = friendItemList[0].value!;
    if(length == 0) {
      return friendItemList;
    }
    for(int i=0; i<length; i++){
      FriendInfo friendInfo = snapshot.data[i];
      String friendName = friendInfo.friendName;
      String friendImage = friendInfo.imageFile;
      friendItemList.add(
        DropdownMenuItem(
          child: getDropdownFriendCard(friendName, friendImage, screenWidth),
          value: i+2,
        ),
      );
    }
    return friendItemList;
  }


  Widget getDropdownFriendCard(String friendName, String friendImage, double screenWidth) {
    return Container(
      width: screenWidth * 0.7,
      child: Column (
        children: [
          Row (
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 1,
                child: CircleAvatar(
                  radius: 24,
                  backgroundImage: AssetImage(friendImage),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(friendName, style: TextStyle(fontSize: 16.0),),
              ),
            ],
          ),
          Container(
            width: 20.0,
            height: 10.0,
          ),
        ],
      ),
    );
  }


  Widget buildUserInfo() {
    return FutureBuilder(
      future: getCurrentStatusMessage(appUserInfo.email),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          debugPrint(snapshot.error.toString());
          return Center(child: Text("${snapshot.error}"));
        }

        if (!snapshot.hasData){
          return buildStatusMessageBody(context, 'Not Set');
        }

        return buildStatusMessageBody(context, snapshot.data.toString());
      }
    );
  }


  Widget buildStatusMessageBody(BuildContext context, String message) {
    return Column (
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          width: 200.0,
          height: 60.0,
        ),
        SizedBox(
          width: 180,
          height: 180,
          child: Image.asset(
            defaultUserImagePath,
            cacheWidth: 180,
            cacheHeight: 180,
          ),
        ),
        Container(
          width: 200.0,
          height: 60.0,
        ),
        Text(
          getDisplayName(appUserInfo),
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          message,
          style: TextStyle(
            color: kSubTitleListColor,
          ),
        ),
        Container(
          width: 200.0,
          height: 60.0,
        ),
      ],
    );
  }


  String getDisplayName(AppUserInfo appUserInfo) {
    String name = appUserInfo.getDisplayName();
    if(name == ''){
      return 'No Name';
    }
    else {
      return name;
    }
  }


  Future<String> getCurrentStatusMessage(String email) async {
    return await dbHelper!.getStatusMessage(email);
  }


  AppBar buildHomeAppBar(BuildContext context) {
    return AppBar(
      title: Text('Home'),
      backgroundColor: kTitleBackgroundColor,
      automaticallyImplyLeading: false,
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.settings,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SettingPage(),
              ),
            );
          },
        )
      ],
    );
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
          case 0:
            {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => IndexPage(),
                ),
              );
            }
            break;

          case 1:
            {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FriendsListPage(),
                ),
              );
            }
            break;

          case 2:
            {
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
      ],
    );
  }


}


