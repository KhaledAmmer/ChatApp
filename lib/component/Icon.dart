import 'package:flutter/material.dart';
buildIcon({icon ,fun,color,size}){
    return IconButton(
          icon: Icon(icon,size: size,color: color,),
          onPressed: () async{
            fun();
          }
    );

}