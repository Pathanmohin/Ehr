// ignore_for_file: non_constant_identifier_names, prefer_final_fields

import 'dart:collection';
import 'dart:convert';
import 'dart:typed_data';

import 'package:ehr/Dashboard/BackDateAuthorizeList.dart';
import 'package:ehr/Dashboard/Dashboard.dart';
import 'package:ehr/Dashboard/RegularAttendance.dart';
import 'package:ehr/Dashboard/ehrMAP/back_service.dart';
import 'package:ehr/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:local_auth/local_auth.dart';
import 'package:profile_view/profile_view.dart';

import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';

class AttendancePage extends StatefulWidget {
  const AttendancePage({super.key});

  @override
  _AttendancePageState createState() => _AttendancePageState();
}

class Attenddata {
  final String date;
  final String inTime;
  final String outTime;
  final String totalTime;

  Attenddata({
    required this.date,
    required this.inTime,
    required this.outTime,
    required this.totalTime,
  });

  factory Attenddata.fromJson(Map<String, dynamic> json) {
    return Attenddata(
      date: json['DateCol'],
      inTime: json['InTime'],
      outTime: json['OutTime'],
      totalTime: json['TotalTime'],
    );
  }
}

class ParameterAttendencelist {
  final int kid;
  final String value;
  final String text;

  ParameterAttendencelist({
    required this.kid,
    required this.value,
    required this.text,
  });

  factory ParameterAttendencelist.fromJson(Map<String, dynamic> json) {
    return ParameterAttendencelist(
      kid: json['kid'],
      value: json['value'],
      text: json['text'],
    );
  }
}

class MyAttendanceDetail {
  String totalTime;
  String status;

  MyAttendanceDetail({
    required this.totalTime,
    required this.status,
  });

  factory MyAttendanceDetail.fromJson(Map<String, dynamic> json) {
    return MyAttendanceDetail(
      totalTime: json['totalTime'],
      status: json['status'],
    );
  }
}

class _AttendancePageState extends State<AttendancePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: WillPopScope(
        onWillPop: () async {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Dashboard()));
          return false;
        },
        child: Builder(builder: (context) {
          return MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: const TextScaler.linear(1.1)),
            child: Scaffold(
              appBar: AppBar(
                title: const Text(
                  "Attendance Tabbed",
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
                bottom: TabBar(
                  isScrollable: true,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.grey[300],
                  labelStyle: const TextStyle(
                    fontFamily: 'TimesNewRoman',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontFamily: 'TimesNewRoman',
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                  tabs: const [
                    Tab(text: 'Attendance Marking'),
                    Tab(text: 'Attendance Approval'),
                    Tab(text: 'Regularize Attendance'),
                    // Tab(text: 'Work from home'),
                    //  Tab(text: 'Authorize WFH'),
                    
                  ],
                ),
              ),
              body: TabBarView(
                children: [
                  const AttendanceMarkingTab(),
                  BackdateauthorizelistPage(),
                  RegularattendancePage(),
                  //AttendanceCalendar(),
                  // Center(child: Text('Work from home')),
                  //Center(child: Text('Authorize WFH')),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class AttendanceMarkingTab extends StatefulWidget {
  const AttendanceMarkingTab({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AttendanceMarkingTabState createState() => _AttendanceMarkingTabState();
}

class _AttendanceMarkingTabState extends State<AttendanceMarkingTab> {
  final LocalAuthentication auth = LocalAuthentication();
  TextEditingController insertin = TextEditingController();
  TimeOfDay _selectedINTime = TimeOfDay.now();
  TimeOfDay _selectedOUTTime = TimeOfDay.now();
  String? _formattedINTime = "";
  String? _formattedOUTTime = ""; // String to hold formatted time
  bool _isINButtonEnabled = true;
  bool _isOUTButtonEnabled = false;
  bool _isStartButtonEnabled = true;
  bool _isEndButtonEnabled = false;
  bool _isInclock = false;
  bool _isOutclock = false;

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
  int Flag = 0;
  String? imgStr;
  String status = "";
  String inTime = '00:00';
  String outTime = '00:00';
  String InTime = '';
  String OutTime = '';
  String OutTimee = "";
  double outt = 00.00;

  double inData = 00.00;

  bool InButton = false;
  bool INButton = true;
  String insertinn = '';
  String inFlag = '';

  //----------------------------------------------//
  bool StartButton = false;
  bool OFFButton = false;

  bool outbutttonnnn = true;

  bool isSwitched = false;
  bool isButtonEnabled = false;

  bool inMohn = true;
  bool outmohn = true;

  String MESSAGE = "";

  String EmpAttendPara_Empidd = "";
  String EmpAttendPara_AttendanceRequredd = "";
  String EmpAttendPara_AttendAllowMobilee = "";
  String EmpAttendPara_LocationAlloww = "";
  String EmpAttendPara_PictureAlloww = "";
  String EmpAttendPara_AttendJurnanyAlloww = "";
  String EmpAttendPara_AttendJurnanyEveryMinutee = "";
  String EmpAttendPara_Jurananynotfoundminutee = "";
  String EmpAttendPara_JurananyAbsentLeaveMarkk = "";

  List<Attenddata> trends = [];
  List<ParameterAttendencelist> trends1 = [];
  List<MyAttendanceDetail> attendss = [];

  String empName = "";
  String empDesignation = "";
  String pre = "";

  @override
  void initState() {
    super.initState();
    // dataFound();
    DateTime now = DateTime.now();

    // Format the current time as "hh:mm:ss"
    OutTime = DateFormat('HH:mm:ss').format(now);
    InTime = DateFormat('HH:mm:ss').format(now);
    _getCurrentLocation();
    attend();
    OnGetparameter();
    OnGetResponce();
    getProfile();
  }

  void getProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    pre = await prefs.getString('source').toString();
    empName = await prefs.getString('name') ?? '';
    empDesignation = await prefs.getString('dsg_ename') ?? '';
  }

  // Widget _buildProfileImage(String base64Image) {
  //   if (base64Image.isNotEmpty) {
  //     Uint8List imageBytes = base64Decode(base64Image);
  //     return Center(
  //       child: CircleAvatar(
  //         radius: 50,
  //         backgroundImage: MemoryImage(imageBytes),
  //       ),
  //     );
  //   } else {
  //     return const Center(
  //       child: CircleAvatar(
  //         radius: 50,

  //         backgroundImage: AssetImage('assets/images/profileuser.png'),
  //       ),
  //     );
  //   }
  // }

  Widget buildProfileView(String base64Image, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: ProfileView(
        image: base64Image.isNotEmpty
            ? MemoryImage(base64Decode(base64Image)) // Decode base64 image
            : const AssetImage('assets/images/profileuser.png'),
        height: 100, // Adjust height
        width: 100, // Adjust width
        circle: true, // Circular profile view
        borderRadius: 0.0, // Ignored when `circle` is true
      ),
    );
  }

// Future<void> dataFound() async {
//      try
//      {
//     SharedPreferences prefs = await SharedPreferences.getInstance();

//     setState(() {
//       EmpAttendPara_Empidd = prefs.getString("EmpId") ?? '';
//       EmpAttendPara_AttendanceRequredd = prefs.getString("AttendanceRequired") ?? '';

//       EmpAttendPara_LocationAlloww = prefs.getString("LocationAllow") ?? '';
//       EmpAttendPara_PictureAlloww = prefs.getString("PictureAllow") ?? '';
//       EmpAttendPara_AttendAllowMobilee = prefs.getString("AttendAllowMobile") ?? '';
//       EmpAttendPara_AttendJurnanyAlloww = prefs.getString("AttendJurnanyAllow") ?? '';
//       EmpAttendPara_AttendJurnanyEveryMinutee = prefs.getString("AttendJurnanyEveryMinute") ?? '';
//       EmpAttendPara_Jurananynotfoundminutee = prefs.getString("JurananyNotFoundMinute") ?? '';
//       EmpAttendPara_JurananyAbsentLeaveMarkk = prefs.getString("JurananyAbsentLeaveMark") ?? '';

//        // Check each parameter individually and show an alert if it's empty

//     if (EmpAttendPara_AttendanceRequredd== "false") {
//       showAlert("Pleae Allow Attendence .");
//       return;
//     }
//     if (EmpAttendPara_LocationAlloww.isEmpty=="false") {
//       showAlert("Please Allow Location.");
//       return;
//     }
//     if (EmpAttendPara_PictureAlloww=="false") {
//       showAlert("Please Allow picture.");
//       return;
//     }
//     if (EmpAttendPara_AttendAllowMobilee=="false") {
//       showAlert("Please Allow Mobile .");
//       return;
//     }
//     if (EmpAttendPara_AttendJurnanyAlloww=="false") {
//       showAlert("Please Allow Jouereny.");
//       return;

//     }else if (EmpAttendPara_AttendJurnanyAlloww=="true"){
//       showAlerttttttttt("Start Your Jouerny Now.");

// InButton=false;
// INButton=false;
// outbutttonnnn=false;
// StartButton=true;
// OFFButton=true;

// inMohn= false;
// outmohn=false;

//     }

//     });
//     }catch(e){};
//   }

  // Helper function to show alert dialog
  void showAlert(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Alert"),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Dashboard()));
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  // Helper function to show alert dialog
  void showAlerttttttttt(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Alert"),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                //  Navigator.push(context, MaterialPageRoute(builder: (context)=>  Dashboard()));
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  Future<void> OnGetparameter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    ServerDetails serverDetails = ServerDetails();

    final String restUrl =
        '${AppCongifP.apiurllink}/${AppCongifP.applicationName}/servicedata.aspx?calltype=_MstAttendRemark';
    try {
      final response = await http.get(Uri.parse(restUrl));
      if (response.statusCode == 200) {
        List<ParameterAttendencelist> parameterattendlist =
            (json.decode(response.body) as List)
                .map((data) => ParameterAttendencelist.fromJson(data))
                .toList();

        setState(() {
          trends1 = parameterattendlist;
          if (trends1.isNotEmpty) {
            selectedType1 = '${trends1[0].kid}-${trends1[0].text}';
          }
        });
      } else {
        throw Exception('Failed to load attendance data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> attend() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    ServerDetails serverDetails = ServerDetails();

    String kid = prefs.getString('EmpKid')!;

    final String restUrl =
        '${AppCongifP.apiurllink}/${AppCongifP.applicationName}/servicedata.aspx?callFor=AttendanceTopRecords&EmpKid=$kid';

    try {
      final response = await http.get(Uri.parse(restUrl));
      if (response.statusCode == 200) {
        List<Attenddata> attenddataList = (json.decode(response.body) as List)
            .map((data) => Attenddata.fromJson(data))
            .toList();

        setState(() {
          trends = attenddataList;
        });

        // Assuming you have fetched attendss data from somewhere, e.g., local storage or another API
        // attendss = // Fetch attendss data

        // for (var attend in attendss) {
        //   double totalTime = double.parse(attend.totalTime.replaceAll(':', '.'));
        //   if (totalTime >= 8) {
        //     attend.status = "Present";
        //   }
        // }

        // setState(() {
        //   // Update the UI with the modified attendss list
        // });
      } else {
        throw Exception('Failed to load attendance data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> OnGetAttendence() async {
    await EasyLoading.show(status: 'Marking Attendance');

    SharedPreferences prefs = await SharedPreferences.getInstance();

    ServerDetails serverDetails = ServerDetails();

    String kid = prefs.getString('EmpKid')!;
    String attendenceP = selectedType1.toString().split('-')[0];

    if (status == "O") {
      if (format == "am") {
        TimeOfDay _selectedOUTTime = TimeOfDay.now();
        String formattedTime = MaterialLocalizations.of(context)
            .formatTimeOfDay(_selectedOUTTime, alwaysUse24HourFormat: true);
        OutTimee = formattedTime.toString();
//   OutTimee = _selectedOUTTime.toString().substring(10, 15);
//  int index = OutTimee.lastIndexOf(":");
//  OutTimee = OutTimee.substring(0, index);
        if (OutTimee == "00:00:00") {
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

        if (outt >= inData) {
          String value =
              'MobAttendanceMobile|$kid||$InTime|$OutTime|$attendenceP|$_latitude|$_longitude|$imgStr|$status';

          final String restUrl =
              '${AppCongifP.apiurllink}/${AppCongifP.applicationName}/ServiceData.aspx';

          var response = await http.post(
            Uri.parse(restUrl),
            body: {
              'values': value,
            },
          );

          try {
            if (response.statusCode == HttpStatus.ok) {
              String content = response.body;
              await EasyLoading.dismiss();

              print('Authenticate Response: $content');

              if (content != "Saved Succesfully") {
                if (content.isEmpty) {
                  await _showAlert("Alert", "Something went wrong!!!!", "OK");
                } else {
                  await _showAlert("Alert", content, "OK");

                  insertinn = inTime;
                  InButton = true;
                  INButton = false;

                  // final service = FlutterBackgroundService();
                  //           bool isRunning = await service.isRunning();

                  //              FlutterBackgroundService().invoke('setAsForeground');
                }
              } else {
                Flag = 2;
                OnGetResponce();

                await _showAlert("Alert", content, "OK");
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Dashboard()),
                );
              }
            }
          } catch (e) {
            print('ERROR: $e');
            await _showAlert("Alert", "Unable to connect to the server", "OK");
          }
        }
      } else {
        TimeOfDay _selectedOUTTime = TimeOfDay.now();
        String formattedTime = MaterialLocalizations.of(context)
            .formatTimeOfDay(_selectedOUTTime, alwaysUse24HourFormat: true);
        OutTimee = formattedTime.toString();
        // OutTimee = _selectedOUTTime.toString();
// int index = OutTimee.lastIndexOf(":");
        //OutTimee = OutTimee.substring(0, index);
        if (OutTimee == "00:00:00") {
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

        if (outt >= inData) {
          String value =
              'MobAttendanceMobile|$kid||$InTime|$OutTime|$attendenceP|$_latitude|$_longitude|$imgStr|$status';

          final String restUrl =
              '${AppCongifP.apiurllink}/${AppCongifP.applicationName}/ServiceData.aspx';

          var response = await http.post(
            Uri.parse(restUrl),
            body: {
              'values': value,
            },
          );

          try {
            if (response.statusCode == HttpStatus.ok) {
              String content = response.body;
              await EasyLoading.dismiss();

              print('Authenticate Response: $content');

              if (content != "Saved Succesfully") {
                if (content.isEmpty) {
                  await _showAlert("Alert", "Something went wrong!!!!", "OK");
                } else {
                  await _showAlert("Alert", content, "OK");
                  insertinn = inTime;
                  InButton = true;
                  INButton = false;
                }
              } else {
                Flag = 2;
                OnGetResponce();

                await _showAlert("Alert", content, "OK");
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Dashboard()));
                //  final service = FlutterBackgroundService();
                //             bool isRunning = await service.isRunning();

                //                FlutterBackgroundService().invoke('setAsForeground');
              }
            }
          } catch (e) {
            print('ERROR: $e');
            await _showAlert("Alert", "Unable to connect to the server", "OK");
          }
        }
      }
    } else {
      String value =
          'MobAttendanceMobile|$kid||$InTime|$OutTime|$attendenceP|$_latitude|$_longitude|$imgStr|$status';

      final String restUrl =
          '${AppCongifP.apiurllink}/${AppCongifP.applicationName}/ServiceData.aspx';

      var response = await http.post(
        Uri.parse(restUrl),
        body: {
          'values': value,
        },
      );

      try {
        if (response.statusCode == HttpStatus.ok) {
          String content = response.body;
          await EasyLoading.dismiss();

          print('Authenticate Response: $content');

          if (content != "Saved Succesfully") {
            if (content.isEmpty) {
              await _showAlert("Alert", "You Already Mark IN ", "OK");
            } else {
              await _showAlert("Alert", content, "OK");

              insertinn = inTime;
              InButton = true;
              INButton = false;

              //  final service = FlutterBackgroundService();
              //             bool isRunning = await service.isRunning();

              //        if(isRunning == false){

              //         initializeService();

              //       FlutterBackgroundService().invoke('setAsForeground');

              //       service.startService();

              //        }
            }
          } else {
            Flag = 1;

            OnGetResponce();

            await _showAlert("Alert", content, "OK");

            isSwitched = true;
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Dashboard()),
            );

            // final service = FlutterBackgroundService();
            //           bool isRunning = await service.isRunning();

            //      if(isRunning == false){

            //       initializeService();

            //     FlutterBackgroundService().invoke('setAsForeground');

            //     service.startService();

            //      }
          }
        }
      } catch (e) {
        print('ERROR: $e');
        await _showAlert("Alert", "Unable to connect to the server", "OK");
      }
    }
    await EasyLoading.dismiss();
  }

  Future<void> OnGetResponce() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    ServerDetails serverDetails = ServerDetails();

    String userId = prefs.getString("userID") ?? '';
    final String restUrl =
        '${AppCongifP.apiurllink}/${AppCongifP.applicationName}/ServiceData.aspx?callFor=CheckAttendance&empcode=$userId';

    var response = await http.get(Uri.parse(restUrl));

    if (response.statusCode == 200) {
      String content = response.body;

      if (content == "[]") {
        if (Flag == 1) {
          _isINButtonEnabled = false;
          _isOUTButtonEnabled = true;
          _isStartButtonEnabled = false;
          _isEndButtonEnabled = true;

          Flag = 0;
        } else if (Flag == 2) {
          _isINButtonEnabled = true;
          _isOUTButtonEnabled = false;
          _isStartButtonEnabled = true;
          _isEndButtonEnabled = false;
          Flag = 0;
        } else {
          _isINButtonEnabled = true;
          _isOUTButtonEnabled = false;
          _isStartButtonEnabled = true;
          _isEndButtonEnabled = false;
          Flag = 0;
        }
        // dataFound();
      }

      if (content != "[]") {
        List<dynamic> file = jsonDecode(content);
        for (var item in file) {
          inFlag = item["AttendIn"];
          inTime = item["AttendInTime"];
          outTime = item["AttendExitTime"];
          inTime = inTime.replaceAll(":", ".");
          inData = double.parse(inTime);
          if (inData >= 12) {
            format = "pm";
          } else if (inData == 0) {
            format = "pm";
          } else {
            format = "am";
          }
          if (inFlag == " ") {
            setState(() {
              _isINButtonEnabled = false;
              _isOUTButtonEnabled = true;
              _isStartButtonEnabled = false;
              _isEndButtonEnabled = true;
            });
          } else {
            if (inFlag == "I") {
              setState(() {
                INButton = false;
                _isINButtonEnabled = false;
                _isStartButtonEnabled = false;
                _isOUTButtonEnabled = true;
                _isEndButtonEnabled = true;
                isSwitched = true;
                InButton = true;
                insertinn = inTime.replaceAll(".", ":");
              });
            }
            // else if(inFlag=="O"){
            //   setState(() {
            //     INButton = false;
            //      _isINButtonEnabled = false;
            //   _isOUTButtonEnabled = false;
            //     InButton = false;

            //   });
            // }

            else {
              setState(() {
                //inButtonEnabled = true;
                INButton = true;

                _isINButtonEnabled = false;

                _isOUTButtonEnabled = true;

                _isStartButtonEnabled = true;
                _isEndButtonEnabled = false;

                insertinn = inTime.replaceAll(".", ":");
                InButton = false;
                isSwitched = false;
              });
            }
          }
          //dataFound();
        }
      }
    } else {
      // Handle the error
      print('Failed to load data');
    }
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    await EasyLoading.show(status: 'Fetching Location...');

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    EasyLoading.dismiss();
    setState(() {
      _currentPosition = position;
      _latitude = position.latitude.toString();
      _longitude = position.longitude.toString();
    });
  }

  Future<void> _selectInTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedINTime,
    );
    if (picked != null && picked != _selectedINTime) {
      setState(() {
        _selectedINTime = picked;
      });
    }
  }

  Future<void> _selectOutTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedOUTTime,
    );
    if (picked != null && picked != _selectedOUTTime) {
      setState(() {
        _selectedOUTTime = picked;
        String _formattedTime = _selectedOUTTime.format(context);
      });
    }
  }

// Future<void> _onINPress() async {
//   try {
//     bool canCheckBiometrics = await auth.canCheckBiometrics;
//     if (canCheckBiometrics) {
//       // Authenticate using fingerprint
//       bool authenticated = await auth.authenticate(
//         localizedReason: 'Mark your Attendance',
//         options: const AuthenticationOptions(
//           useErrorDialogs: true,
//           stickyAuth: true,
//         ),
//       );

//       // Check the authentication result
//       await showDialog(
//         context: context,
//         builder: (BuildContext context) => AlertDialog(
//           title: Text(authenticated ? 'Success' : 'Failure'),
//           content: Text(authenticated ? 'Authenticated' : 'Not Authenticated'),
//           actions: [
//             TextButton(
//               child: Text('OK'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 if (authenticated) {
//                   // Call a function on successful authentication
//                   _onINPresss();
//                 }
//               },
//             ),
//           ],
//         ),
//       );
//     } else {
//       bool isDeviceSupported = await auth.isDeviceSupported();
//       if (!isDeviceSupported) {
//         // Call a function if the device does not support biometrics
//         _onINPresss();
//       } else {
//         await showDialog(
//           context: context,
//           builder: (BuildContext context) => AlertDialog(
//             title: Text('Alert'),
//             content: Text('Biometrics authentication is not available, Add your Biometrics First'),
//             actions: [
//               TextButton(
//                 child: Text('OK'),
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//               ),
//             ],
//           ),
//         );
//       }
//     }
//   } catch (e) {
//     print('Error in checkBiometrics: $e');
//     // Handle error gracefully
//   }
// }

  Future<void> _onINPress() async {
    try {
      var position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
      );

      setState(() {
        _latitude = position.latitude.toString();
        _longitude = position.longitude.toString();
      });

      currentTime = double.parse(
          DateTime.now().toString().substring(11, 16).replaceAll(":", "."));
      // intym = double.parse(_selectedINTime.toString().substring(10, 15).replaceAll(":", ".").substring(0, 5));
      intym = currentTime.toDouble();

      //intym = double.parse( _selectedINTime.toString().substring(10, 15).replaceAll(":", "."));

      // double outtym = intym - 0.05;

      // intym = intym.abs();

      if (intym > currentTime) {
        await _showDialog(
            context, "Alert", "In time is greater than current time..!");
        return;
      }

      // InTime = _selectedINTime.toString().substring(10, 15);

      double INTIMEE = double.parse(
          DateTime.now().toString().substring(11, 16).replaceAll(":", "."));
      InTime = INTIMEE.toString().replaceAll(".", ":");

      if (InTime == "00:00") {
        InTime = DateTime.now().toString().substring(11, 16);
      }

      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        setState(() {
          _inImage = File(pickedFile.path);
          imgStr = base64Encode(_inImage!.readAsBytesSync());
        });
      } else {
        // Handle no image captured case
        await _showDialog(context, "Alert", "No image captured..!");
        return;
      }

      status = "I";
      print('Error: +$_latitude+$_longitude+$currentTime+$intym+$InTime ');

      await OnGetAttendence();
    } catch (e) {
      print(
          'Error in checkBiometrics: $e+$_latitude+$_longitude+$currentTime+$intym+$InTime');
      await _showDialog(
          context, 'Error', 'An error occurred. Please try again.');
    }
  }

  Future<void> _showDialog(
      BuildContext context, String title, String message) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) => Builder(builder: (context) {
        return MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: const TextScaler.linear(1.1)),
          child: AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      }),
    );
  }

  Future<void> _onOUTPress() async {
    try {
      await EasyLoading.show(status: 'Fetching Location...');
      var position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.medium);
      await EasyLoading.dismiss();
      if (position == null) {
        await _showAlert(
            "Alert",
            "You need to activate location service on your device. Please turn on GPS mode in location settings..!",
            "ok");
        return;
      }

      setState(() {
        _latitude = position.latitude.toString();
        _longitude = position.longitude.toString();
      });

      currentTime = double.parse(
          DateTime.now().toString().substring(11, 16).replaceAll(":", "."));
      outtym = currentTime.toDouble();

      //outtym = double.parse(_selectedOUTTime.format(context).replaceAll(":", "."));

      // outtym= double.parse(_selectedOUTTime.toString().substring(10, 15).replaceAll(":", "."));

      setState(() {});
      //  intym = double.parse(insertinn.replaceAll(":", "."));

      print('Error: +$_latitude+$_longitude+$currentTime+$outtym ');

      if (outtym > currentTime) {
        await _showAlert(
            "Alert", "Out time is greater than current time..!", "ok");
        return;
      }

      // OutTime = _selectedOUTTime.toString().substring(10, 15);

      double OUTIMEEE = double.parse(
          DateTime.now().toString().substring(11, 16).replaceAll(":", "."));
      OutTime = OUTIMEEE.toString().replaceAll(".", ":");

      if (OutTime == "00:00") {
        OutTime = DateFormat('HH:mm')
            .format(DateTime.now())
            .toString()
            .substring(11, 16);
      }

      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        setState(() {
          _inImage = File(pickedFile.path);

          imgStr = base64Encode(_inImage!.readAsBytesSync());
        });
      } else {
        // Handle no image captured case
        await _showDialog(context, "Alert", "No image captured..!");
        return;
      }
      status = "O";

      print('Error: +$_latitude+$_longitude+$currentTime+$outtym+$OutTime ');

      OnGetAttendence();
    } catch (e) {
      print('Error: $e +$_latitude+$_longitude+$currentTime+$outtym+$OutTime ');
    }
  }

  Future<void> _captureImage(bool isIn) async {
    await _getCurrentLocation();
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      setState(() {
        if (isIn) {
          _inImage = File(photo.path);
        } else {
          _outImage = File(photo.path);
        }
      });
    }
  }

  Future<void> _showAlert(String title, String content, String buttonText) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Builder(builder: (context) {
          return MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: const TextScaler.linear(1.1)),
            child: AlertDialog(
              title: Text(title),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text(content),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text(buttonText),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: const TextScaler.linear(1.1)),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(25),
                      bottomRight: Radius.circular(25),
                    ),
                    color: Colors.blue,
                  ),
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      buildProfileView(pre, () {}),
                      const SizedBox(height: 10),
                      Text(
                        empName ?? '',
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        empDesignation ?? '',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (_currentPosition != null) ...[
                            Text(
                              "Lat = ${_latitude ?? 'N/A'} | Long = ${_longitude ?? 'N/A'}",
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ] else ...[
                            const Text(
                              'Getting location...',
                              style: TextStyle(
                                color: Colors.red,
                                fontFamily: 'TimesNewRoman',
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'CheckIn Time= 10:00 AM - 10:15 AM',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                      const Text(
                        'CheckOut Time= 7:00 PM - 8:00 PM',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          color: Colors.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            DateFormat('dd-MM-yyyy').format(_currentDate),
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          const Text(
                            'In Time',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            inTime == '' ? 'NA' : inTime,
                            style: const TextStyle(
                                fontSize: 16, color: Colors.black),
                          ),
                        ],
                      ),
                      Container(
                        height: 60,
                        width: 1,
                        color: Colors.grey,
                      ),
                      Column(
                        children: [
                          const Text(
                            'Out Time',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            outTime == '' ? 'NA' : outTime,
                            style: const TextStyle(
                                fontSize: 16, color: Colors.black),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: inMohn,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 20),
                    child: Container(
                      width: double.infinity,
                      height: 55,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextButton(
                        onPressed: () =>
                            _isINButtonEnabled ? _onINPress() : null,
                        child: const Text(
                          "Check-In",
                          style: TextStyle(
                            fontFamily: "TimesNewRoman",
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 20),
                  child: Container(
                    width: double.infinity,
                    height: 55,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextButton(
                      onPressed: () =>
                          _isOUTButtonEnabled ? _onOUTPress() : null,
                      child: const Text(
                        "Check-Out",
                        style: TextStyle(
                          fontFamily: "TimesNewRoman",
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(5),
                  color: Colors.white70,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Row(
                      //   children: [
                      //     const Text(
                      //       'Current Date:',
                      //       style: TextStyle(
                      //         color: Colors.blue,
                      //         fontFamily: 'TimesNewRoman',
                      //         fontSize: 12,
                      //         fontWeight: FontWeight.bold,
                      //       ),
                      //     ),

                      // Padding(
                      //   padding: const EdgeInsets.only(left: 8.0),
                      //   child: Text(
                      //     DateFormat('dd-MM-yyyy').format(_currentDate),
                      //     style: const TextStyle(
                      //       color: Colors.black,
                      //       fontFamily: 'TimesNewRoman',
                      //       fontSize: 12,
                      //     ),
                      //   ),
                      // ),
                      // ],
                      // ),
                      const SizedBox(height: 10),
                      const Row(
                        children: [
//           Visibility(
//             visible: inMohn,
//             child: ElevatedButton(

//             // onPressed: () => _onINPress(),
//              onPressed: () => _isINButtonEnabled ? _onINPress() : null,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.blue,
//                 shape: const CircleBorder(), // Circular shape
//                 padding: const EdgeInsets.all(30), // Adjust the size
//               ),
//               child: const Text(
//                 'IN',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontFamily: 'TimesNewRoman',
//                   fontSize: 12,
//                 ),
//               ),
//             ),
//           ),

//           const SizedBox(width: 50),
//           Visibility(  visible: INButton,
//             child: GestureDetector(
//               onTap: () =>_isInclock? _selectInTime(context):null,
//               child: Container(
//                 width: 70, // Adjust the size
//                 height: 70, // Adjust the size
//                 decoration: const BoxDecoration(
//                   color: Color.fromARGB(255, 243, 128, 33),
//                   shape: BoxShape.circle, // Circular shape
//                 ),

//                 child: Center(
//                   child: Text(
//                     _selectedINTime.format(context),
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontFamily: 'TimesNewRoman',
//                       fontSize: 12,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           Visibility( visible: InButton
//           ,  child: Text("${insertinn}" ,style: const TextStyle(color:Colors.black,fontFamily: "TimesNewRoman",fontWeight: FontWeight.bold),)),

//           //-------------------------------------------//

//  Visibility(  visible: StartButton,
//             child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               isSwitched ? 'ON' : 'OFF',
//               style: const TextStyle(fontSize: 30),
//             ),
//              const SizedBox(width: 20),
//             Transform.scale(
//               scale: 1.2, // Adjust this value to increase width and size
//               child: Switch(
//                 value: isSwitched,
//                 onChanged: (value) {
//                   setState(() {
//                     isSwitched = value;
//                     if (isSwitched) {
//                       _onINPress();
//                     } else {
//                       _onOUTPress();
//                     }
//                   });
//                 },
//               ),
//             ),
//           ],
//         ),
//           ),
//           //  Visibility( visible: InButton
//           // ,  child: Text("Start" ,style: const TextStyle(color:Colors.black,fontFamily: "TimesNewRoman",fontWeight: FontWeight.bold),)),

//             ],
//           ),

//            const SizedBox(height: 10),
//                        Row(
//             children: [
//           Visibility( visible: outmohn,
//             child: ElevatedButton(

//                // onPressed: () => _onOUTPress(),
//              onPressed: () => _isOUTButtonEnabled ? _onOUTPress() : null,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.blue,
//                 shape: const CircleBorder(), // Circular shape
//                 padding: const EdgeInsets.all(30), // Adjust the size
//               ),
//               child: const Text(
//                 'OUT',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontFamily: 'TimesNewRoman',
//                   fontSize: 12,
//                 ),
//               ),
//             ),
//           ),
//               const SizedBox(width: 40),

//           Visibility(visible: outbutttonnnn,
//             child: GestureDetector(
//               onTap: () => _isOutclock? _selectOutTime(context) :null,
//               child: Container(
//                 width: 70, // Adjust the size
//                 height: 70, // Adjust the size
//                 decoration: const BoxDecoration(
//                   color: Color.fromARGB(255, 243, 128, 33),
//                   shape: BoxShape.circle, // Circular shape
//                 ),
//                 child: Center(
//                   child: Text(
//                     _selectedOUTTime.format(context),
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontFamily: 'TimesNewRoman',
//                       fontSize: 12,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),

                          //---------------------------------------------//

//  Visibility(   visible: OFFButton,
//             child: GestureDetector(
//               onTap: () =>  _isOUTButtonEnabled ? _onOUTPress() : null,
//               child: Container(
//                 width: 70, // Adjust the size
//                 height: 70, // Adjust the size
//                 decoration: const BoxDecoration(
//                   color: Color.fromARGB(255, 243, 128, 33),
//                   shape: BoxShape.circle, // Circular shape
//                 ),

//                 child: const Center(
//                   child: Text(
//                     'End',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontFamily: 'TimesNewRoman',
//                       fontSize: 15,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
                        ],
                      ),

                      // Row(
                      //   crossAxisAlignment: CrossAxisAlignment.start,
                      //   children: [

                      // if (_currentPosition != null) ...[

                      //   Row(
                      //     children: [
                      //       const Text(
                      //         'Latitude: ',
                      //         style: TextStyle(
                      //           color: Color(0xFF547EC8),
                      //           fontFamily: 'TimesNewRoman',
                      //           fontSize: 12,
                      //           fontWeight: FontWeight.bold,
                      //         ),
                      //       ),
                      //       Text(
                      //         _latitude ?? 'N/A',
                      //         style: const TextStyle(
                      //           color: Colors.black,
                      //           fontFamily: 'TimesNewRoman',
                      //           fontSize: 12,
                      //           fontWeight: FontWeight.bold,
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      //   Padding(
                      //     padding: const EdgeInsets.only(left: 10),
                      //     child: Row(
                      //       children: [
                      //         const Text(
                      //           'Longitude: ',
                      //           style: TextStyle(
                      //             color: Color(0xFF547EC8),
                      //             fontFamily: 'TimesNewRoman',
                      //             fontSize: 12,
                      //             fontWeight: FontWeight.bold,
                      //           ),
                      //         ),
                      //         Text(
                      //           _longitude ?? 'N/A',
                      //           style: const TextStyle(
                      //             color: Colors.black,
                      //             fontFamily: 'TimesNewRoman',
                      //             fontSize: 12,
                      //             fontWeight: FontWeight.bold,
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ] else ...[
                      //   const Text(
                      //     'Getting location...',
                      //     style: TextStyle(
                      //       color: Colors.red,
                      //       fontFamily: 'TimesNewRoman',
                      //       fontSize: 12,
                      //     ),
                      //   ),
                      // ],
                      //   ],
                      // ),

                      const Text(
                        'Attendance Type',
                        style: TextStyle(
                          color: Color(0xFF547EC8),
                          fontFamily: 'TimesNewRoman',
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      DropdownButton<String>(
                        items: trends1.map((ParameterAttendencelist item) {
                          return DropdownMenuItem<String>(
                            value: '${item.kid}-${item.text}',
                            child: Builder(builder: (context) {
                              return MediaQuery(
                                  data: MediaQuery.of(context).copyWith(
                                      textScaler: const TextScaler.linear(1.1)),
                                  child: Text('${item.kid}-${item.text}'));
                            }),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedType1 = newValue;
                          });
                        },
                        hint: const Text(
                          'Select Type',
                          style: TextStyle(
                            fontFamily: 'TimesNewRoman',
                            fontSize: 12,
                          ),
                        ),
                        value: selectedType1,
                      ),
                      _inImage != null
                          ? Image.file(
                              _inImage!,
                              width: 70,
                              height: 70,
                              fit: BoxFit.cover,
                            )
                          : Container(
                              width: 10,
                              height: 10,
                              color: Colors.grey,
                              child: const Center(
                                child: Text(
                                  'Photo',
                                  style: TextStyle(
                                    fontFamily: 'TimesNewRoman',
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                      const SizedBox(height: 10),
                      Container(
                        height: 300,
                        child: Column(
                          children: [
                            // Header Row
                            Container(
                              padding: const EdgeInsets.all(5),
                              color: Colors.blue[300],
                              child: const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    flex: 20,
                                    child: Text(
                                      'Date',
                                      style: TextStyle(
                                        fontFamily: 'TimesNewRoman',
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 20,
                                    child: Text(
                                      'InTime',
                                      style: TextStyle(
                                        fontFamily: 'TimesNewRoman',
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 20,
                                    child: Text(
                                      'OutTime',
                                      style: TextStyle(
                                        fontFamily: 'TimesNewRoman',
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 20,
                                    child: Text(
                                      'TotalTime',
                                      style: TextStyle(
                                        fontFamily: 'TimesNewRoman',
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // List of Attendance Entries
                            Expanded(
                              child: ListView.builder(
                                itemCount: trends.length,
                                itemBuilder: (context, index) {
                                  final attend = trends[index];
                                  return Container(
                                    padding: const EdgeInsets.all(5),
                                    color: Colors.grey[200],
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          flex: 23,
                                          child: Text(
                                            attend.date,
                                            style: const TextStyle(
                                              fontFamily: 'TimesNewRoman',
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 20,
                                          child: Text(
                                            attend.inTime,
                                            style: const TextStyle(
                                              fontFamily: 'TimesNewRoman',
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 20,
                                          child: Text(
                                            attend.outTime,
                                            style: const TextStyle(
                                              fontFamily: 'TimesNewRoman',
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 20,
                                          child: Text(
                                            attend.totalTime,
                                            style: const TextStyle(
                                              fontFamily: 'TimesNewRoman',
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  void Dialgbox(String MESSAGE) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Builder(builder: (context) {
          return MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: const TextScaler.linear(1.1)),
            child: AlertDialog(
              title: const Text(
                'Alert',
                style: TextStyle(fontSize: 16),
              ),
              content: Text(
                MESSAGE,
                style: const TextStyle(fontSize: 16),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'OK',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          );
        });
      },
    );
  }
}
