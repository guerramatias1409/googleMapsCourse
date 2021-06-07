import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_course/marker_info.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as lc;
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  LatLng position = LatLng(-34.58720957992827, -58.64496244855623);
  MapType mapType = MapType.normal;
  BitmapDescriptor icon;
  bool infoShown = false;
  GoogleMapController controller;
  LatLng latLngOnLongPress;
  lc.Location location;

  @override
  void initState() {
    getIcon();
    requestPerms();
    super.initState();
  }

  void requestPerms() async {
    print('request params');
    Map<Permission, PermissionStatus> statuses =
        await [Permission.locationAlways].request();

    var status = statuses[Permission.locationAlways];
    if (status == PermissionStatus.granted) {
      print('permission granted');
      enableGPS();
    } else {
      print('permission denied');
      requestPerms();
    }
  }

  void enableGPS() async {
    print('enable gps');
    location = lc.Location();
    bool serviceStatusResult = await location.requestService();
    if (!serviceStatusResult) {
      print('no habilito gps');
      enableGPS();
    } else {

    }
  }

  void getIcon() async {
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(devicePixelRatio: 2.5), 'img/arrow.png')
        .then(
      (_icon) => setState(() => this.icon = _icon),
    );
  }

  void onDragEnd(LatLng position) {
    print('new position $position');
  }

  void onMapCreated(GoogleMapController _controller) {
    this.controller = _controller;
  }

  void onTapMap(LatLng latLng) {
    print('onTapMap $latLng');
  }

  void onLongPressMap(LatLng latLng) async {
    print('onLongPress');
    latLngOnLongPress = latLng;
    showPopMenu();
  }

  void showPopMenu() async {
    String selected = await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(200, 200, 250, 250),
      items: [
        PopupMenuItem<String>(
          child: Text('Que hay aqui'),
          value: 'Que Hay',
        ),
        PopupMenuItem<String>(
          child: Text('Ir a'),
          value: 'Ir',
        ),
      ],
      elevation: 8,
    );
    if (selected != null) getValue(selected);
  }

  void getValue(String value) {
    if (value == 'Que Hay') print('Ubicacion $latLngOnLongPress');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Stack(
          children: [
            GoogleMap(
              //Activar o desactivar brujula
              compassEnabled: false,
              //Activar o desactivar barra de herramientas
              mapToolbarEnabled: true,
              // Activar o desactivar informacion de trafico
              trafficEnabled: true,
              // Activar o desactivar edificios 3D
              buildingsEnabled: true,

              // Activar o desactivar gestos
              rotateGesturesEnabled: true,
              scrollGesturesEnabled: true,
              zoomControlsEnabled: false,
              tiltGesturesEnabled: false,

              mapType: mapType,
              initialCameraPosition: CameraPosition(
                target: position,
                zoom: 1,
                bearing: 0,
                tilt: 45,
              ),
              // Manejar cuando la camara se empieza a mover
              onCameraMoveStarted: () {
                print('inicio');
              },
              // Manejar cuando la camara deja de moverse
              onCameraIdle: () {
                print('fin');
              },
              // Maneja cuando la camara se esta moviendo
              onCameraMove: (CameraPosition cameraPosition) {
                print('Moviendo ${cameraPosition.target}');
              },

              onTap: onTapMap,
              onLongPress: onLongPressMap,

              // Limitar la camara
              // cameraTargetBounds: CameraTargetBounds(
              //   LatLngBounds(
              //     northeast: LatLng(40.73215972821489, -73.980936957489),
              //     southwest: LatLng(40.7152797683329, -74.01919598687743),
              //   ),
              // ),

              // Limitar el zoom de la camara
              // minMaxZoomPreference: MinMaxZoomPreference(1, 10),
              onMapCreated: onMapCreated,
              markers: this.icon != null
                  ? {
                      Marker(
                          markerId: MarkerId(position.toString()),
                          position: position,
                          icon: this.icon,
                          onTap: () => setState(() {
                                //Mover camara a una nueva posicion al hacer click
                                controller.animateCamera(
                                    CameraUpdate.newCameraPosition(
                                        CameraPosition(
                                  target: LatLng(63.637353, 83.914375),
                                  zoom: 10,
                                )));
                                this.infoShown = !this.infoShown;
                              })),
                    }
                  : {},
            ),
            // Padding(
            //   padding: const EdgeInsets.only(bottom: 8, right: 8),
            //   child: SpeedDial(
            //     animatedIcon: AnimatedIcons.menu_close,
            //     overlayColor: Colors.black,
            //     overlayOpacity: 0.5,
            //     elevation: 8.0,
            //     children: [
            //       SpeedDialChild(
            //         label: 'Normal',
            //         child: Icon(Icons.room),
            //         onTap: () => setState(() => mapType = MapType.normal),
            //       ),
            //       SpeedDialChild(
            //         label: 'Satelite',
            //         child: Icon(Icons.satellite),
            //         onTap: () => setState(() => mapType = MapType.satellite),
            //       ),
            //       SpeedDialChild(
            //         label: 'Hibrido',
            //         child: Icon(Icons.compare),
            //         onTap: () => setState(() => mapType = MapType.hybrid),
            //       ),
            //       SpeedDialChild(
            //         label: 'Terreno',
            //         child: Icon(Icons.terrain),
            //         onTap: () => setState(() => mapType = MapType.terrain),
            //       )
            //     ],
            //   ),
            // ),
            Visibility(
              child: MarkerInfo(
                title: 'Mi Ubicacion',
                latLng: this.position,
                image: 'img/arrow.png',
              ),
              visible: this.infoShown,
            ),
          ],
        ));
  }
}
