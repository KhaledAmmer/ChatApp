import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:khaledchat/style/boxDecoration.dart';

FToast f = FToast();

toastMsg(String msg, context) {
  f.init(context);
  return f.showToast(
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
          decoration: BoxDecoration(
              color: Colors.blueGrey.shade300,
              borderRadius: BorderRadius.circular(20)),
          width: msg.length <= 30 ? 170 : 270,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              msg,
              style: TextStyle(color: Colors.white, fontSize: 14),
              textAlign: msg.length <= 30 ? TextAlign.center : TextAlign.start,
            ),
          )),
    ),
    gravity: ToastGravity.SNACKBAR,
    toastDuration: Duration(seconds: 3),
  );
  // msg: msg,
  // toastLength: Toast.LENGTH_LONG,
  // gravity: ToastGravity.BOTTOM,
  // timeInSecForIosWeb: 1,
  // backgroundColor: Colors.blue,
  // textColor: Colors.white,
  // fontSize: 16.0);
}
