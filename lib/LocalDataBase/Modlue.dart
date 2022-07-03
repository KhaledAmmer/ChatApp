import 'package:khaledchat/LocalDataBase/Databasehelper1.dart';

class Message{

  final text;
  final sender;
  final reciever;
  String type="";
  String time="";

  Message({this.text,required this.type,this.sender,this.reciever,required this.time});


  toMap(){
    return {
      Databasehelper.time:this.time,
      Databasehelper.sender:this.sender,
      Databasehelper.reciever:this.reciever,
      Databasehelper.type:this.type,
      Databasehelper.message:this.text,
    };


  }


}