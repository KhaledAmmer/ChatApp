
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:khaledchat/component/text.dart';
import 'package:khaledchat/style/boxDecoration.dart';

userCard({image,userName,fun,n}){

  return Padding(
    padding: const EdgeInsets.all(2.0),
    child: GestureDetector(
      onTap: fun,
      child: Card(
        elevation: 5,
        shadowColor: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.black45,width: 1)
        ),
        color: n==0?Colors.blueGrey.shade600:Colors.blueAccent,
        child:Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment(0.9,1),
              child: Container(
                height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: n!=0?Colors.white:Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  child: Center(child: Text(n!=0?"$n":"",style: TextStyle(fontSize: 20),))),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ContainerWithDecorationImage(image,w:80.0,h:80.0),
                ),
                Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    text(text: userName,size: 20.0,textColor: Colors.white),
                    SizedBox(height: 16,),
                  ],
                ))
              ],
            ),
          ],
        ),
      ),
    ),
  );



}
currentUsercard(QueryDocumentSnapshot<Map<String, dynamic>> e) {
  return Container(
      margin: EdgeInsets.only(left: 20.0,top: 10),
      width: 80,
      height: 80,
      child: Row(
        children: [
          ContainerWithDecorationImage(e["ImageUrl"],w: 60.0,h: 60.0),
          Text(e["userName"],style: TextStyle(fontSize: 14,color: Colors.white),)
        ],
      )


  );
}


Widget userStat({status,userName,fun}){

  return  GestureDetector(
      onTap: fun,
      child: Container(
        margin:const EdgeInsets.all(4.0) ,
        color: Colors.blueGrey,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            children: [
              Container(
                height: 90.0,
                width: 90.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(image: NetworkImage(status),fit: BoxFit.contain)
                          ),
                         )
                    ),

              ),
            ],
          ),
        ),
      ),

  );



}