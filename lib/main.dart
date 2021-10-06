import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  /// Control and access the map with [mapController].
  late GoogleMapController mapController;

  /// Set of [Marker] which is shown on map.
  final Set<Marker> _markers = {};

  /// Object which stores the image to make into a [Marker].
  late BitmapDescriptor mapMarker;

  @override
  void initState() {
    super.initState();
    setCustomMarker();
  }

  /// Convert the [AssetImage] to [BitmapDescriptor]
  void setCustomMarker() async {
    mapMarker = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(),
      'image/marker.png',
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      /// Add the first [Marker] to the set.
      _markers.add(Marker(
        markerId: const MarkerId("Pot hole here"),
        icon: mapMarker,
        position: _center,
      ));
    });
    mapController = controller;
  }

  /// The location of delhi
  final LatLng _center = const LatLng(
    28.65,
    77.23,
  );

  /// Puts a marker at the current map location
  ///
  /// Warning: Not on the physical current location
  void add_marker() async {
    LatLng _marker_pos = await mapController
        .getLatLng(ScreenCoordinate(
          x: 500,
          y: 1000,
        ))
        .then((value) => value);
    _markers.add(Marker(
      markerId: MarkerId("${_markers.length}"),
      icon: mapMarker,
      position: _marker_pos,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Pothole'),
          backgroundColor: Colors.green[700],
        ),
        body: Stack(
          children: [
            GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 11.0,
              ),
              buildingsEnabled: true,
              markers: _markers,
            ),
            Positioned(
              bottom: 50,
              right: 10,
              child: FloatingActionButton(
                onPressed: add_marker,
                child: Icon(Icons.add),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
