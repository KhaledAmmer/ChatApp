import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:khaledchat/Api/googleMap/MapProvider.dart';
import 'package:khaledchat/provider/MyProvider.dart';
import 'package:khaledchat/screens/ChatScreen.dart';
import 'package:khaledchat/screens/LoginScreen.dart';
import 'package:khaledchat/screens/SingUpScreen.dart';
import 'package:khaledchat/screens/UserListScreen.dart';
import 'package:khaledchat/screens/UserNameScreen.dart';
import 'package:provider/provider.dart';

//https://firebase.flutter.dev/docs/auth/phone

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(
    providers: [
      ListenableProvider<MyProvider>(create: (cox)=> MyProvider()),
      ListenableProvider<MapProvider>(create: (cox)=> MapProvider()),
    ] ,
    child: MaterialApp(
       debugShowCheckedModeBanner: false,
      routes: {
        SignupScreen.id: (_) => SignupScreen(),
        LoginScreen.id: (_) => LoginScreen(),
        UserScreen.id: (_) => UserScreen(),
        ChatScreen.id: (_) => ChatScreen(),
        UserNameScreen.id: (_) => UserNameScreen(),
      },
      initialRoute: LoginScreen.id,
    ),
  ));
}
