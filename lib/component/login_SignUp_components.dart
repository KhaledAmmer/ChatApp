import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:khaledchat/Api/Fireabase/FireBase.dart';
import 'package:khaledchat/component/toastMsg.dart';
import 'package:khaledchat/screens/UserListScreen.dart';
import 'package:khaledchat/screens/UserNameScreen.dart';
import 'Icon.dart';

FirebaseAuth auth = FirebaseAuth.instance;
class buildWelcomeContainer extends StatelessWidget {
  final height;

  buildWelcomeContainer({this.height=100.0});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
          color: Colors.blueGrey,
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(90))),
      child:  Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Khaled Chat",
              style: GoogleFonts.oswald(
                textStyle:
                    TextStyle(color: Colors.white, letterSpacing: .5, fontSize: 40),
              ),
              ),
            SizedBox(width: 5,),
            SvgPicture.asset("assets/images/owl.svg",
                width: 80,height: 80,color: Colors.white,
                placeholderBuilder: (BuildContext context) => Container(
                    padding: const EdgeInsets.all(30.0),
                    child: const CircularProgressIndicator()),
              ),

          ],

      ),
    );
  }
}

class GoToScreen extends StatelessWidget {
  final text;
  final function;

  GoToScreen({this.text, this.function});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: RaisedButton(
              onPressed: function,
              color: Colors.blueGrey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            )),
        Text(
          text,
          style: TextStyle(fontSize: 20.0, color: Colors.black54),
        )
      ],
    );
  }
}

class SociallRow extends StatelessWidget {
  final function;

  SociallRow({this.function});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: buildIcon(
              size: 55.0,
              icon: Icons.facebook,
              fun: () async {
                await FireBase.fireBase.LogInWithFacebook(context);
              },
              color: Colors.blue,
            ),
          ),
          Expanded(
            flex: 1,
            child: buildIcon(
              size: 55.0,
              icon: Icons.email,
              fun: () async {
                await FireBase.fireBase.LogInWithGoogle(context);
              },
              color: Colors.red,
            ),
          ),
          Expanded(
            flex: 1,
            child: buildIcon(
              size: 55.0,
              icon: Icons.phone,
              fun: function,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

}
