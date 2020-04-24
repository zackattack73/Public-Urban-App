import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'database.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/services.dart' show rootBundle;
import 'package:geolocator/geolocator.dart';

final dbHelper = DatabaseHelper.instance;

class map extends StatefulWidget {
  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<map> {
  final Set<Marker> _markers = {};
  List data = [];

  Completer<GoogleMapController> _controller = Completer();

  static const LatLng _center = const LatLng(45.1667, 5.7167);

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  @override
  void initState() {
    super.initState();
    dbHelper.getObjets("Banc").then((result) {
      setState(() {
        data = result;
        for (var mark in data) {
          LatLng pos =
              new LatLng(double.parse(mark["lat"]), double.parse(mark["long"]));
          _markers.add(Marker(
            // This marker id can be anything that uniquely identifies each marker.
            markerId: MarkerId(mark["_id"].toString()),
            position: pos,
            infoWindow: InfoWindow(
              title: "Banc : " + mark["date"].toString(),
              snippet: 'Adresse :' + mark["adresse"].toString(),
            ),
            icon: BitmapDescriptor.fromAsset("lib/assets/small_banc.png"),
          ));
        }
        /*_markers.add(Marker(
          // This marker id can be anything that uniquely identifies each marker.
          markerId: MarkerId("Dummy 1"),
          position: new LatLng(45.21074672084329, 5.789438046093778),
          infoWindow: InfoWindow(
            title: 'Test icon Gmap',
            snippet: 'Color = Red',
          ),
          icon: BitmapDescriptor.defaultMarker,
        ));
        _markers.add(Marker(
          // This marker id can be anything that uniquely identifies each marker.
          markerId: MarkerId("Dummy 2"),
          position: new LatLng(45.212036, 5.792885),
          infoWindow: InfoWindow(
            title: 'Test icon Gmap 2',
            snippet: 'Color = Blue',
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ));*/
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Carte des objets'),
          backgroundColor: Colors.green[700],
        ),
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          markers: _markers,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 13.0,
          ),
        ),
      ),
    );
  }
}
