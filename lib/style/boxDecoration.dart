import 'package:flutter/material.dart';

boxDecoration(){
  return BoxDecoration(
    gradient: LinearGradient(colors: [
      Colors.white,
      Color.fromRGBO(88, 134, 147, 0.7098039215686275)
    ]),
  );
}





ContainerWithDecorationImage(imageUrl,{w=150.0,h=150.0,bool isLocale=false}){
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      height: h,
      width: w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(0.7),
        image: DecorationImage(image: NetworkImage(imageUrl) ,fit: BoxFit.contain)


      ),),
  );


}
