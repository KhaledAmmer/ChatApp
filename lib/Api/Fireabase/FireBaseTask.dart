import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:khaledchat/Api/Fireabase/FireBase.dart';
import 'package:khaledchat/LocalDataBase/LocalDataBase.dart';
import 'package:khaledchat/LocalDataBase/Modlue.dart';
import 'package:path/path.dart';

class FirebaseTask {
  static final FirebaseTask firebaseTask = FirebaseTask();
  static final FirebaseAuth auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;

  uploadFileToFirebase(type, file, reciver) async {
    String fileName = basename(file.path);
    Reference? storage;
    if (type == "2") {
      storage = FirebaseStorage.instance.ref().child('images/$fileName');
    } else if (type == "3") {
      storage = FirebaseStorage.instance.ref().child('videos/$fileName');
    } else if (type == "4") {
      storage = FirebaseStorage.instance.ref().child('audios/$fileName');
    } else {
      storage = FirebaseStorage.instance.ref().child('voices/$fileName');
    }
    var uploadTask = storage.putFile(file);
    var ref = await (await uploadTask).ref.getDownloadURL();
    Sendmage(type: type, text: ref, reciver: reciver);
  }

  void Sendmage({type, text, reciver}) {
    Message msg = Message(
        text: text,
        type: type,
        sender: auth.currentUser!.uid.toString(),
        reciever: reciver.toString(),
        time: DateTime.now().millisecondsSinceEpoch.toString());

    /// save message in sender firebase file
    db
        .collection("messages")
        .doc("${auth.currentUser!.uid}")
        .collection("$reciver")
        .doc()
        .set({
      'sender': msg.sender,
      'receiver': msg.reciever,
      'text': msg.text,
      'time': msg.time,
      'type': msg.type,
    });

    /// save message in reciver firebase file
    db
        .collection("messages")
        .doc("$reciver")
        .collection("${auth.currentUser!.uid}")
        .doc()
        .set({
      'sender': msg.sender,
      'receiver': msg.reciever,
      'text': msg.text,
      'time': msg.time,
      'type': msg.type,
    });
      LocaleDataBase.db.insertMessages(msg);
    _SendNotification(reciver, msg.sender);
  }

  Future<void> _SendNotification(reciver, sender) async {
    await db.collection("messages").doc(reciver).get().then((value) async {
      List<dynamic>? maps = await value.data()!["Unread"];
      List<dynamic> mp = [];
      for (var i = 0; i < maps!.length; i++) {
        mp.add(maps[i].keys);
      }

      bool cheak = false;
      var index = 0;
      for (var x = 0; x < mp.length; x++) {
        if (mp[x].toString().contains(sender)) {
          cheak = true;
          index = x;
        }
      }

      if (!cheak) {
        maps.add({sender: 1});
        db.collection("messages").doc(reciver).update({
          "Unread": maps,
          "lastMassage": DateTime.now().microsecondsSinceEpoch
        });
      } else {
        String value = maps[index]
            .values
            .toString()
            .substring(1, maps[index].values.toString().length - 1);
        var n = int.parse(value) + 1;
        maps[index] = {sender: n};
        db.collection("messages").doc(reciver).update({
          "Unread": maps,
          "lastMassage": DateTime.now().microsecondsSinceEpoch
        });
      }
    });
  }

  ReadMessage(reciver, sender) async {
    List<Map> unread = [];
    List<String> keys = [];
    try{
      await db.collection("messages").doc("${sender}").get().then((value) {
        value.data()!.forEach((key, value) {
          if (key == "Unread") {
            unread = (value as List<dynamic>)
                .map((dynamic item) => item as Map)
                .toList();
            for (var x in unread) {
              keys.add(x.keys.first);
            }
            for (var x = 0; x < keys.length; x++) {
              if (keys[x].contains("$reciver")) {
                unread[x] = {reciver: 0};
                break;
              }
            }
            db.collection("messages").doc(sender).update({"Unread": unread});
          }
        });
      });
    }catch(e){}
  }
}
