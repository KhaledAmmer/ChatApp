import 'package:flutter/cupertino.dart';

class MapProvider with ChangeNotifier{
  var log=0.0;
  var lat=0.0;
  var marker=[];

  getPos(l,lo){
    lat=l;
    log=lo;
    notifyListeners();
  }
  setMark(mr){
    marker=mr;
    notifyListeners();
  }


}