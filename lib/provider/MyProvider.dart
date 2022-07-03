import 'dart:async';

import 'package:flutter/material.dart';


class MyProvider with ChangeNotifier{
  bool isVis = false;
  bool isChatCardExtand=false;


  bool isRecording=false;
  Color iconColor=Colors.black;
  IconData recordIcon = Icons.mic_none;

  isVisable(){
    isVis=!isVis;
    notifyListeners();
  }

  recorderState(){
    print(isRecording);
    if(isRecording){
      iconColor=Colors.black;
      recordIcon = Icons.mic_none;
      isRecording=false;
    }
    else{
      iconColor=Colors.red;
      recordIcon = Icons.stop;
      isRecording=true;
    }
notifyListeners();

  }

  isExtand(){
    isChatCardExtand=!isChatCardExtand;
    notifyListeners();

  }



}