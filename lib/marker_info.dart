import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MarkerInfo extends StatefulWidget {
  final String title;
  final LatLng latLng;
  final String image;

  const MarkerInfo({this.title, this.latLng, this.image});

  @override
  _MarkerInfoState createState() => _MarkerInfoState();
}

class _MarkerInfoState extends State<MarkerInfo> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      height: 70,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(50)),
          color: Colors.white),
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(left: 10),
            width: 50,
            height: 50,
            child: ClipOval(
              child: Image.asset(
                widget.image,
                fit: BoxFit.contain,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 20),
            child: Column(
              children: [
                Text(
                  widget.title,
                  style: TextStyle(color: Colors.greenAccent),
                ),
                Text(
                  'Latitud: ${widget.latLng.latitude}',
                  style: TextStyle(color: Colors.grey),
                ),
                Text(
                  'Longitud: ${widget.latLng.longitude}',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
