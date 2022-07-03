
import 'package:khaledchat/LocalDataBase/Modlue.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


class Databasehelper {
  static final _databaseName = "books.db";
  static final _databaseVersion = 1;


  static final _messagetable="mtable";
  static final message="msg";
  static final sender="snd";
  static final reciever="rec";
  static final time="time";
  static final type="type";




  //singleTone object **
  Databasehelper._privateConstructor();
  static final Databasehelper instance = Databasehelper._privateConstructor();

  static late Database _database;

  _initDatabase() async {
    String path = join(await getDatabasesPath(),_databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }


  get database async {
    _database = await _initDatabase();
    return _database;
  }

// this method use to create tables in database file
  _onCreate(Database db, int version) async {
    await db.execute(
        'create table $_messagetable($reciever text, $message text, $sender text,$type text, $time text)');
  }


  insert(Message b) async {
    Database db = await instance.database;
    return await db.insert(_messagetable, {message : b.text, sender: b.sender,time:b.time,type:b.type,reciever:b.reciever});
  }



  Future<int> update(Message b) async {
    Database db = await instance.database;
    return await db.update(_messagetable, b.toMap(), where: '$sender=?',whereArgs: [b.time,b.text]);
  }



  getMessages() async {
    Database db = await instance.database;
    return await db.query(_messagetable);
  }


  FindMessage(msg,name) async{
    Database db = await instance.database;
    return await db.query(_messagetable, where: "$message like '%$msg%' and $reciever like '%$name%'");
  }
}
