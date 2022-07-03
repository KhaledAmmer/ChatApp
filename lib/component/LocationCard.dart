import 'package:flutter/material.dart';
import 'package:khaledchat/Api/googleMap/GoMap.dart';
class LocationCard extends StatefulWidget {
  final msg;
  LocationCard(this.msg);

  @override
  _LocationCardState createState() => _LocationCardState();
}

class _LocationCardState extends State<LocationCard> {
  var isClicked=false;
  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (_){
          return ShowMap(widget.msg);
        }));
      },
      child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
                width: MediaQuery.of(context).size.width / 3,
              height: MediaQuery.of(context).size.width / 3,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 1),
                ),
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Container(
                        height: MediaQuery.of(context).size.width / 2,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black12, width: 1),
                          image: DecorationImage(image: AssetImage("assets/images/loc.png")),
                        )
                        ),


                  ],
                ),
              ),),
    );
  }
}

class ShowMap extends StatefulWidget {
  final msg;
  ShowMap(this.msg);

  @override
  _ShowMapState createState() => _ShowMapState();
}
class _ShowMapState extends State<ShowMap> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:Colors.transparent,
        elevation: 0.0,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: GoMap().BuildMap(context, widget.msg),
      ),
    )
    ;
  }
}

