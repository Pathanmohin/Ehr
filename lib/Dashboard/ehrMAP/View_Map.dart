import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:ehr/Dashboard/ehrMAP/models/vobject.dart';
import 'package:ehr/app.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geocoding/geocoding.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with WidgetsBindingObserver {
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = Set();
  late GoogleMapController mapController;
  List<LatLng> polylineCoordinates = [];
  List<MyClass> getCorLocation = [];
  bool _isApiCalling = true;
  Position? _currentPosition;
  late Timer _timer;
  late Timer _tm;

  bool isLoading = true;

  final List<Exercise> exercises = [];

  @override
  void initState() {
    super.initState();
    ehrMapDataLegLog();
    _startApiCalls();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    _stopApiCalls();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _startApiCalls() {
    _tm = Timer.periodic(const Duration(seconds: 1), (timer) async {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {});
      _markers.add(Marker(
        markerId: const MarkerId("1"),
        position: LatLng(position.latitude, position.longitude),
        infoWindow: const InfoWindow(title: "NSCSPL", snippet: "Online"),
      ));
    });

    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_isApiCalling) {
        ehrMapDataLegLog();
      }
    });
  }

  void _stopApiCalls() {
    _timer.cancel();
    _tm.cancel();
  }

  //-------------------------------------------ehrMAPdAtaVikassssss----------------------------//

  Future<void> ehrMapDataLegLog() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      ServerDetails serverDetails = ServerDetails();

      String empKid = prefs.getString('EmpKid') ?? '';
      String restUrl =
          '${AppCongifP.apiurllink}/${AppCongifP.applicationName}/ServiceData.aspx?callFor=AttendanceLocation&EmpId=$empKid&idate=2024/11/15';

      debugPrint('URL: ${restUrl.replaceAll(' ', '')}');

      var uri = Uri.parse(restUrl.replaceAll(' ', ''));
      var response = await http.get(uri);

      debugPrint('Response: ${response.statusCode}');

      if (response.statusCode == 200) {
        var content = response.body;
        // var responseList = json.decode(content) as List;
        List ab = json.decode(content);

        if (ab.length == 0) {
          return;
        }

        for (int i = 0; i < ab.length; i++) {
          MyClass my = new MyClass();

          my.userKid = ab[i]["EmpAttendData_EmpID"].toString();

          my.Loclat = ab[i]["EmpAttendData_inlatitude"].toString();
          my.LocDate = ab[i]["EmpAttendData_Date"].toString();
          my.Loclong = ab[i]["EmpAttendData_inlongitude"].toString();

          List<Placemark> placemarks = await placemarkFromCoordinates(
              double.parse(my.Loclat), double.parse(my.Loclong));

          Placemark placemark = placemarks[0];

          double dis;

          if (i == 0) {
            dis = calculateDistance(0.0, 0.0, 0.0, 0.0);
          } else {
            dis = calculateDistance(
                double.parse(getCorLocation[i - 1].Loclat),
                double.parse(getCorLocation[i - 1].Loclong),
                double.parse(my.Loclat),
                double.parse(my.Loclong));
          }

          String d = dis.toStringAsFixed(2);

          double minu = double.parse(d);

          String date = my.LocDate;

          List<String> parts = date.split(' ')[1].split(':');
          String time = "${parts[0]}:${parts[1]}:${parts[2]}";

          exercises.add(
            new Exercise(
              address:
                  "${placemark.name}, ${placemark.locality}, ${placemark.administrativeArea}, ${placemark.country}",
              distance: minu,
              minutes: time,
              isCompleted: true,
            ),
          );

          getCorLocation.add(my);
        }
      }
    } catch (e) {
      print("Error: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  //-------------------------------------------ehrMAPdAtaVikassssss----------------------------//

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371;
    double dLat = _degreesToRadians(lat2 - lat1);
    double dLon = _degreesToRadians(lon2 - lon1);
    lat1 = _degreesToRadians(lat1);
    lat2 = _degreesToRadians(lat2);
    double a =
        pow(sin(dLat / 2), 2) + pow(sin(dLon / 2), 2) * cos(lat1) * cos(lat2);
    return earthRadius * 2 * atan2(sqrt(a), sqrt(1 - a));
  }

  double _degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Map'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(26.9124, 75.7873),
              zoom: 12,
            ),
            onMapCreated: onMapCreated,
            markers: _markers,
            polylines: {
              Polyline(
                polylineId: const PolylineId('route'),
                color: Colors.blue,
                width: 5,
                points: polylineCoordinates,
              ),
            },
            zoomGesturesEnabled: true, // Enables zoom gestures
            scrollGesturesEnabled: true, // Enables map scrolling
            tiltGesturesEnabled: true, // Enables tilt gestures
            rotateGesturesEnabled: true, // Enables rotation
            myLocationEnabled: true, // Shows user location on the map
            myLocationButtonEnabled:
                true, // Adds a button to center map on user location
            compassEnabled: true, // Enables the compass
            indoorViewEnabled:
                true, // Enables indoor maps (for specific locations)
            mapType: MapType
                .normal, // Choose map type (normal, satellite, terrain, hybrid)
            // trafficEnabled: true,           // Shows traffic conditions
            buildingsEnabled:
                true, // Adds a button to center map on user location
          ),
          const Positioned(
            bottom: 20,
            right: 16,
            left: 16,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              // children: [
              //   ActionButton(
              //     text: 'End Journey',
              //     onPressed: () async {
              //       SharedPreferences prefs =
              //           await SharedPreferences.getInstance();
              //       prefs.remove("journey");
              //       prefs.remove("keyJourney");
              //       setState(() {
              //         _isApiCalling = false;
              //       });
              //     },
              //   ),
              //   const SizedBox(height: 5),
              //   ActionButton(
              //     text: 'Show Timeline',
              //     onPressed: () {
              //       if (getCorLocation.isEmpty) {
              //         Fluttertoast.showToast(
              //           msg: "Please wait 10 seconds...",
              //           toastLength: Toast.LENGTH_SHORT,
              //           gravity: ToastGravity.CENTER,
              //           textColor: Colors.white,
              //           fontSize: 16.0,
              //         );
              //         return;
              //       }
              //       showModalBottomSheet(
              //           context: context,
              //           builder: (context) => TimelineView(exercises: exercises));
              //     },
              //   ),
              // ],
            ),
          ),
        ],
      ),
    );
  }

  void onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
    mapController = controller;
  }

  void _addPolyline() {
    polylineCoordinates.clear();
    for (int i = 0; i < getCorLocation.length; i++) {
      double lat = double.parse(getCorLocation[i].Loclat);
      double long = double.parse(getCorLocation[i].Loclong);
      setState(() {
        polylineCoordinates.add(LatLng(lat, long));
      });
    }
  }
}

// ActionButton Widget for reuse in map screen
class ActionButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  ActionButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepPurple,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          minimumSize: const Size.fromHeight(50)),
      child:
          Text(text, style: const TextStyle(color: Colors.white, fontSize: 20)),
    );
  }
}

// Exercise class for Timeline (add fields as needed)
class Exercise {
  final String address;
  final double distance;
  final String minutes;
  final bool isCompleted;

  Exercise(
      {required this.address,
      required this.distance,
      required this.minutes,
      required this.isCompleted});
}

// MyClass for location data handling
// class MyClass {
//   String Loclat;
//   String Loclong;
//   String LocDate;

//   MyClass({required this.Loclat, required this.Loclong, required this.LocDate});

//   factory MyClass.fromJson(Map<String, dynamic> json) {
//     return MyClass(
//       Loclat: json['Loclat'],
//       Loclong: json['Loclong'],
//       LocDate: json['LocDate'],
//     );
//   }
// }

// TimelineView placeholder - Implement the UI for the timeline view
class TimelineView extends StatelessWidget {
  final List<Exercise> exercises;

  TimelineView({required this.exercises});

  @override
  Widget build(BuildContext context) {
    return Container(
      // UI implementation for showing exercises/timeline
      child: ListView.builder(
        itemCount: exercises.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(exercises[index].address),
            subtitle: Text(
                '${exercises[index].distance} km at ${exercises[index].minutes}'),
          );
        },
      ),
    );
  }
}
