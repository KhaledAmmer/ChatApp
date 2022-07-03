import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:khaledchat/component/smsCode.dart';
import 'package:khaledchat/component/toastMsg.dart';
import 'package:khaledchat/screens/UserListScreen.dart';
import 'package:khaledchat/screens/UserNameScreen.dart';

class FireBase {
  static final auth = FirebaseAuth.instance;
  static FireBase fireBase = FireBase();

  getCurrentUser(context) async {
    var user = await auth.currentUser;
    if (user != null) Navigator.pushReplacementNamed(context, UserScreen.id);
  }

  LoginWithEmail(context, emailCtrl, passwordCtrl) async {
    //هي الوظيفة بتنشأ الايميل وبنفس الوقت بتعمل تشييك اذا الايميل الموجود بيرجع القيمة null لهيك اذا ما كانت القيمة null بيعمل إنشاء للايميل وبينفله ل شاشة المستخدم
    try {
      var newUser = await auth.signInWithEmailAndPassword(
          email: emailCtrl.text.trim(), password: passwordCtrl.text);
      Navigator.pushReplacementNamed(context, UserScreen.id);
    } catch (e) {
      String error = e
          .toString()
          .replaceAll("[firebase_auth/user-not-found]", "")
          .replaceAll("[firebase_auth/wrong-password]", "")
          .replaceAll("[firebase_auth/invalid-email]", "")
          .replaceAll("[firebase_auth/unknown] Given String is empty or null",
              "Invalid Name/Password");
      toastMsg(error, context);
    }
  }

  loginWithPhone(context, number) async {
    await auth.verifyPhoneNumber(
      phoneNumber: number.toString(),
      verificationCompleted: (PhoneAuthCredential credential) async {
        // await auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number')
          toastMsg("The provided phone number is not valid", context);
        else
          toastMsg("Connection Failed Try Again", context);
      },
      codeSent: (String verificationId, int? resendToken) async {
        await showDialog(
            context: context,
            builder: (cox) {
              return SmSCode(verificationId);
            });
      },
      codeAutoRetrievalTimeout: (String verificationId) async {
        var s = PhoneCodeAutoRetrievalTimeout;
      },
    );
  }

  SignUp(BuildContext context, emailCtrl, passwordCtrl, confirmPassCtr, fun) async {
    if (fun()) {
      //هي الوظيفة بتنشأ الايميل وبنفس الوقت بتعمل تشييك اذا الايميل الموجود بيرجع القيمة null لهيك اذا ما كانت القيمة null بيعمل إنشاء للايميل وبينفله ل شاشة المستخدم
      try {
        var newUser = await auth.createUserWithEmailAndPassword(
            email: emailCtrl.text.trim(), password: passwordCtrl.text);
        User? user = FirebaseAuth.instance.currentUser;
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) {
          return UserNameScreen(userId: user!.uid.toString());
        }));
      } catch (e) {
        toastMsg(
            e
                .toString()
                .replaceAll("[firebase_auth/email-already-in-use]", "")
                .trim(),
            context);
      }
    } else
      toastMsg("The password is not the same", context);
  }

  LogInWithFacebook(BuildContext context) async {
    LoginResult? result;
    try {
      LoginResult result = await FacebookAuth.instance.login();
      if (result.status == LoginStatus.success) {
        final AccessToken accessToken = result.accessToken!;
        final facebookAuthCredential =
            FacebookAuthProvider.credential(accessToken.token);
        var newUser = await auth.signInWithCredential(facebookAuthCredential);
      }
    } catch (e) {}
    toastMsg("Login was failed, you will login as a guest", context);
    try {
      var auth = FirebaseAuth.instance;
      var newUser = await auth.signInWithEmailAndPassword(
          email: "Guest@gmail.com", password: "123456789");
      Navigator.pushReplacementNamed(context, UserScreen.id);
    } catch (e) {
      var auth = FirebaseAuth.instance;
      var newUser = await auth.createUserWithEmailAndPassword(
          email: "Guest@gmail.com", password: "123456789");
      User? user = FirebaseAuth.instance.currentUser;
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) {
        return UserNameScreen(userId: user!.uid.toString());
      }));
    }
  }

  LogInWithGoogle(BuildContext context) async {
    GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
    var result = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await result!.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    var user = await FirebaseAuth.instance.signInWithCredential(credential);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) {
      return UserNameScreen(userId: user.user!.uid.toString());
    }));
  }

  Future<void> addUser(username,imageUrl,isNew) async {
    var newUser = FirebaseFirestore.instance
        .collection('users')
        .doc("${auth.currentUser!.uid}");
    if (isNew) {
       newUser.set({
        'userName': username,
        'ImageUrl': imageUrl != null
            ? imageUrl
            : "https://upload.wikimedia.org/wikipedia/commons/thumb/1/12/User_icon_2.svg/600px-User_icon_2.svg.png",

        'id': "${auth.currentUser!.uid}",

      });
    } else {
       newUser.update({
        'userName': username,
        'ImageUrl': imageUrl != null
            ? imageUrl
            : "https://upload.wikimedia.org/wikipedia/commons/thumb/1/12/User_icon_2.svg/600px-User_icon_2.svg.png",
        // John Doe
        'id': "${auth.currentUser!.uid}",
        // 42
      });
    }

    ///هون مشان موضوع استقبال اشعار عند ارسال رسالة
    newUser = FirebaseFirestore.instance
        .collection('messages')
        .doc("${auth.currentUser!.uid}");
    if (isNew) {
      return newUser.set({
        'userName': username,
        'ImageUrl': imageUrl != null
            ? imageUrl
            : "https://upload.wikimedia.org/wikipedia/commons/thumb/1/12/User_icon_2.svg/600px-User_icon_2.svg.png",

        'id': "${auth.currentUser!.uid}",
        'Unread':[{}] ,
        'lastMessage': DateTime.now().microsecondsSinceEpoch,

      });
    } else {
      return newUser.update({
        'userName': username,
        'ImageUrl': imageUrl != null
            ? imageUrl
            : "https://upload.wikimedia.org/wikipedia/commons/thumb/1/12/User_icon_2.svg/600px-User_icon_2.svg.png",
        'id': "${auth.currentUser!.uid}",
        // 42
      });
    }
  }
}
