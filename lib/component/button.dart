import 'package:flutter/material.dart';

button({text,textcolor,bcolor ,myfun}){
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Material(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80)),
      color: bcolor,
      child: MaterialButton(
        onPressed: myfun,
        child: Text(text,style: TextStyle(color: textcolor,fontSize: 20),),
        height: 40,
      ),
    ),
  );



}