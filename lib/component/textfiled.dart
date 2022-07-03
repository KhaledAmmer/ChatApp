import 'package:flutter/material.dart';

textfiled({ onSubmitted,cor,kt,isPw,hint,fillcolor=Colors.transparent,txcolor=Colors.black,onTap}){

  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 2,vertical: 10),
    child: TextField(
      onTap: onTap==null?(){}:onTap,
      onSubmitted:onSubmitted==null?(_){}:onSubmitted,
      controller: cor,
      keyboardType: kt,
      obscureText: isPw,
      decoration: InputDecoration(
        filled: true,
        fillColor: fillcolor,
        hintText: hint,
        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(24)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(24)),
          borderSide: BorderSide(color: Colors.blueAccent, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(24)),
          borderSide: BorderSide(color: Colors.blueAccent, width: 1),
        ),
      ),
    ),
  );


}


textfiled1({sufFun,max=25,prefix,cor,kt,isPw,hint,fillcolor=Colors.transparent}){

  return Padding(
    padding: EdgeInsets.all(2),
    child: Container(
      child: TextField(
        controller: cor,
        keyboardType: kt,
        obscureText: isPw,
        maxLength: max,
        decoration: InputDecoration(
          counterStyle: TextStyle(color: Colors.white),
            filled: true,
            fillColor: fillcolor,
          hintText: hint,
          contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(24)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(24)),
            borderSide: BorderSide(color: Colors.blueAccent, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(24)),
            borderSide: BorderSide(color: Colors.blueAccent, width: 1),
          ),
          prefixIcon:Icon(prefix,size: 30,),
          prefix: SizedBox(width: 10,),
          suffixIcon: (hint=="Enter E-Mail"|| hint=="User Name"|| hint=="Enter your Code")?null: IconButton(onPressed: (){sufFun();},icon:Icon(Icons.remove_red_eye))

        ),
      ),
    ),
  );


}