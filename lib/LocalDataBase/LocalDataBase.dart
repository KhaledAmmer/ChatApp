


import 'package:khaledchat/LocalDataBase/Databasehelper1.dart';

import 'Modlue.dart';

class LocaleDataBase {
  static final LocaleDataBase db = LocaleDataBase();
  static final Databasehelper _db=Databasehelper.instance;

  Future<List<Message>> getMessages(String sender, String reciver) async {
    List<Message> msg=[];
    var msgs=await _db.getMessages();
    for(var x in msgs){
      if(x["sender"]==sender && msgs["reciever"]==reciver){
        msg.add(Message(
            text: x["text"],
           type: x["type"],
            sender: x["sender"],
            reciever: x["reciever"],
            time: x["time"]
        ));
      }
    }
    return msg;
  }

  insertMessages(Message msg) async {
   await _db.insert(msg);
  }
}
