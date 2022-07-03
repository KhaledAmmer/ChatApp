import 'package:flutter/material.dart';

BuildFlotationButton({icon,text,function}){

  return  Padding(
    padding: const EdgeInsets.only(top: 2.0,),
    child: FloatingActionButton(
      backgroundColor: Colors.black,
      onPressed: function,
      heroTag: 'image1',
      tooltip: text,
      child:  Icon(icon,color: Colors.white),
    ),
  );
}