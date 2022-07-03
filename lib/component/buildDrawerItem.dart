import 'package:flutter/material.dart';

import 'Icon.dart';

DrawerItem({icon,text,fun}){

  return GestureDetector(
    onTap: ()async{fun();},
    child: Card(
      color: Colors.blueGrey.shade600,
      child: Row(children: [
        buildIcon(icon:icon,color:Colors.white,size: 30.0,fun: ()async{fun();}),
        SizedBox(width: 20,),
        Text(text,style: TextStyle(fontSize: 22,color: Colors.white),),
      ],),
    ),
  );

}