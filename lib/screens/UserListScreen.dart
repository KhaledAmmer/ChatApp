import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:khaledchat/component/buildDrawerItem.dart';
import 'package:khaledchat/component/login_SignUp_components.dart';
import 'package:khaledchat/component/userCard.dart';
import 'package:khaledchat/component/videoPlyerCard.dart';
import 'package:khaledchat/screens/LoginScreen.dart';
import 'package:khaledchat/screens/UserNameScreen.dart';
import 'package:khaledchat/style/boxDecoration.dart';
import 'ChatScreen.dart';

class UserScreen extends StatefulWidget {
  static String id = "userscreen";

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  var user = FirebaseFirestore.instance.collection('users');
  var auth = FirebaseAuth.instance;
  var user1 = FirebaseFirestore.instance.collection('messages');
  var username = TextEditingController();
  Widget currentUserCard = Container();
  int count = 0;
  List<Map> unread = [];
  List<String> keys = [];
  List<int> values = [];
  List<Map<dynamic, dynamic>> users = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    List<String> s = [];
    user.get().then((value) {
      value.docs.forEach((e) {
        // FirebaseFirestore.instance.collection("messages").doc(e["id"]).set(
        //     {
        //       "userName": e["userName"],
        //       "ImageUrl": e["ImageUrl"],
        //       "id": e["id"],
        //       "Unread": [{e["id"]: 0}]
        //     }
        // );
        if (e["id"] == auth.currentUser!.uid) {
          currentUserCard = Container(
            margin: EdgeInsets.only(left: 30),
            child: currentUsercard(e),
          );
          setState(() {});
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        drawer: Drawer(
          child: Container(
            decoration: boxDecoration(),
            width: 100,
            child: Column(
              children: [
                buildWelcomeContainer(
                  height: 150.0,
                ),
                DrawerItem(
                  icon: Icons.backspace,
                  text: "Sign Out",
                  fun: () async {
                    await auth.signOut();
                    Navigator.pushReplacementNamed(context, LoginScreen.id);
                  },
                ),
                DrawerItem(
                  icon: Icons.settings,
                  text: "Setting",
                  fun: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) {
                      return UserNameScreen(
                        userId: auth.currentUser!.uid,
                        isNew: false,
                      );
                    }));
                  },
                ),
              ],
            ),
          ),
        ),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.blueGrey,
          flexibleSpace: currentUserCard,
          bottom: TabBar(
            tabs: [
              Tab(text: "My User"),
              Tab(text: "Add User"),
              Tab(text: "Status"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Container(
              height: double.infinity,
              decoration: boxDecoration(),
              child: Center(
                child: getUserList(isStatus: false),
              ),
            ),
            Container(
              height: double.infinity,
              decoration: boxDecoration(),
              child: Center(
                child: getUserList(),
              ),
            ),
            Container(
              height: double.infinity,
              decoration: boxDecoration(),
                child: getUserList(isStatus: true),

            ),
          ],
        ),
      ),
    );
  }

  StreamBuilder<QuerySnapshot<Map<String, dynamic>>> getUserList(
      {bool isStatus = false}) {
    return StreamBuilder(
      stream: user1.snapshots(),
      builder: (BuildContext context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }
        if (snapshot.hasData) {
          snapshot.data!.docs.forEach((element) {
            if (element.data()["id"] == "${auth.currentUser!.uid}") {
              values.clear();
              keys.clear();
              unread.clear();

              unread = (element.data()["Unread"] as List<dynamic>)
                  .map((dynamic item) => item as Map)
                  .toList();


                for (var x in unread) {
                  /// هاد الشرط محطوط مشان اول  ماننشئ ال unread بالفاير بيس بتكون بتحتوي قيمة فارغة
                 if(x.keys.length!=0){
                   keys.add(x.keys.first);
                   values.add(x.values.first);
                 }

              }
            }
          });
          user.get().then((value) {
            users.clear();
            value.docs.forEach((element) {
              users.add(element.data());
            });
          });
        }
       if(keys.length==0 && unread.length==1){
         return Text("No User Exist");
       }

          return  ListView(
              padding: EdgeInsets.all(0.0),
              children: users.map((e) {
                try {
                  if (e["id"] != auth.currentUser!.uid) {
                    var unreadMsg = 0;
                    for (var x = 0; x < keys.length; x++) {
                      if (keys[x].contains(e["id"])) {
                        unreadMsg = values[x];
                      }
                    }
                    return Center(
                      child: userCard(
                          n: unreadMsg,
                          image: e["ImageUrl"],
                          userName: e['userName'],
                          fun: () {
                           if(!isStatus) {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (_) {
                                return ChatScreen(
                                    reciver: e["id"],
                                    reciverName: e["userName"]);
                              }));
                            }else{
                             Navigator.push(context,
                                 MaterialPageRoute(builder: (_) {
                                   return VideoPlayerCard(
                                     e['status'],
                                     isStatus: true,
                                   );
                                 }));
                           }
                          }),
                    );
                  } else {
                    return Container();
                  }
                } catch (e) {
                  return Container();
                }
              }).toList(),
            );




      },
    );
  }
}
