import 'package:audioplayers/audioplayers.dart';
import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:khaledchat/component/buildAudioCard.dart';
import 'package:khaledchat/component/videoPlyerCard.dart';
import 'package:khaledchat/style/boxDecoration.dart';

import 'LocationCard.dart';


class ChatMessage extends StatelessWidget {
  final isSender;
  final msg;
  final type;

  ChatMessage({
    this.isSender,
    this.msg,
    this.type,
  });
  static const styleSomebody = BubbleStyle(
    nip: BubbleNip.leftCenter,
    color: Colors.white,
    borderColor: Colors.blue,
    padding: BubbleEdges.symmetric(horizontal: 20),
    borderWidth: 1,
    elevation: 4,
    margin: BubbleEdges.only(top: 15, right: 40),
    alignment: Alignment.topLeft,
  );
  static const styleMe = BubbleStyle(
    nip: BubbleNip.rightCenter,
    color: Color.fromARGB(
        255, 187, 228, 250),
    borderColor: Colors.blue,
    borderWidth: 1,
    elevation: 4,
    margin: BubbleEdges.only(top: 8, left: 50),
    alignment: Alignment.topRight,
  );




  @override
  Widget build(BuildContext context) {
    if (type == "1") {
      return isSender != true
          ? Column(
        crossAxisAlignment:
        isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Bubble(style: ChatMessage.styleSomebody, child: Text(msg)),
            ],
          )
          : Bubble(
              style: ChatMessage.styleMe,
              child: Text(msg),
            );
    } else if (type == "2") {
      return Column(
        crossAxisAlignment:
            isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          ContainerWithDecorationImage(msg, w: 150.0, h: 150.0),
        ],
      );
    } else if (type == "3") {
      return Column(
        crossAxisAlignment:
            isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          VideoPlayerCard(msg),
        ],
      );
    }else if (type == "6") {
      return Column(
        crossAxisAlignment:
        isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          LocationCard(msg),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment:
        isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
           AudioCard(msg, isSender),
        ],
      );
    }
  }
}

