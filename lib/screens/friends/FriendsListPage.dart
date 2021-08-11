import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:messaging_app/screens/constants.dart';
import 'package:messaging_app/functions/FriendHandler.dart';
import 'package:messaging_app/repository/AppUserInfo.dart';
import 'package:messaging_app/screens/index/IndexPage.dart';
import 'package:messaging_app/screens/settings/SettingPage.dart';
import 'package:messaging_app/screens/message/MessagePage.dart';


class FriendsListPage extends StatefulWidget {
  @override
  _FriendsListPageState createState() => _FriendsListPageState();
}


class _FriendsListPageState extends State<FriendsListPage> {
  int _selectedIndex = 1;
  AppUserInfo? appUserInfo;
  User? user;
  FriendHandler? friendHandler;
  List friendList = <List<FriendInfo>>[] as List;

  @override
  void initState() {
    user = FirebaseAuth.instance.currentUser;
    appUserInfo = AppUserInfo();
    appUserInfo!.setUser(user!);
    friendHandler = FriendHandler(appUserInfo!.email);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: FriendsListBody(context),
      bottomNavigationBar: buildAppBottomNavigationBar(),
    );
  }


  Widget FriendsListBody(BuildContext context) {
    return FutureBuilder (
      future: friendHandler!.getNumberFriends(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text("${snapshot.error}"));
        }

        if(snapshot.data == 0){
          return buildNoFriendsBody(context);
        }

        return buildFriendsListBody(context, friendHandler!);
      },
    );
  }


  Widget buildFriendsListBody(BuildContext context, FriendHandler friendHandler) {
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

        if (!snapshot.hasData){
          return buildNoFriendsBody(context);
        }

        return buildFriendsList(context, snapshot);
      }
    );
  }



  Widget buildFriendsList(BuildContext context, AsyncSnapshot snapshot) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) =>
                TextingCard (
                  friendInfo: snapshot.data[index],
                  press: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MessagePage(appUserInfo!, snapshot.data[index]),
                    ),
                  ),
                ),
          ),
        ],
      ),
    );
  }


  Widget buildNoFriendsBody(BuildContext context) {
    return Center(child: Text('Let\'s add your friends!'));
  }


  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: Text("Text your friends"),
      backgroundColor: friendPageColor,
      automaticallyImplyLeading: false,
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


class TextingCard extends StatelessWidget {
  const TextingCard({
    Key? key,
    required this.friendInfo,
    required this.press,
  }) : super(key: key);

  final FriendInfo friendInfo;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: press,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: kAppsPadding, vertical: kAppsPadding * 0.75),
        child: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundImage: AssetImage(friendInfo.imageFile) as ImageProvider,
                ),
                if (friendInfo.activeStatus)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: kPrimaryColor,
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            width: 3),
                      ),
                    ),
                  )
              ],
            ),
            Expanded(
              child: Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      friendInfo.friendName,
                      style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: 8),
                    Opacity(
                      opacity: 0.64,
                      child: Text(
                        friendInfo.lastMessage,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Opacity(
              opacity: 0.64,
              child: Text(friendInfo.date),
            ),
          ],
        ),
      ),
    );
  }

}