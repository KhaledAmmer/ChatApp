import 'package:khaledchat/Api/Fireabase/FireBase.dart';
import 'package:khaledchat/Api/Fireabase/FireBaseTask.dart';
import 'package:khaledchat/Services/Services.dart';
import 'package:khaledchat/component/toastMsg.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:khaledchat/component/login_SignUp_components.dart';
import 'package:khaledchat/component/button.dart';
import 'package:khaledchat/component/textfiled.dart';
import 'package:khaledchat/style/boxDecoration.dart';

import 'UserListScreen.dart';

class UserNameScreen extends StatefulWidget {
  final userId;
  final isNew;
  static String id = "userNmaePage";

  UserNameScreen({this.userId, this.isNew = true});

  @override
  _UserNameScreenState createState() => _UserNameScreenState();
}

class _UserNameScreenState extends State<UserNameScreen> {
  var auth = FirebaseAuth.instance.currentUser;
  var db = FirebaseFirestore.instance;
  var userName = TextEditingController();
  var imageUrl;
  late File _imageFile;
  bool isImageAdd = false;



  pickImage(context) async {
    var picker = ImagePicker();
    var pickedFile = await picker.getImage(source: ImageSource.gallery);
    _imageFile = File(pickedFile!.path);
    toastMsg("Please wait a few seconds for upload the image", context);
    uploadImageToFirebase();
  }

  uploadImageToFirebase() async {
    String fileName = basename(_imageFile.path);
    var storage = FirebaseStorage.instance.ref().child('images/$fileName');
    var uploadTask = storage.putFile(_imageFile);
    imageUrl = await (await uploadTask).ref.getDownloadURL();
    setState(() {
      isImageAdd = true;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        elevation: 0.0,
      ),
      body: Container(
        height: double.infinity,
        decoration: boxDecoration(),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              buildWelcomeContainer(),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () async {
                await pickImage(context);
                },
                child: Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.7),
                    ),
                    child: isImageAdd
                        ? ContainerWithDecorationImage(imageUrl)
                        :  const Icon(
                            Icons.add,
                            size: 50,
                            color: Colors.black,
                          )),
              ),
              const SizedBox(
                height: 10,
              ),
              textfiled1(
                  prefix: Icons.text_fields,
                  hint: "User Name",
                  isPw: false,
                  kt: TextInputType.text,
                  cor: userName),
              const   SizedBox(
                height: 10,
              ),
              button(
                  text: "Next",
                  textcolor: Colors.white,
                  bcolor: Colors.blueGrey,
                  myfun: () async {
                    await FireBase.fireBase.addUser(userName.text, imageUrl, widget.isNew);
                    Navigator.pushNamed(context, UserScreen.id);
                  })
            ],
          ),
        ),
      ),
    );
  }
}
