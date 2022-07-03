import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:khaledchat/Api/Fireabase/FireBase.dart';
import 'package:khaledchat/component/login_SignUp_components.dart';

import 'package:khaledchat/component/button.dart';
import 'package:khaledchat/component/textfiled.dart';
import 'package:khaledchat/screens/SingUpScreen.dart';
import 'package:khaledchat/style/boxDecoration.dart';


//https://paproject.site/

class LoginScreen extends StatefulWidget {
  static String id = "login";

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  PhoneNumber number = PhoneNumber(isoCode: 'JO');
  var emailCtrl = TextEditingController();
  var passwordCtrl = TextEditingController();
  var phoneCtrl = TextEditingController();
  bool isPhone = false;
  bool isObs = true;
  bool vis = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FireBase.fireBase.getCurrentUser(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blueGrey,
        elevation: 0.0,
      ),
      body: isPhone
          ? Container(
              height: double.infinity,
              decoration: boxDecoration(),
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                   buildWelcomeContainer(),
                      GoToScreen(
                        text: "Sign Up?",
                        function: () {
                          Navigator.pushReplacementNamed(
                              context, SignupScreen.id);
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InternationalPhoneNumberInput(
                          hintText: "Enter Your Phone Number",
                          onInputChanged: (PhoneNumber number) async {
                            try {
                              await getPhoneNumber(
                                  phoneCtrl.text, number.isoCode);
                            } catch (e) {}
                          },
                          onInputValidated: (bool value) {},
                          selectorConfig: SelectorConfig(
                            selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                          ),
                          ignoreBlank: false,
                          autoValidateMode: AutovalidateMode.disabled,
                          selectorTextStyle: TextStyle(color: Colors.black),
                          initialValue: number,
                          textFieldController: phoneCtrl,
                          formatInput: false,
                          keyboardType: TextInputType.numberWithOptions(
                              signed: true, decimal: true),
                          inputBorder: OutlineInputBorder(),
                          onSaved: (PhoneNumber number) async {
                            await getPhoneNumber(
                                phoneCtrl.text, number.isoCode);
                          },
                        ),
                      ),
                      button(
                        bcolor: Colors.blueGrey,
                        text: 'Login',
                        textcolor: Colors.white,
                        myfun: () async {
                          setState(() {
                            vis = true;
                          });
                          try {
                            await FireBase.fireBase.loginWithPhone(context, number);
                          } catch (e) {}
                          Future.delayed(Duration(seconds: 3), () {
                            setState(() {
                              vis = false;
                            });
                          });
                        },
                      ),
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
            )
          : Container(
              height: double.infinity,
              decoration: boxDecoration(),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    buildWelcomeContainer(),
                    GoToScreen(
                      text: "Sign Up?",
                      function: () {
                        Navigator.pushReplacementNamed(
                            context, SignupScreen.id);
                      },
                    ),
                    textfiled1(
                      sufFun: () {},
                      prefix: Icons.email,
                      cor: emailCtrl,
                      kt: TextInputType.emailAddress,
                      isPw: false,
                      hint: "Enter E-Mail",
                      max: 50
                    ),
                    textfiled1(
                      prefix: Icons.lock,
                      cor: passwordCtrl,
                      kt: TextInputType.text,
                      isPw: isObs,
                      hint: "Create Password",
                      sufFun: () {
                        setState(() {
                          isObs = !isObs;
                        });
                      },
                    ),
                    button(
                      bcolor: Colors.blueGrey,
                      text: 'Login',
                      textcolor: Colors.white,
                      myfun: () async {
                        setState(() {
                          vis = true;
                        });
                        FireBase.fireBase.LoginWithEmail(context, emailCtrl, passwordCtrl);
                      },
                    ),
                    SociallRow(
                      function: () {
                        isPhone = true;
                        setState(() {});
                      },
                    ),
                    Visibility(
                      visible: vis,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ],
                ),
              )),
    );
  }



  getPhoneNumber(String phoneNumber, code) async {
    PhoneNumber number =
        await PhoneNumber.getRegionInfoFromPhoneNumber(phoneNumber, code);
    this.number = number;
  }
}
