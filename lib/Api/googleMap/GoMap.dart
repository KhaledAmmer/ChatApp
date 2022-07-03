import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:khaledchat/Api/googleMap/MapProvider.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GoMap {
  static final goMap = GoMap();
  static double _lng = 35.95504311205601;
  static double _lat = 31.96928903193283;
  static var _cameraPos = CameraPosition(target: LatLng(_lat, _lng), zoom: 18);
  static List<Marker> _markers = [];
  static Completer<GoogleMapController> _completer = Completer();
  static late GoogleMapController _mapController;

  Future<List<double>> GetCurrentPositions() async {
    var position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    _lng = position.longitude;
    _lat = position.latitude;
    return [_lat, _lng];
  }

  Future<void> GetStreamPositions(context) async {
    Geolocator.getPositionStream(desiredAccuracy: LocationAccuracy.high)
        .listen((position) {
      _lng = position.longitude;
      _lat = position.latitude;
      Provider.of<MapProvider>(context, listen: false).getPos(_lat, _lng);
    });
  }

  Future<Placemark> GetCurrentAddreas() async {
    await GetCurrentPositions();
    var addrees = await placemarkFromCoordinates(_lat, _lng);
    return addrees[0];
  }

  Future<void> _GetCameraPostition() async {
    await GetCurrentPositions();
    _cameraPos = CameraPosition(target: LatLng(_lat, _lng), zoom: 18);
    _mapController.animateCamera(CameraUpdate.newCameraPosition(_cameraPos));
  }

  Widget BuildMap(context,String msg) {
    for(int i=0;i<msg.length;i++){
      if(msg[i]=="+"){
        _lat=double.parse(msg.substring(0,i));
        _lng=double.parse(msg.substring(i+1,msg.length));
        break;
      }
    }
    print("$msg"+"***$_lat"+"****$_lng");
    var latLng=LatLng(_lat, _lng);
    _markers.add(Marker(markerId: MarkerId(latLng.toString()),position: latLng));

    return GoogleMap(
      onTap: (LatLng latLng) {},
      initialCameraPosition: _cameraPos,
      myLocationButtonEnabled: true,
      mapType: MapType.satellite,
      markers: Set.from(_markers),
      myLocationEnabled: true,
      onMapCreated: (controller) {
        _completer.complete(controller);
        _mapController = controller;
      },
    );
  }

  _SetMarker(LatLng latLng, context)  {
    _cameraPos = CameraPosition(
        target: LatLng(latLng.latitude, latLng.longitude), zoom: 18);

    var m = Marker(
        markerId: MarkerId(latLng.toString()),position: latLng);
   _markers.clear();
    _markers.add(m);
    Provider.of<MapProvider>(context, listen: false).setMark(_markers);
    _mapController.animateCamera(CameraUpdate.newCameraPosition(_cameraPos));
  }

  _getMarkesFromFirebase(context) async {
    _markers.clear();
    var icon1;
    await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.5),
      "image/k.png",
    ).then((value) {
      icon1 = value;
    });

    await FirebaseFirestore.instance.collection("hotales").get().then((value) {
      value.docs.forEach((latlng) {
        var m = Marker(
          markerId: MarkerId("${LatLng(latlng["lat"], latlng["lng"])}"),
          icon: icon1,
          position: LatLng(latlng["lat"], latlng["lng"]),
        );
        _markers.add(m);
      });
    });

    Provider.of<MapProvider>(context, listen: false).setMark(_markers);
  }
}
