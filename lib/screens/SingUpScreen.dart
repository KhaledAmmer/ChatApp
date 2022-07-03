
import 'package:flutter/material.dart';
import 'package:khaledchat/Api/Fireabase/FireBase.dart';
import 'package:khaledchat/component/login_SignUp_components.dart';
import 'package:khaledchat/component/button.dart';
import 'package:khaledchat/component/textfiled.dart';
import 'package:khaledchat/screens/LoginScreen.dart';
import 'package:khaledchat/style/boxDecoration.dart';


class SignupScreen extends StatefulWidget {
  static String id = "signup";

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  var isObs = true;
  var vis = false;
  var emailCtrl = TextEditingController();
  var passwordCtrl = TextEditingController();
  var confirmPassCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Container(
        height: double.infinity,
        decoration: boxDecoration(),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              buildWelcomeContainer(),
              GoToScreen(
                text: "Login?",
                function: () {
                  Navigator.pushReplacementNamed(context, LoginScreen.id);
                },
              ),
              textfiled1(
                sufFun: () {},
                prefix: Icons.email,
                cor: emailCtrl,
                kt: TextInputType.emailAddress,
                isPw: false,
                max: 40,
                hint: "Enter E-Mail",
              ),
              textfiled1(
                sufFun: () {
                  setState(() {
                    isObs = !isObs;
                  });
                },
                prefix: Icons.lock,
                cor: passwordCtrl,
                kt: TextInputType.text,
                isPw: isObs,
                hint: "Create Password",
              ),
              textfiled1(
                sufFun: () {
                  setState(() {
                    isObs = !isObs;
                  });
                },
                prefix: Icons.lock,
                cor: confirmPassCtrl,
                kt: TextInputType.text,
                isPw: isObs,
                hint: "Confirm Password",
              ),
              button(
                  bcolor: Colors.blueGrey,
                  myfun: () async {
                    await FireBase.fireBase.SignUp(
                        context, emailCtrl, passwordCtrl, confirmPassCtrl, ConfirmPass);},
                  text: 'Sign Up',
                  textcolor: Colors.white),
              Visibility(
                visible: vis,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }



  bool ConfirmPass() {
    return passwordCtrl.text == confirmPassCtrl.text;
  }
}
