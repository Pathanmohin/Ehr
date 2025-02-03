import 'dart:convert';
import 'dart:math';
import 'package:ehr/Dashboard/Dashboard.dart';
import 'package:ehr/Dashboard/ehrMAP/models/vobject.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:http/http.dart' as http;


class ShowTimeLine extends StatefulWidget {

   List<MyClass> getCorLocation;

  ShowTimeLine(this.getCorLocation);



  @override
  // ignore: no_logic_in_create_state
  State<StatefulWidget> createState() => _ShowTimeLineState(getCorLocation);

  

}


class _ShowTimeLineState extends State<ShowTimeLine> {
  Set<Marker> _markers = Set();
 



    late GoogleMapController mapController;


List<LatLng> polylineCoordinates = [];



Position? _currentPosition;


    // getting the size of the window

final List<Exercise> exercises = [];

   List<MyClass> getCorLocation = [];

  _ShowTimeLineState(this.getCorLocation);


@override
void initState() {
  super.initState();

  // Clear the exercises list to prepare for new data
  exercises.clear();

  // Extract the first latitude and longitude
  if (getCorLocation.isNotEmpty) {
    double firstLatitude = double.parse(getCorLocation[0].Loclat);
    double firstLongitude = double.parse(getCorLocation[0].Loclong);

    // Use the extracted latitude and longitude, for example, to set the initial camera position or for other operations
    print("First Latitude: $firstLatitude");
    print("First Longitude: $firstLongitude");
  } else {
    print("The getCorLocation list is empty.");
  }

  // Call the timeline processing
  timeLine();
}



double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
  const double earthRadius = 6371; // in kilometers

  // Convert degrees to radians
  double dLat = _degreesToRadians(lat2 - lat1);
  double dLon = _degreesToRadians(lon2 - lon1);

  // Convert latitudes to radians
  lat1 = _degreesToRadians(lat1);
  lat2 = _degreesToRadians(lat2);

  // Apply Haversine formula
  double a = pow(sin(dLat / 2), 2) +
      pow(sin(dLon / 2), 2) * cos(lat1) * cos(lat2);
  double c = 2 * atan2(sqrt(a), sqrt(1 - a));

  // Calculate the distance
  double distance = earthRadius * c;
  return distance;
}

double _degreesToRadians(double degrees) {
  return degrees * pi / 180;
}



 @override
  Widget build(BuildContext context) {

          double lat =  double.parse( getCorLocation[0].Loclat);
          double long =  double.parse(getCorLocation[0].Loclong);

   var size = MediaQuery.of(context).size; 
   
    var height = size.height;

    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Google Map with Polyline'),
      // ),
     appBar: AppBar(
  title: const Text(
                  "View Journey",
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: "TimesNewRoman",
                      fontSize: 18),
                ),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  color: Colors.white,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Dashboard()),
                    );
                  },
                ),
        backgroundColor: Colors.blue,
),

      
      body: Stack(
        children: [
         GoogleMap(
  initialCameraPosition: CameraPosition(
    target: getCorLocation.isNotEmpty
        ? LatLng(
            double.parse(getCorLocation[0].Loclat),
            double.parse(getCorLocation[0].Loclong),
          )
        : LatLng(0.0, 0.0),
    zoom: 14.0,
  ),
  onMapCreated: onMapCreated,
  markers: {
    Marker(
      markerId: MarkerId('red_marker'),
      position: getCorLocation.isNotEmpty
          ? LatLng(
              double.parse(getCorLocation[0].Loclat),
              double.parse(getCorLocation[0].Loclong),
            )
          : LatLng(0.0, 0.0),
      draggable: true,// Allows dragging the marker
      onDragEnd: (newPosition) {
        print('New position: $newPosition'); // Handle new marker position
      },
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    ),
  },
  polylines: {
    Polyline(
      polylineId: PolylineId('route'),
      color: Colors.blue,
      width: 3, // Adjusted for better visibility
      points: polylineCoordinates,
    ),
  },
  zoomGesturesEnabled: true,      // Enables zoom gestures
  scrollGesturesEnabled: true,    // Enables map scrolling
  tiltGesturesEnabled: true,      // Enables tilt gestures
  rotateGesturesEnabled: true,    // Enables rotation
  myLocationEnabled: true,        // Shows user location on the map
  myLocationButtonEnabled: true,  // Adds a button to center map on user location
  compassEnabled: true,           // Enables the compass
  indoorViewEnabled: true,        // Enables indoor maps (for specific locations)
  mapType: MapType.normal,        // Choose map type (normal, satellite, terrain, hybrid)
  trafficEnabled: true,           // Shows traffic conditions
  buildingsEnabled: true,         // Shows 3D buildings (if available)
  gestureRecognizers: Set()
    ..add(Factory<PanGestureRecognizer>(() => PanGestureRecognizer()))
    ..add(Factory<ScaleGestureRecognizer>(() => ScaleGestureRecognizer()))
    ..add(Factory<TapGestureRecognizer>(() => TapGestureRecognizer()))
    ..add(Factory<VerticalDragGestureRecognizer>(() => VerticalDragGestureRecognizer()))
),


          Positioned(
            
            bottom: 20,
            right: 16,
            left: 16,
              
              
            
            child: Column(

              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
            
            

               GestureDetector(
                  
                    
                    onTap: () {
                       
                       
                       

                        setState(() {
                          
                        });

                         showMaterialModalBottomSheet(
                              context: context,
                              builder: (context) => SingleChildScrollView(
                                controller: ModalScrollController.of(context),
                                child:  Container(

                                margin: EdgeInsets.only(top:10),

                                  child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              height: 500,
                                              child: ListView.builder(
                                                itemCount: exercises.length,
                                                itemBuilder: (context, index) {
                                                  return CustomTimelineTile(
                                                    isFirst: index == 0,
                                                    isLast: index == exercises.length - 1,
                                                    exercise: exercises[index],
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),

                                )
                              ),
                          );
                    
                    },
                  
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      width: 250,
                      height: 55,
                      decoration: BoxDecoration(
                        
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Center(child: const Text('Show Timeline',style: TextStyle(color: Colors.white,fontSize: 20),)),
                    ),
                  ),
            
              ],
            )

          ),

        ],
      ),
    );
  }

  void onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });

    // Draw polyline
  _addPolyline();

  }

void _addPolyline() async{  

for(int i =0;i<getCorLocation.length;i++){

      double lat =  double.parse( getCorLocation[i].Loclat);
     double long =  double.parse(getCorLocation[i].Loclong);

    polylineCoordinates.add(new LatLng(lat, long)); // San Francisco

    setState(() {});
  
}

setState(() {});


  }




  
  void timeLine() async{

exercises.clear();

  for(int i =0;i<getCorLocation.length;i++){

        List<Placemark> placemarks = await placemarkFromCoordinates(double.parse(getCorLocation[i].Loclat), double.parse(getCorLocation[i].Loclong));

        Placemark placemark = placemarks[0];
    
        double dis;
        double totalDistance = 0.0;


for (int i = 0; i < getCorLocation.length - 1; i++) {
  // Parse the latitude and longitude for the current and next points
  double lat1 = double.parse(getCorLocation[i].Loclat);
  double long1 = double.parse(getCorLocation[i].Loclong);
  double lat2 = double.parse(getCorLocation[i + 1].Loclat);
  double long2 = double.parse(getCorLocation[i + 1].Loclong);

  // Calculate distance between current and next point
  double disss = calculateDistance(lat1, long1, lat2, long2);

  // Accumulate the total distance
  totalDistance += disss;

  
}

          String distt =  totalDistance.toStringAsFixed(2);
          double distanminu = double.parse(distt);




            if(i == 0){
       
         dis = calculateDistance(0.0,0.0,0.0,0.0);

            }else{

        dis = calculateDistance(double.parse(getCorLocation[i].Loclat), double.parse(getCorLocation[i].Loclong),double.parse(getCorLocation[i+1].Loclat), double.parse(getCorLocation[i+1].Loclong));
            
            }

          String d =  dis.toStringAsFixed(2);
          double minu = double.parse(d);

        String date = getCorLocation[i].LocDate;

        List<String> parts = date.split(' ')[1].split(':');
        String time = "${parts[0]}:${parts[1]}:${parts[2]}";

         exercises.add(
         new  Exercise(

        address:"${placemark.name}, ${placemark.locality}, ${placemark.administrativeArea}, ${placemark.country}",
        distance: minu,
        minutes: time,
       // totaldistance: distanminu,
        isCompleted: true,
        

      ),

      
      );

      setState(() {
        
      });

         }

  }

}




class CustomTimelineTile extends StatelessWidget {
  final bool isFirst;
  final bool isLast;
  final Exercise exercise;

  const CustomTimelineTile({super.key, 
    required this.isFirst,
    required this.isLast,
    required this.exercise,
  });


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Expanded(
        child: TimelineTile(
          isFirst: isFirst,
          isLast: isLast,
          indicatorStyle: IndicatorStyle(
            width: 30,
            height: 30,
            color: exercise.isCompleted ? Colors.green : Colors.grey,
            indicator: Container(
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                 color: exercise.isCompleted ? Colors.green : Colors.grey,
              ),
              child: exercise.isCompleted 
              ?const Center(child: Icon(Icons.check),)
              :const SizedBox()
              )
          ),
          afterLineStyle: LineStyle(
            thickness: 1,
            color: exercise.isCompleted ? Colors.green : Colors.grey,
          ),
          beforeLineStyle: LineStyle(
            thickness: 1,
            color: exercise.isCompleted ? Colors.green : Colors.grey,
          ),
          endChild: ExerciseCard(exercise: exercise),
        ),
      ),
    );
  }
}


class ExerciseCard extends StatelessWidget {
  final Exercise exercise;

  const ExerciseCard({super.key, required this.exercise});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      
      child: Card(
        
        child: ListTile(
          leading: const Icon(Icons.pedal_bike_sharp),
          title: Text(exercise.address),
          subtitle: Text('${exercise.distance} km | ${exercise.minutes} min'),
        ),
      ),
    );
  }
}

class Exercise {
  final String address;
  final double distance;
  final String minutes;
  bool isCompleted;

  Exercise({

    required this.address,
    required this.distance,
    required this.minutes,
    this.isCompleted = false,

  });
}




