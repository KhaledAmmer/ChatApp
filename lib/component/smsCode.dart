import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:khaledchat/component/button.dart';
import 'package:khaledchat/component/textfiled.dart';
import 'package:khaledchat/component/toastMsg.dart';
import 'package:khaledchat/screens/UserNameScreen.dart';

class SmSCode extends StatefulWidget {
  final verificationId;

  SmSCode(this.verificationId);

  @override
  _SmSCodeState createState() => _SmSCodeState();
}

class _SmSCodeState extends State<SmSCode> {
  FirebaseAuth auth = FirebaseAuth.instance;
  int counter = 29;
  var code = TextEditingController();
  Timer? t;

  @override
  void initState() {
    super.initState();

    t = Timer.periodic(Duration(seconds: 1), (timer) {
      if (counter != 0) {
        counter--;
        setState(() {});
      } else {
        toastMsg("Time out try again ^__^", context);
        t!.cancel();
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: AlertDialog(
        backgroundColor: Colors.blueGrey,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(50))),
        title: Text(
          "SMS CODE",
          style: TextStyle(color: Colors.white),
        ),
        content: Container(
          height: 320,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      "assets/images/sms.svg",
                      width: 150,
                      height: 150,
                      color: Colors.white,
                      placeholderBuilder: (BuildContext context) => Container(
                          padding: const EdgeInsets.all(30.0),
                          child: const CircularProgressIndicator()),
                    ),
                    SizedBox(
                      width: 6,
                    ),
                    Text(
                      "$counter",
                      style: TextStyle(fontSize: 40, color: Colors.white),
                    )
                  ],
                ),
              ),
              textfiled1(
                fillcolor: Colors.white,
                sufFun: () {},
                prefix: Icons.lock,
                cor: code,
                max: 6,
                kt: TextInputType.text,
                isPw: false,
                hint: "Enter your Code",
              ),
              Row(
                children: [
                  button(
                    text: "Cheak ",
                    textcolor: Colors.blueGrey.shade700,
                    bcolor: Colors.white,
                    myfun: () async {
                      String smsCode = code.text.toString();
                      // Create a PhoneAuthCredential with the code
                      PhoneAuthCredential credential =
                          PhoneAuthProvider.credential(
                              verificationId: widget.verificationId,
                              smsCode: smsCode);
                      // Sign the user in (or link) with the credential
                      late var cheak = 0;
                      try {
                        await auth.signInWithCredential(credential);
                        cheak = 1;
                      } catch (e) {
                        toastMsg("Invalid SMS Code", context);
                      }
                      if (cheak == 1) {
                        if (t != null) t!.cancel();
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (_) {
                          return UserNameScreen(
                            userId: auth.currentUser!.uid,
                          );
                        }));
                      }
                    },
                  ),
                  button(
                      text: "Cancel",
                      textcolor: Colors.blueGrey.shade700,
                      bcolor: Colors.white,
                      myfun: () {
                        t!.cancel();
                        Navigator.pop(context);
                      }),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
