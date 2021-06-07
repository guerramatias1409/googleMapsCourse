import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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

  @override
  void initState() {
    getIcon();
    super.initState();
  }

  void getIcon() async {
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(devicePixelRatio: 2.5), 'img/arrow.png')
        .then(
      (_icon) => setState(() => this.icon = _icon),
    );
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
              mapType: mapType,
              initialCameraPosition: CameraPosition(
                target: position,
                zoom: 11,
              ),
              markers: this.icon != null ? {
                Marker(
                  markerId: MarkerId(position.toString()),
                  position: position,
                  icon: this.icon,
                ),
              } : {},
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8, right: 8),
              child: SpeedDial(
                animatedIcon: AnimatedIcons.menu_close,
                overlayColor: Colors.black,
                overlayOpacity: 0.5,
                elevation: 8.0,
                children: [
                  SpeedDialChild(
                    label: 'Normal',
                    child: Icon(Icons.room),
                    onTap: () => setState(() => mapType = MapType.normal),
                  ),
                  SpeedDialChild(
                    label: 'Satelite',
                    child: Icon(Icons.satellite),
                    onTap: () => setState(() => mapType = MapType.satellite),
                  ),
                  SpeedDialChild(
                    label: 'Hibrido',
                    child: Icon(Icons.compare),
                    onTap: () => setState(() => mapType = MapType.hybrid),
                  ),
                  SpeedDialChild(
                    label: 'Terreno',
                    child: Icon(Icons.terrain),
                    onTap: () => setState(() => mapType = MapType.terrain),
                  )
                ],
              ),
            )
          ],
        ));
  }

  void onDragEnd(LatLng position) {
    print('new position $position');
  }
}
