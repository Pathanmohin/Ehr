import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class IconOnMap extends StatefulWidget {
  @override
  _IconOnMapState createState() => _IconOnMapState();
}

class _IconOnMapState extends State<IconOnMap> {
  Completer<BitmapDescriptor> _customMarkerCompleter = Completer<BitmapDescriptor>();

  @override
  void initState() {
    super.initState();
    _loadCustomMarker();
  }

  Future<void> _loadCustomMarker() async {
    // Load the image byte data from asset
    ByteData byteData = await DefaultAssetBundle.of(context).load('assets/person_icon.png');
    Uint8List byteList = byteData.buffer.asUint8List();

    // Create the bitmap descriptor from byte data
    final BitmapDescriptor bitmapDescriptor = BitmapDescriptor.fromBytes(byteList);

    // Set the custom marker completed with the bitmap descriptor
    _customMarkerCompleter.complete(bitmapDescriptor);
  }

  // Example coordinates
  final LatLng iconCoordinate = LatLng(51.5, -0.09); // London coordinates

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _customMarkerCompleter.future,
      builder: (context, AsyncSnapshot<BitmapDescriptor> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          ); 
        }
        if (snapshot.hasError) {
          return Center(
            child: Text('Error loading marker icon.'),
          );
        }
        final BitmapDescriptor customMarker = snapshot.data!;

        return GoogleMap(
          initialCameraPosition: CameraPosition(
            target: iconCoordinate,
            zoom: 12.0,
          ),
          markers: {
            Marker(
              markerId: MarkerId('marker_1'),
              position: iconCoordinate,
              icon: customMarker,
            ),
          },
        );
      },
    );
  }
}