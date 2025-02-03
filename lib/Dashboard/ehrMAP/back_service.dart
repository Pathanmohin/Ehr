import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:ehr/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';


const notificationChannelId = 'my_foreground';

String Lap = "";

String Long = "";


  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

// this will be used for notification id, So you can update your custom notification with this id.
const notificationId = 888;

Future<void> initializeService() async {

Timer tr;

  final service = FlutterBackgroundService();
  
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    notificationChannelId, // id
    'MY FOREGROUND SERVICE', // title
    description:

        'This channel is used for important notifications.', // description

    importance: Importance.high, // importance must be at low or higher level
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await service.configure(

    androidConfiguration: AndroidConfiguration(
      // this will be executed when app is in foreground or background in separated isolate
      onStart: onStart,

      // auto start service
      autoStart: true,
      isForegroundMode: true,

      notificationChannelId: notificationChannelId, // this must match with notification channel you created above.
      initialNotificationTitle: 'NSCSPL eHR',
      initialNotificationContent: 'Initializing',
      foregroundServiceNotificationId: notificationId,
      
    ), 
    

    iosConfiguration: IosConfiguration(
    autoStart: true,
    onForeground: onStart,
    onBackground: onIosBackground,

    ),

  );

}


@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {

  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  return true;
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service){
  DartPluginRegistrant.ensureInitialized();
  if(service is AndroidServiceInstance){

service.on('setAsForeground').listen((event) {
  service.setAsForegroundService();
  
});

service.on('setAsBackground').listen((event) {
  service.setAsBackgroundService();
});

service.on('stopServices').listen((event) {
  service.stopSelf();

});







// Set up periodic location updates
    Timer.periodic(const Duration(seconds: 30), (timer) async {
      try {
        // Fetch current position
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );

        // Log position details (Optional)
        print('Position fetched: Latitude ${position.latitude}, Longitude ${position.longitude}');

        // Call _onINPress and wait for completion
        await _onINPress(position);

        // Call OnGetAttendence after _onINPress
        await OnGetAttendence();

        // Optionally send location data if needed
       // await _sendLocationData(position);
      } catch (e) {
        print('Error fetching position or processing data: $e');
      }
    });
  }

}





int count = 0;


//-----------------------------------------inpresssssss------------------------//


  DateTime _currentDate = DateTime.now(); // Variable to hold current date

  File? _inImage;
  File? _outImage;
  String format = '';
  final ImagePicker _picker = ImagePicker();
  Position? _currentPosition;
  String? _latitude;
  String? _longitude;
  String? selectedType1;
  double currentTime = 0.0;
  double intym = 0.0;
  double outtym = 0.0;
  int Flag=0;
  String? imgStr;
  String status = "";
  String inTime='00:00';
  String outTime='00:00';
  String InTime='';
  String OutTime='';
  String OutTimee="";
  double outt=00.00;
  
  double inData=00.00;


  bool InButton=false;
  bool INButton=true;
  String insertinn='';
  String inFlag='';




TimeOfDay _selectedINTime = TimeOfDay.now();
TimeOfDay _selectedOUTTime = TimeOfDay.now();
  
Future<void> _onINPress(Position position) async {
  try {
    var position = await Geolocator.getCurrentPosition(
      // ignore: deprecated_member_use
      desiredAccuracy: LocationAccuracy.medium,
    );

     _latitude = position.latitude.toString();
      _longitude = position.longitude.toString();

    double currentTime = double.parse(
      DateTime.now().toString().substring(11, 16).replaceAll(":", "."),
    );
    double intym = double.parse(
      _selectedINTime.toString().substring(10, 15).replaceAll(":", "."),
    );
    double outtym = intym - 0.05;

    // if (intym > currentTime) {
    //   await _showDialog(context, "Alert", "In time is greater than current time..!");
    //   return;
    // }

    InTime = _selectedINTime.toString().substring(10, 15);
    if (InTime == "00:00") {
      InTime = DateTime.now().toString().substring(11, 16);
    }
    status = "I";
    await OnGetAttendence();
  } catch (e) {
    print('Error in checkBiometrics: $e');
    
   // await _showDialog(context, 'Error', 'An error occurred. Please try again.');

  }
}



Future<void> OnGetAttendence()async
{
   // await EasyLoading.show(status: 'Marking Attendance');




SharedPreferences prefs = await SharedPreferences.getInstance();

ServerDetails serverDetails = ServerDetails();

String kid = prefs.getString('EmpKid')!;
String attendenceP = selectedType1.toString().split('-')[0];
DateTime now = DateTime.now();
OutTime = DateFormat('HH:mm:ss').format(now);

if(status=="O"){

if(format=="am"){
  TimeOfDay _selectedOUTTime = TimeOfDay.now();
String formatTimeOfDay(TimeOfDay time) {
  final hours = time.hour.toString().padLeft(2, '0');
  final minutes = time.minute.toString().padLeft(2, '0');
  return "$hours:$minutes";
}String formattedTime = formatTimeOfDay(_selectedOUTTime);
  String OutTimee = formattedTime; // Set formatted time to OutTimee
//   OutTimee = _selectedOUTTime.toString().substring(10, 15);
//  int index = OutTimee.lastIndexOf(":");
//  OutTimee = OutTimee.substring(0, index);
 if (OutTimee == "00:00:00")
 {
      OutTimee = DateFormat("HH:mm").format(DateTime.now());
 }
 OutTimee = OutTimee.replaceAll(":", ".");
 OutTimee = OutTimee.replaceAll(".00", "");
 OutTimee = OutTimee.replaceAll(" PM", "");
 OutTimee = OutTimee.replaceAll(" AM", "");

 // String outTimee = formatOutTime(outTimePicker);
  // Convert the formatted string to decimal
  double outt = double.parse(OutTimee);
// outt = convert.ToDecimal(OutTimee);

if(outt>=inData){
  String value = 'MobAttendanceMobile|$kid||$InTime|$OutTime|$attendenceP|$_latitude|$_longitude|$imgStr|$status';

final String restUrl = '${AppCongifP.apiurllink}/${AppCongifP.applicationName}/ServiceData.aspx';

var response = await http.post(
  Uri.parse(restUrl),
  body: {
    'values': value,
  },
);

try {
  if (response.statusCode == HttpStatus.ok) {
    String content = response.body;
   // await EasyLoading.dismiss();

    print('Authenticate Response: $content');

    if (content != "Saved Succesfully") {
      // if (content.isEmpty) {
      //   await _showAlert("Alert", "Something went wrong!!!!", "OK");
      // } else {
      //   await _showAlert("Alert", content, "OK");
      //   insertinn=inTime;
      //   InButton=true;
      //   INButton=false;
      // }
    } else {
      Flag = 2;
     // OnGetResponce();

      
    }
  }
} catch (e) {
  print('ERROR: $e');
 // await _showAlert("Alert", "Unable to connect to the server", "OK");
}
}
}
else{
TimeOfDay _selectedOUTTime = TimeOfDay.now();
String formatTimeOfDay(TimeOfDay time) {
  final hours = time.hour.toString().padLeft(2, '0');
  final minutes = time.minute.toString().padLeft(2, '0');
  return "$hours:$minutes";
} String formattedTime = formatTimeOfDay(_selectedOUTTime);
  String OutTimee = formattedTime; //
  // OutTimee = _selectedOUTTime.toString();
// int index = OutTimee.lastIndexOf(":");
 //OutTimee = OutTimee.substring(0, index);
 if (OutTimee == "00:00:00")
 {
    OutTimee = DateFormat("HH:mm").format(DateTime.now());
 }
 OutTimee = OutTimee.replaceAll(":", ".");
 OutTimee = OutTimee.replaceAll(".00", "");
 OutTimee = OutTimee.replaceAll(" PM", "");
 OutTimee = OutTimee.replaceAll(" AM", "");

 // String outTimee = formatOutTime(outTimePicker);
  // Convert the formatted string to decimal
  double outt = double.parse(OutTimee);
// outt = convert.ToDecimal(OutTimee);

if(outt>=inData){
  String value = 'MobAttendanceMobile|$kid||$InTime|$OutTime|$attendenceP|$_latitude|$_longitude|$imgStr|$status';

final String restUrl = '${AppCongifP.apiurllink}/${AppCongifP.applicationName}/ServiceData.aspx';

var response = await http.post(
  Uri.parse(restUrl),
  body: {
    'values': value,
  },
);

try {
  if (response.statusCode == HttpStatus.ok) {
    String content = response.body;
   // await EasyLoading.dismiss();

    print('Authenticate Response: $content');

    if (content != "Saved Succesfully") {
      // if (content.isEmpty) {
      //   await _showAlert("Alert", "Something went wrong!!!!", "OK");
      // } else {
      //   await _showAlert("Alert", content, "OK");
      //   insertinn=inTime;
      //   InButton=true;
      //   INButton=false;
      // }
    } else {
       Flag = 2;
     // OnGetResponce();

      // await _showAlert("Alert", content, "OK");
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => Dashboard()),
      // );
    }
  }
} catch (e) {
  print('ERROR: $e');
//  await _showAlert("Alert", "Unable to connect to the server", "OK");
}
}
}
}


else{
String value = 'MobAttendanceMobile|$kid||$InTime|$OutTime|$attendenceP|$_latitude|$_longitude|$imgStr|$status';

final String restUrl = '${AppCongifP.apiurllink}/${AppCongifP.applicationName}/ServiceData.aspx';

var response = await http.post(
  Uri.parse(restUrl),
  body: {
    'values': value,
  },
);

try {
  if (response.statusCode == HttpStatus.ok) {
    String content = response.body;
   // await EasyLoading.dismiss();

    print('Authenticate Response: $content');

    if (content != "Saved Succesfully") {
     
    } else {
      Flag = 1;
    
    }
  }
} catch (e) {
  print('ERROR: $e');
 // await _showAlert("Alert", "Unable to connect to the server", "OK");
}
}
//await EasyLoading.dismiss();
}


Future<void> _sendLocationData(Position position) async {

SharedPreferences  prefs = await SharedPreferences.getInstance();

 if (position.latitude != 0 || position.longitude != 0) {

 // Prepare your data to be sent

var url = Uri.parse('http://192.168.1.120:8590/CobaSys/rest/SalePortal/V1/saveLocationInfo');

  // Prepare your data to be sent
      var data = {"usrKid":"1", "Latitude":position.latitude.toString(),"Longitude": position.longitude.toString(),"JourneyName":prefs.getString("keyJourney")};

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

    // Await the response and then check if the request was successful (status code 200)
    if (response.statusCode == 200) {
      
       Fluttertoast.showToast(
        msg: ' ${response.body}',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
        );

// notification logic here..........

    _showNotification;

    Lap = position.latitude.toString();
    Long = position.longitude.toString();



    } else {

       Fluttertoast.showToast(
        msg: 'Failed with status code: ${response.statusCode}',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
        );


    }
  } on SocketException catch (e) {


       Fluttertoast.showToast(
        msg: 'Socket Exception: $e',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
        );

    // Handle socket errors
    print('Socket Exception: $e');
  } catch (e) {



       Fluttertoast.showToast(
        msg: 'Exception: $e',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
        );

    // Handle any other exceptions
    print('Exception: $e');
  }
  }
    }



 Future<void> _showNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      '123', // Channel ID
      'Alert Msg', // Channel name
       // Channel description
      importance: Importance.high,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0, // Notification ID
      'Hello User', // Notification title
      'Your location does not change please provide a valid reason..', // Notification body
      platformChannelSpecifics,
      payload: 'Custom_Sound', // Optional, can be used to handle notification tap
    );
  }
  

  
