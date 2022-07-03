import 'package:flutter/material.dart';

text({text,size,textColor,al=TextAlign.left}){
  return Text(text,style: TextStyle(fontSize: size,color: textColor,fontWeight: FontWeight.w900,),textAlign: al,);

}