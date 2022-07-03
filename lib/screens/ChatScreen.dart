import 'package:khaledchat/Api/Fireabase/FireBaseTask.dart';
import 'package:khaledchat/LocalDataBase/Databasehelper1.dart';
import 'package:khaledchat/Services/Services.dart';
import 'package:khaledchat/component/Icon.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:khaledchat/component/buildFlotationButton.dart';
import 'package:khaledchat/component/chatMessage.dart';
import 'package:khaledchat/component/toastMsg.dart';
import 'package:khaledchat/component/textfiled.dart';
import 'package:provider/provider.dart';
import '../provider/MyProvider.dart';

class ChatScreen extends StatefulWidget {
  static String id = "chat";

  final reciver;
  final reciverName;

  ChatScreen({this.reciver, this.reciverName});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  var ldb = Databasehelper.instance;
  var auth = FirebaseAuth.instance;
  var db = FirebaseFirestore.instance;
  var msgCtrl = TextEditingController();
  var isVis = false;

  @override
  void initState() {
    super.initState();
    Services.service.openTheRecorder();
    FirebaseTask.firebaseTask.ReadMessage(widget.reciver, auth.currentUser!.uid);
    Provider.of<MyProvider>(context, listen: false).isRecording==true?
    Provider.of<MyProvider>(context, listen: false).recorderState():"";
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    if (Services.mRecorder!.isRecording) {
      Services.service.stopRecorder(widget.reciver, context);
    }
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.reciverName),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniStartFloat,
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Visibility(
              visible: Provider.of<MyProvider>(context).isVis,
              child: Column(
                children: [
                  BuildFlotationButton(
                      icon: Icons.location_on,
                      text: 'Location',
                      function: () async{
                        try {
                          await Services.service
                              .ShearMyLocation(widget.reciver);
                        } catch (e) {
                          toastMsg("No file selected", context);
                        }
                      }),
                  BuildFlotationButton(
                      icon: Icons.audiotrack,
                      text: 'Pick Audio File',
                      function: () async {
                        try {
                          await Services.service
                              .pickAudioFile(context, widget.reciver);
                        } catch (e) {
                          toastMsg("No file selected", context);
                        }
                      }),
                  BuildFlotationButton(
                      icon: Icons.photo,
                      text: 'Pick Image from gallery',
                      function: () async {
                        try {
                          await Services.service.pickImage(
                              ImageSource.gallery, context, widget.reciver);
                        } catch (e) {
                          toastMsg("No Image Selected", context);
                        }
                      }),
                  BuildFlotationButton(
                      icon: Icons.camera_alt,
                      text: "Take a Photo",
                      function: () async {
                        try {
                          await Services.service.pickImage(
                              ImageSource.camera, context, widget.reciver);
                        } catch (e) {
                          toastMsg(e.toString(), context);
                        }
                      }),
                  BuildFlotationButton(
                      icon: Icons.video_library,
                      text: 'Pick Video from gallery',
                      function: () async {
                        try {
                          await Services.service.pickImage(
                              ImageSource.gallery, context, widget.reciver,
                              isVideo: true);
                        } catch (e) {
                          toastMsg("No Video Selected", context);
                        }
                      }),
                  BuildFlotationButton(
                      icon: Icons.videocam,
                      text: 'Take a Video',
                      function: () async {
                        try {
                          await Services.service.pickImage(
                              ImageSource.camera, context, widget.reciver,
                              isVideo: true);
                        } catch (e) {
                          toastMsg(e.toString(), context);
                        }
                      }),
                  BuildFlotationButton(
                      icon: Icons.arrow_drop_down,
                      text: 'drop down',
                      function: () {
                        Provider.of<MyProvider>(context, listen: false)
                            .isVisable();
                      }),
                ],
              ))
        ],
      ),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              Color.fromRGBO(34, 117, 156, 1.0),
              Color.fromRGBO(34, 95, 104, 1.0),
            ]),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              StreamBuilder<QuerySnapshot>(
                stream: db
                    .collection("messages")
                    .doc(auth.currentUser!.uid.toString())
                    .collection("${widget.reciver}")
                    .orderBy('time', descending: true)
                    .snapshots(),
                builder: (ct, snapshot) {
                  if (snapshot.hasData) {
                    List<Widget> myWidgets = [];
                    
                    for (var msg in snapshot.data!.docs) {
                        var t = ChatMessage(
                            isSender: msg["sender"] == auth.currentUser!.uid?true:false,
                            msg: msg["text"],
                            type: msg["type"]);
                        myWidgets.add(t);

                    }

                    return Expanded(
                        child: ListView(
                      padding: EdgeInsets.all(2),
                      children: myWidgets,
                      reverse: true,
                    ));
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
              bottomChatCard(context),
            ],
          ),
        ),
      ),
    );
  }

  Card bottomChatCard(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.black, width: 1)),
      color: Colors.blueGrey,
      child: Row(
        children: [
          !Provider.of<MyProvider>(context).isChatCardExtand
              ? Visibility(
                  visible: !Provider.of<MyProvider>(context).isChatCardExtand,
                  child: Container(
                    margin: EdgeInsets.only(left: 6, right: 6),
                    height: 45,
                    width: 45,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                        alignment: Alignment.center,
                        onPressed: () {
                          Provider.of<MyProvider>(context, listen: false)
                              .isVisable();
                        },
                        icon: Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 25,
                        )),
                  ),
                )
              : buildIcon(
                  color: Colors.black,
                  icon: Icons.arrow_forward_ios,
                  size: 20.0,
                  fun: () {
                    Provider.of<MyProvider>(context, listen: false).isExtand();
                  }),
          Expanded(
            child: textfiled(
                fillcolor: Colors.white,
                kt: TextInputType.text,
                isPw: false,
                hint: "Your Message",
                cor: msgCtrl,
                txcolor: Colors.black,
                onTap: () {
                  Provider.of<MyProvider>(context, listen: false).isExtand();
                },
                onSubmitted: (_) {
                  Provider.of<MyProvider>(context, listen: false).isExtand();
                }),
          ),
          IconButton(
            icon: Icon(Icons.send),
            color: Colors.black,
            onPressed: () {
              if (msgCtrl.text != "") {
                FirebaseTask.firebaseTask.Sendmage(
                    text: msgCtrl.text, type: "1", reciver: widget.reciver);
                msgCtrl.clear();
              }
            },
          ),
          Visibility(
            visible: !Provider.of<MyProvider>(context).isChatCardExtand,
            child: IconButton(
              icon: Icon(
                Provider.of<MyProvider>(context).recordIcon,
                color: Provider.of<MyProvider>(context).iconColor,
              ),
              onPressed: () async {
                if (Provider.of<MyProvider>(context, listen: false)
                    .isRecording) {
                  //المشكلة هون انو لما اطلع من الصفحة مع يوقف تسجيل
                  Provider.of<MyProvider>(context, listen: false)
                      .recorderState();
                  Services.service.stopRecorder(widget.reciver, context);
                } else {
                  Provider.of<MyProvider>(context, listen: false)
                      .recorderState();
                  Services.service.record(widget.reciver);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
