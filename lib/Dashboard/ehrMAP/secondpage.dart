import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:ehr/Dashboard/Dashboard.dart';
import 'package:ehr/Dashboard/Travel%20Request/travelrequest.dart';
import 'package:ehr/Dashboard/ehrMAP/Show_TimeLine.dart';
import 'package:ehr/Dashboard/ehrMAP/models/vobject.dart';
import 'package:ehr/app.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:selectable_list/selectable_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SecondRoute extends StatefulWidget {  @override
  State<StatefulWidget> createState() => _SecondRouteState();
}


class SelectedDate {
  
  static DateTime _selectedDate = DateTime.now();

  static DateTime get selectedDate => _selectedDate;

  static void setDate(DateTime newDate) {
    _selectedDate = newDate;


  }

}




class _SecondRouteState extends State<SecondRoute>{

  // List of items for the dropdown
  final List<String> items = ['Option 1', 'Option 2', 'Option 3', 'Option 4'];
  List<Rechargmobile> fromAccountList = [];

  // Selected item
  String? selectedItem;

 // Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = Set();
  late GoogleMapController mapController;
  List<LatLng> polylineCoordinates = [];
  List<MyClass> getCorLocation = [];
  bool _isApiCalling = true;
  Position? _currentPosition;
  late Timer _timer;
  late Timer _tm;
  Rechargmobile? selectedEmailTo;
  String? emailid;

   var subordinateee;
   String getBillers = "";
   String billerNamee = "";

  final List<Exercise> exercises = [];



  bool isLoading = true;



 //List<JourneyList> list = [];



  String? selectedName;



final EasyInfiniteDateTimelineController _controller =

      EasyInfiniteDateTimelineController();

      TextEditingController idController = new TextEditingController();

      late String dateTime;

      late DateTime date;



      final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
        
  foregroundColor: Colors.white, backgroundColor: Color.fromARGB(96, 75, 32, 230),
  minimumSize: Size(88, 36),
  padding: EdgeInsets.symmetric(horizontal: 16),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(2)),
  ),
);





@override
  void initState() { 
    super.initState();
    SubordinateMAPData();
  }



// String dropdownvalue = 'Select'; 

  @override
  Widget build(BuildContext context) {
   return Scaffold(
   appBar: AppBar( title: const Text(
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
        
   actions: [
    IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Notification',
            onPressed: () {
           //Navigator.push(context, MaterialPageRoute(builder: (context)=> NotifiactionAlert()));

            },
          ), 
   ],
   
   backgroundColor: Colors.blue,),



    body: Padding(
      padding: const EdgeInsets.all(15.0),
      
      child: Column(
        
        
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
      
        children: [


          // Dropdown Section
             buildDropdownField<Rechargmobile>(labelText: "Subordinate",  items: fromAccountList, selectedItem: selectedEmailTo, onChanged: (value) {
                setState(() {
                  selectedEmailTo = value;
                  emailid=selectedEmailTo?.kid.toString();

                });
              },displayText: (item1)=>"${item1.EmpName} "),


      
             
      
        EasyDateTimeLine(

        initialDate: SelectedDate.selectedDate,
      
        onDateChange: (DateTime selectedDate) {
          //`selectedDate` the new date selected.

          SelectedDate.setDate(selectedDate);

          String date = "${SelectedDate.selectedDate.year}/${SelectedDate.selectedDate.month}/${SelectedDate.selectedDate.day}";

        

        },


        headerProps: const EasyHeaderProps(
          monthPickerType: MonthPickerType.switcher,
          dateFormatter: DateFormatter.fullDateDMY(),
        ),
        dayProps: const EasyDayProps(
          dayStructure: DayStructure.dayStrDayNum,
          activeDayStyle: DayStyle(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xff3371FF),
                  Color(0xff8426D6),
                ],
              ),
            ),
          ),
        ),
      ),
      
      SizedBox(height: 25),


            
      
      


         
   GestureDetector(
  // When the child is tapped, show a snackbar.
   onTap: () {

   String date = "${SelectedDate.selectedDate.year}/${SelectedDate.selectedDate.month}/${SelectedDate.selectedDate.day}";
 if (selectedEmailTo == null || selectedEmailTo?.isEmpty == true) {
  // Show an alert if no email is selected
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Alert'),
        content: Text('No Subordinate selected. Please choose Subordinate.'),
        actions: [
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
// } else if (getCorLocation.isEmpty) {
//   // Show an alert if the list is empty
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title: Text('Alert'),
//         content: Text('No locations available. Please add locations.'),
//         actions: [
//           TextButton(
//             child: Text('OK'),
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//           ),
//         ],
//       );
//     },
//   );
} 





    ehrMapDataLegLog(date);

    // getCorLocation.clear();

    // postData(idController,date,);

     },

  // The custom button
  child: Container(
    padding: const EdgeInsets.all(12),
    height: 55,
    width: 200,
    decoration: BoxDecoration(
      
      color: Colors.lightBlue,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Center(child: const Text("Show  Journey",style: TextStyle(fontSize: 18,color: Colors.white),)),
  ),
)
      ],
      
      ),
    ),
   );
  }

Widget buildDropdownField<T>({
    required String labelText,
    required List<T> items,
    required T? selectedItem,
    required Function(T?) onChanged,
    required String Function(T) displayText, // Function to display text for each item
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, fontFamily: "TimesNewRoman", color: Color(0xFF547EC8)),
        ),
        DropdownButton<T>(
          isExpanded: true,
          value: selectedItem,
          hint: const Text("Select", style: TextStyle(fontSize: 15, fontFamily: "TimesNewRoman", color: Colors.black)),
          items: items.map((T item) {
            return DropdownMenuItem<T>(
              value: item,
              child: Text(displayText(item), style: const TextStyle(fontSize: 15, fontFamily: "TimesNewRoman", color: Colors.black)),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
  //---------------------------------------vikassssmapdatata-------------------------------//

  
Future<void> ehrMapDataLegLog(date) async {
  String Date = date;
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    ServerDetails serverDetails = ServerDetails();
    String empKid = prefs.getString('EmpKid') ?? '';
    String restUrl = '${AppCongifP.apiurllink}/${AppCongifP.applicationName}/ServiceData.aspx?callFor=AttendanceLocation&EmpId=$emailid&idate=$date';
    
    debugPrint('URL: ${restUrl.replaceAll(' ', '')}');
    
    var uri = Uri.parse(restUrl.replaceAll(' ', ''));
    var response = await http.get(uri);
    
    debugPrint('Response: ${response.statusCode}');
    
    if (response.statusCode == 200) {
      var content = response.body;
     // var responseList = json.decode(content) as List;
      List ab = json.decode(content);

      if(ab.length == 0){
     return;}   

getCorLocation.clear();
     
for(int i=0;i<ab.length;i++){

MyClass my = new MyClass();

my.userKid = ab[i]["EmpAttendData_EmpID"].toString();

my.Loclat = ab[i]["EmpAttendData_inlatitude"].toString();
my.LocDate = ab[i]["EmpAttendData_Date"].toString();
my.Loclong = ab[i]["EmpAttendData_inlongitude"].toString();




List<Placemark> placemarks = await placemarkFromCoordinates(double.parse(my.Loclat), double.parse(my.Loclong));

        Placemark placemark = placemarks[0];
    
         double dis;
            
            if(i == 0){

         dis = calculateDistance(0.0,0.0,0.0,0.0);

           

            }else{
        dis = calculateDistance(double.parse(getCorLocation[i-1].Loclat), double.parse(getCorLocation[i-1].Loclong),double.parse(my.Loclat), double.parse(my.Loclong));
            }

          String d =  dis.toStringAsFixed(2);

          double minu = double.parse(d);

        String date = my.LocDate;

        List<String> parts = date.split(' ')[1].split(':');
        String time = "${parts[0]}:${parts[1]}:${parts[2]}";

         exercises.add(
         new  Exercise(
        address:"${placemark.name}, ${placemark.locality}, ${placemark.administrativeArea}, ${placemark.country}",
        distance: minu,
        minutes: time,
       // totaldistance: minu,
        isCompleted: true,
      ),

      
      );
  
    
     getCorLocation.add(my);    


}
                            
      
      
      Navigator.push(context, MaterialPageRoute(builder: (context) => ShowTimeLine(getCorLocation)));

      
      
      
      
      
      
      
    }
  } catch (e) {
    print("Error: $e");
    setState(() {
      isLoading = false;
    });
  }
}



Future<void> SubordinateMAPData() async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    ServerDetails serverDetails = ServerDetails();
   
    String empKid = prefs.getString('EmpKid') ?? '';
    String restUrl = '${AppCongifP.apiurllink}/${AppCongifP.applicationName}/ServiceData.aspx?callfor=subordinatedetails&empcode=$empKid';
    


      final response = await http.get(Uri.parse(restUrl));

      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(response.body);
        setState(() {
          fromAccountList = jsonData.map((data) => Rechargmobile.fromJson(data)).toList();
        
        });
      } else {
        throw Exception('Failed ');
      }
    } catch (e) {
      print('ERROR: $e');
      setState(() {
        
      });
            //  _showAlertDialog("Alert", "Unable to Connect to the Server");

          }


  //   debugPrint('URL: ${restUrl.replaceAll(' ', '')}');
    
  //   var uri = Uri.parse(restUrl.replaceAll(' ', ''));
  //   var response = await http.get(uri);
    
  //   debugPrint('Response: ${response.statusCode}');
    
  //   if (response.statusCode == 200) {
  //     var content = response.body;
  //     var responseList = json.decode(content) as List;

      
  // // Parse the JSON response body
      

      
  //           int all = 0;
  //           for (var config in responseList) {
  //             Rechargmobile vObject = new Rechargmobile();

  //             vObject.biller_id = config["kid"];
  //             vObject.biller_name = config["EmpName"];

  //             fromAccountList.add(vObject);
  //           }
      
      
  //   }
  } 
}




  //-------------------------------------------ehrMAPdAtaVikassssss----------------------------//


  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371;
    double dLat = _degreesToRadians(lat2 - lat1);
    double dLon = _degreesToRadians(lon2 - lon1);
    lat1 = _degreesToRadians(lat1);
    lat2 = _degreesToRadians(lat2);
    double a = pow(sin(dLat / 2), 2) +
        pow(sin(dLon / 2), 2) * cos(lat1) * cos(lat2);
    return earthRadius * 2 * atan2(sqrt(a), sqrt(1 - a));
  }

  double _degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }




Future<void> getAllJourney(String date) async {

  String Date = date;

//list.clear();

  // Define the endpoint URL
  var url = Uri.parse('http://192.168.1.120:8590/CobaSys/rest/SalePortal/V1/getLocationHistory');

  // Prepare your data to be sent
  var data = {"usrKid":"1","Date":date,"JourneyName": "-1"};

  // Encode your data to JSON
  var jsonData = jsonEncode(data);

  try {
    
    // Make the POST request
    var response = await http.post(      
      url,

      headers: <String, String>{
        
        'Content-Type': 'application/json; charset=UTF-8',

      },

      body: jsonData,

    );

   
    if (response.statusCode == 200) {
      
       
var a = response.body;

Map<String, dynamic> decodedResponse = json.decode(a);
var getData = decodedResponse["Data"];

//var dataGet = JsonEncoder(getData);

List ab = json.decode(getData);

if(ab.length == 0){


Fluttertoast.showToast(
        msg: "No Journey Found.....",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0
    );

  return;

}

for(int i=0;i<ab.length;i++){

//JourneyList data = new JourneyList();


//data.JourneyName = ab[i]["JourneyName"].toString();

////list.add(data);

}


//Navigator.push(context, MaterialPageRoute(builder: (context) => JourneyListAv(list,Date)));


    } else {
      // Handle error if any
      print('Failed with status code: ${response.statusCode}');

    }
  } on SocketException catch (e) {
    // Handle socket errors
    print('Socket Exception: $e');
  } catch (e) {
    // Handle any other exceptions
    print('Exception: $e');
  }
}

class Rechargmobile {
   final int kid;
   final String EmpName;
   

  Rechargmobile({
    required this.kid,
     required this.EmpName,
     

  });

  factory Rechargmobile.fromJson(Map<String, dynamic> json) {
    return Rechargmobile(
      kid: json['kid'] ,
      EmpName: json["EmpName"],
      
    );
  }
  
  get isEmpty => null;
}



