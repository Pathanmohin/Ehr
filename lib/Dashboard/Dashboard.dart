// ignore_for_file: non_constant_identifier_names, constant_identifier_names, unnecessary_import, file_names, library_private_types_in_public_api, use_key_in_widget_constructors, deprecated_member_use, unused_element, sized_box_for_whitespace, use_build_context_synchronously, unrelated_type_equality_checks, duplicate_ignore, avoid_print, sort_child_properties_last, avoid_unnecessary_containers, override_on_non_overriding_member

import 'dart:convert';
import 'dart:typed_data';

import 'package:badges/badges.dart' as badges;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:ehr/Dashboard/Attendance.dart';
import 'package:ehr/Dashboard/AttendanceCalendar.dart';
import 'package:ehr/Dashboard/BREClaim.dart';
import 'package:ehr/Dashboard/Claim/ClaimDashboard.dart';
import 'package:ehr/Dashboard/Extracomponent/componentui.dart';
import 'package:ehr/Dashboard/LeaveDashboard.dart';
import 'package:ehr/Dashboard/LogoutPage.dart';
import 'package:ehr/Dashboard/MoreCompoent/compoentui.dart';
import 'package:ehr/Dashboard/Notification.dart';
import 'package:ehr/Dashboard/ProfileComponent/componentui.dart';
import 'package:ehr/Dashboard/SalarySlip.dart';
import 'package:ehr/Dashboard/TodayAttendance.dart';
import 'package:ehr/Dashboard/Travel%20Request/Traveldashboard.dart';
import 'package:ehr/Dashboard/TravelClaim/comman.dart/Alert_Box.dart';
import 'package:ehr/Dashboard/viewmore/Loan/applyforloan.dart';
import 'package:ehr/Dashboard/viewmore/Loan/loan.dart';
import 'package:ehr/Dashboard/viewmore/model/menumodel.dart';
import 'package:ehr/Dashboard/viewmore/model/viewdatavalid.dart';
import 'package:ehr/Dashboard/viewmore/viewmore.dart';
import 'package:ehr/Loginpage.dart';
import 'package:ehr/Model/PendingMessage.dart';
import 'package:ehr/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class MyAttendanceDetail {
  final int present;
  final int absent;
  final int Leave;

  MyAttendanceDetail(
      {required this.present, required this.absent, required this.Leave});

  factory MyAttendanceDetail.fromJson(Map<String, dynamic> json) {
    return MyAttendanceDetail(
      present: json['present'],
      absent: json['absent'],
      Leave: json['Leave'],
    );
  }
}

class MyAttendanceDetaill {
  String totalTime;
  String flag;
  String status;
  String Name;
  String InTime;
  String OutTime;
  String DateCol;

  MyAttendanceDetaill({
    required this.totalTime,
    required this.flag,
    required this.status,
    required this.InTime,
    required this.OutTime,
    required this.DateCol,
    required this.Name,
  });

  factory MyAttendanceDetaill.fromJson(Map<String, dynamic> json) {
    return MyAttendanceDetaill(
      totalTime: json['TotalTime'],
      flag: json['Flag'],
      status: "",
      DateCol: json['DateCol'],
      OutTime: json['OutTime'],
      InTime: json['InTime'],
      Name: json['Name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'TotalTime': totalTime,
      'Flag': flag,
      '': status,
      'DateCol': DateCol,
      'InTime': InTime,
      'OutTime': OutTime,
      'Name': Name,
    };
  }
}

class WeeklyData {
  final String WeekNo;
  final String WeekTotAttend;

  WeeklyData({required this.WeekNo, required this.WeekTotAttend});

  factory WeeklyData.fromJson(Map<String, dynamic> json) {
    return WeeklyData(
      WeekNo: json['WeekNo'].toString(),
      // WeekTotAttend: json['WeekTotAttend'] is int
      //     ? json['WeekTotAttend']
      //     : int.parse(json['WeekTotAttend'].toString()),
      WeekTotAttend: json['WeekTotAttend'],
    );
  }
}

class PendingMessagee {
  int attendBack;
  int leave;
  int notification;
  int attendcancel;
  int attendback;

  PendingMessagee(
      {required this.attendBack,
      required this.leave,
      required this.notification,
      required this.attendcancel,
      required this.attendback});

  factory PendingMessagee.fromJson(Map<String, dynamic> json) {
    return PendingMessagee(
        attendBack: json['AttendBack'],
        leave: json['Leave'],
        notification: json['Notification'],
        attendcancel: json['AttendCancel'],
        attendback: json['AttendBack']);
  }
}

class _DashboardState extends State<Dashboard> {
  @override
  void initState() {
    super.initState();

    if (ViewData.modules.isEmpty) {
      ModuleParameter();
    }
// if (ViewData.claimfinallist.isEmpty){
//   claimmmm=false;
// }
    if (AppCongifP.applicationName == "HRMS") {
      dateee = true;
      tabbar = false;
      viewmoree = false;
    }
    Testingpage();
    checkConnectivity();
    GetMyAttendance();
    // getWeeklyData();
    getCountingMessage();
    getSubordinateDetail();
    AttendanceParaMAPData();
  }

  String? empimage;
  String presence = "";
  String absents = "";
  String leaves = "";
  bool isLoading = true;
  String W1 = "";
  String W2 = "";
  String W3 = "";
  String W4 = "";
  String W5 = "";
  String badgeText = "";
  String leaveText = "";
  String notificationCount = "";
  String Pp = "";
  String Aa = "";
  String Ll = "";
  String Tt = "";
  List<Map<String, String>> Attendlist = [];
  List<Map<String, dynamic>> attendfinallist = [];
  List<Map<String, String>> claimlist = [];
  List<Map<String, dynamic>> claimfinallist = [];
  bool viewmoree = true;
  bool dateee = false;
  bool tabbar = true;
  bool claimmmm = true;

  static const marking = IconData(0xe043, fontFamily: "MaterialIcons");
  static const Personal = IconData(0xe3c6, fontFamily: "MaterialIcons");
  static const extra = IconData(0xe50d, fontFamily: "MaterialIcons");
  static const claim = IconData(0xf101, fontFamily: "MaterialIcons");

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onWillPop(context),
      child: Builder(builder: (context) {
        return MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: const TextScaler.linear(1.0)),
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.blue,
              automaticallyImplyLeading: false,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Left side content
                  const Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "eHR",
                        style: TextStyle(
                          fontFamily: 'TimesNewRoman',
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  // Right side icons
                  Row(
                    children: [
                      _buildIconButton('Refresh.png', () {
                        EasyLoading.show(status: 'Refresh...');

                        ViewData.modules.clear();
                        ViewData.Attendlist.clear();
                        ViewData.attendfinallist.clear();
                        ViewData.claimlist.clear();
                        ViewData.claimfinallist.clear();

                        ModuleParameter();
                        EasyLoading.dismiss();
                      }),
                      const SizedBox(width: 10),
                      _buildIconButton(
                        'bellicon.PNG',
                        () {
                          onNotiClicked(context);
                        },
                        badgeContent: notificationCount,
                      ),
                      const SizedBox(width: 10),
                      _buildProfileImage(empimage.toString(), context),

                      // _buildIconButton('profileuser.png', () {
                      //   Navigator.push(
                      //     context,
                      //     MaterialPageRoute(builder: (context) => LogoutPage()),
                      //   );
                      // }),
                    ],
                  ),
                ],
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      // Using Column to display both widgets
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTabView(), // First widget
                        _date(), // Second widget
                      ],
                    ),
                  ),
                  // const ComponentHome(
                  //   iconCode:marking ,
                  //   title: "Marking",
                  // subTitle: "Mark Attendance,Leave Request,Leave Balance",
                  // img1:"attend.PNG",

                  // titel1: "Attendance",

                  // img2: "nwleave.PNG",

                  // titel2: "Leave",
                  // img : "salary.PNG",
                  // titel3: "SalarySlip",

                  // ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 10.0, left: 10.0, right: 10.0),
                    child: Container(
                      height: 140,
                      width: 450,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 3,
                            blurRadius: 7,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              CircleAvatar(
                                child: Icon(
                                  Icons.mark_as_unread,
                                  size: 32,
                                  color: Colors.blue,
                                ),
                                backgroundColor: Colors.white,
                              ),
                              SizedBox(width: 10),
                              Text(
                                "Marking",
                                style: TextStyle(
                                    fontFamily: "TimesNewRoman",
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          GestureDetector(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: ViewData.attendfinallist.map((title) {
                                return Column(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        if (title['title'] == "Attendance") {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const AttendancePage()));
                                        } else if (title['title'] == "Leave") {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const Leavedashboard()));
                                        } else if (title['title'] ==
                                            "SalarySlip") {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Salaryslip()));
                                        }
                                      },
                                      child: Image.asset(
                                        'assets/images/${title['icon']}', // Update path as per your directory
                                        width: 40,
                                        height: 40,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return const Icon(Icons
                                              .error); // Show error icon if image not found
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    InkWell(
                                        onTap: () {
                                          if (title['title'] == "Attendance") {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const AttendancePage()));
                                          } else if (title['title'] ==
                                              "Leave") {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const Leavedashboard()));
                                          } else if (title['title'] ==
                                              "SalarySlip") {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        Salaryslip()));
                                          }
                                        },
                                        child: Text(
                                          title['title'] ?? '',
                                          style: const TextStyle(
                                              fontFamily: "TimesNewRoman",
                                              fontSize: 15),
                                        )),
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Center(
                        child: SizedBox(
                      width: 350,
                      height: 2,
                      child: Center(
                          child: Container(
                        color: Colors.black26,
                      )),
                    )),
                  ),

                  const ComponentHome1(
                    iconCode: Personal,
                    title: "Personal",
                    subTitle: "Profile, Change Password, Directory",
                    img1: "Profile.png",
                    titel1: "Profile",
                    img2: "change_password.png",
                    titel2: "Change Password",
                    img: "direct.PNG",
                    titel3: "Directory",
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Center(
                        child: SizedBox(
                      width: 350,
                      height: 2,
                      child: Center(
                          child: Container(
                        color: Colors.black26,
                      )),
                    )),
                  ),

                  const ComponentHome2(
                    iconCode: extra,
                    title: "Extra",
                    subTitle: "Holiday & Shift Calendar, C&G",
                    img1: "holiday.png",
                    titel1: "Holiday",
                    img2: "Circular.PNG",
                    titel2: "C&G",
                    img: "Claim.PNG",
                    titel3: "Claims",
                    // img: "Pulls.PNG",
                    // titel3: "Polls & Survey",
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Center(
                        child: SizedBox(
                      width: 350,
                      height: 2,
                      child: Center(
                          child: Container(
                        color: Colors.black26,
                      )),
                    )),
                  ),

                  const ComponentHomeMore(
                    iconCode: extra,
                    title: "More",
                    subTitle: "Ehr-Map, BBPS, Claims",
                    img1: "googlemaps.png",
                    titel1: "Ehr-Map",
                    img2: "Blogo.jpg",
                    titel2: "BBPS",
                    img: "Loan.png",
                    titel3: "LOS",
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Center(
                        child: SizedBox(
                      width: 350,
                      height: 2,
                      child: Center(
                          child: Container(
                        color: Colors.black26,
                      )),
                    )),
                  ),

                  // Visibility(
                  //   visible: claimmmm,
                  //   child: Padding(
                  //     padding: const EdgeInsets.only(
                  //         top: 10.0, left: 10.0, right: 10.0),
                  //     child: Container(
                  //       height: 140,
                  //       width: 450,
                  //       decoration: BoxDecoration(
                  //         borderRadius: BorderRadius.circular(10.0),
                  //         color: Colors.white,
                  //         boxShadow: [
                  //           BoxShadow(
                  //             color: Colors.grey.withOpacity(0.3),
                  //             spreadRadius: 3,
                  //             blurRadius: 7,
                  //             offset: const Offset(0, 3),
                  //           ),
                  //         ],
                  //       ),
                  //       child: Column(
                  //         mainAxisAlignment: MainAxisAlignment.start,
                  //         children: [
                  //           const Row(
                  //             children: [
                  //               CircleAvatar(
                  //                 child: Icon(
                  //                   Icons.travel_explore,
                  //                   size: 32,
                  //                   color: Colors.blue,
                  //                 ),
                  //                 backgroundColor: Colors.white,
                  //               ),
                  //               SizedBox(width: 10),
                  //               Text(
                  //                 "Claims",
                  //                 style: TextStyle(
                  //                     fontFamily: "TimesNewRoman",
                  //                     fontSize: 15,
                  //                     fontWeight: FontWeight.bold),
                  //               ),
                  //             ],
                  //           ),
                  //           GestureDetector(
                  //             child: Row(
                  //               mainAxisAlignment:
                  //                   MainAxisAlignment.spaceEvenly,
                  //               children: ViewData.claimfinallist.map((title) {
                  //                 return Column(
                  //                   children: [
                  //                     InkWell(
                  //                       onTap: () {
                  //                         if (title['title'] == "BRE Claim") {
                  //                           Navigator.push(
                  //                               context,
                  //                               MaterialPageRoute(
                  //                                   builder: (context) =>
                  //                                       BreclaimPage()));
                  //                         } else if (title['title'] ==
                  //                             "Travel Request") {
                  //                           Navigator.push(
                  //                               context,
                  //                               MaterialPageRoute(
                  //                                   builder: (context) =>
                  //                                       Traveldashboard()));
                  //                         } else if (title['title'] ==
                  //                             "Travel Claim") {
                  //                           Navigator.push(
                  //                               context,
                  //                               MaterialPageRoute(
                  //                                   builder: (context) =>
                  //                                       const ClaimDashboard()));
                  //                         }
                  //                       },
                  //                       child: Image.asset(
                  //                         'assets/images/${title['icon']}', // Update path as per your directory
                  //                         width: 40,
                  //                         height: 40,
                  //                         errorBuilder:
                  //                             (context, error, stackTrace) {
                  //                           return const Icon(Icons
                  //                               .error); // Show error icon if image not found
                  //                         },
                  //                       ),
                  //                     ),
                  //                     const SizedBox(height: 5),
                  //                     InkWell(
                  //                         onTap: () {
                  //                           if (title['title'] == "BRE Claim") {
                  //                             Navigator.push(
                  //                                 context,
                  //                                 MaterialPageRoute(
                  //                                     builder: (context) =>
                  //                                         BreclaimPage()));
                  //                           } else if (title['title'] ==
                  //                               "Travel Request") {
                  //                             Navigator.push(
                  //                                 context,
                  //                                 MaterialPageRoute(
                  //                                     builder: (context) =>
                  //                                         Traveldashboard()));
                  //                           } else if (title['title'] ==
                  //                               "Travel Claim") {
                  //                             Navigator.push(
                  //                                 context,
                  //                                 MaterialPageRoute(
                  //                                     builder: (context) =>
                  //                                         const ClaimDashboard()));
                  //                           } else {}
                  //                         },
                  //                         child: Text(
                  //                           title['title'] ?? '',
                  //                           style: const TextStyle(
                  //                               fontFamily: "TimesNewRoman",
                  //                               fontSize: 15),
                  //                         )),
                  //                   ],
                  //                 );
                  //               }).toList(),
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // ),

                  // const ComponentHome3(
                  //           iconCode: claim,
                  //           title: "Claims",
                  //         subTitle: "Travel Request, Travel Approval, BRE Claims",
                  //         img1:"Travel.png",
                  //         titel1: "Travel",
                  //         img2: "Claim.PNG",
                  //         titel2: "BRE Claim",
                  //       //  img : "Pulls.PNG",
                  //        // titel3: "Polls & Survey",
                  //         ),

                  Visibility(
                    // visible: viewmoree,
                    visible: false,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 3,
                              blurRadius: 7,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Align(
                          alignment: Alignment.center,
                          child: InkWell(
                            onTap: () async {
                              // SharedPreferences prefs =
                              //     await SharedPreferences.getInstance();

                              // ViewData.emikid =
                              //     prefs.getString("EmpKid").toString();

                              // await menulist();    
                              },
                            child: const Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.more,
                                    size: 32,
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Text(
                                    "More View",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Center(
                        child: SizedBox(
                      width: 350,
                      height: 2,
                      child: Center(
                          child: Container(
                        color: Colors.black26,
                      )),
                    )),
                  ),

                  // Carousel Slider
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Future<bool> _onWillPop(BuildContext context) async {
    // Show a dialog asking if the user wants to logout
    return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Are you sure?"),
              content: const Text(
                  "Do you want to log out or stay on the Dashboard?"),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false); // Stay on the page
                  },
                  child: const Text("Stay"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const Login())); // Exit the app or go to another screen
                  },
                  child: const Text("Logout"),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  Widget _buildProfileImage(String base64Image, BuildContext context) {
    if (base64Image.isNotEmpty) {
      Uint8List imageBytes = base64Decode(base64Image);
      return Center(
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LogoutPage()),
            );
          },
          child: CircleAvatar(
            radius: 18,
            backgroundImage: MemoryImage(imageBytes),
          ),
        ),
      );
    } else {
      return Center(
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LogoutPage()),
            );
          },
          child: const CircleAvatar(
            radius: 18,
            backgroundImage: AssetImage('assets/images/profileuser.png'),
          ),
        ),
      );
    }
  }

  Widget _buildIconButton(String image, VoidCallback onPressed,
      {String? badgeContent}) {
    return GestureDetector(
        onTap: onPressed,
        child: badges.Badge(
          showBadge: badgeContent != null,
          badgeContent: badgeContent != null
              ? Text(
                  badgeContent,
                  style: const TextStyle(color: Colors.white),
                )
              : null,
          position: badges.BadgePosition.topEnd(top: -10, end: -10),
          child: Container(
            width: 35,
            height: 35,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Center(
              child: Image.asset(
                'assets/images/$image',
                width: 30,
                height: 30,
              ),
            ),
          ),
        ));
  }

  Widget _buildattendancecalendra() {
    return Container(
      color: Colors.white,
      height: 270,
      child: AttendanceCalendar(),
    );
  }

  Widget _date() {
    // Get the current date and time
    DateTime now = DateTime.now();

    // Format the date and time
    String formattedDate =
        DateFormat('yMMMd').format(now); // e.g., Dec 23, 2024
    String formattedTime = DateFormat('hh:mm a').format(now); // e.g., 02:45 PM
    String dayOfWeek = DateFormat('EEEE').format(now); // e.g., Monday

    return Visibility(
      visible: dateee,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.blue,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Display Date and Day
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  formattedDate, // Displays the current date
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  dayOfWeek, // Displays the day of the week
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            // Display Time
            Text(
              formattedTime, // Displays the current time
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabView() {
    return Visibility(
      visible: tabbar,
      child: DefaultTabController(
        length: 2,
        // initialIndex:0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Colors.white,
              child: const TabBar(
                labelStyle: TextStyle(
                    fontFamily: "TimesNewRoman",
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
                labelColor: Color(0xFF547EC8),
                unselectedLabelColor: Color.fromARGB(255, 133, 50, 50),
                tabs: [
                  Tab(
                    text: 'Today Attendance',
                  ),
                  Visibility(
                      child: Tab(
                        text: "My Attendance",
                      ),
                      visible: true),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: Container(
                color: Colors.white,
                height: 270, // Adjust height as needed
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: TabBarView(
                    children: [
                      // AttendanceCalendar(),
                      Testingpage(),
                      _buildMyAttendanceTab(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMyAttendanceTab() {
    return Container(
      padding: const EdgeInsets.all(5),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Builder(builder: (context) {
              return MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(textScaler: const TextScaler.linear(1.0)),
                child: Card(
                  margin: const EdgeInsets.all(5),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("My attendance for last 30 days:",
                            style: TextStyle(
                                fontFamily: "TimesNewRoman",
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0D3092),
                                fontSize: 10)),
                        _buildAttendanceRow("Leaves:", leaves, Colors.green),
                        _buildAttendanceRow(
                            "Present days:", presence, Colors.green),
                        _buildAttendanceRow(
                            "Absent days:", absents, Colors.red),
                        const Text("Weekly hours clocked in:",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: "TimesNewRoman",
                                color: Color(0xFF0D3092),
                                fontSize: 10)),
                        _buildAttendanceRow("Week 1:", W1, Colors.green),
                        _buildAttendanceRow(
                            "Week 2:", W2, const Color(0xFF0D3092)),
                        _buildAttendanceRow("Week 3:", W3, Colors.green),
                        _buildAttendanceRow("Week 4:", W4, Colors.green),
                        _buildAttendanceRow(
                            "Week 5:", W5, const Color(0xFF0D3092)),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
          Expanded(
            flex: 1,
            child: Builder(builder: (context) {
              return MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(textScaler: const TextScaler.linear(1.0)),
                child: Card(
                  margin: const EdgeInsets.all(5),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Sub-ordinate's Today Status",
                            style: TextStyle(
                                fontFamily: "TimesNewRoman",
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0D3092),
                                fontSize: 10)),
                        _buildAttendanceRow("Leaves: ", Ll, Colors.green),
                        _buildAttendanceRow("Present: ", Pp, Colors.green),
                        _buildAttendanceRow("Absent: ", Aa, Colors.red),
                        _buildAttendanceRow("Total: ", Tt, Colors.green),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceRow(String title, String value, Color valueColor) {
    return Row(
      children: [
        Text(title,
            style: TextStyle(
                fontFamily: "TimesNewRoman",
                fontWeight: FontWeight.bold,
                color: valueColor,
                fontSize: 10)),
        const SizedBox(width: 5),
        Text(value,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 10)),
      ],
    );
  }

  Future<void> AttendanceParaMAPData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      ServerDetails serverDetails = ServerDetails();

      String empKid = prefs.getString('EmpKid') ?? '';
      String restUrl =
          '${AppCongifP.apiurllink}/${AppCongifP.applicationName}/ServiceData.aspx?callFor=AttendancePara&EmpId=$empKid';

      debugPrint('URL: ${restUrl.replaceAll(' ', '')}');

      var uri = Uri.parse(restUrl.replaceAll(' ', ''));
      var response = await http.get(uri);

      debugPrint('Response: ${response.statusCode}');

      if (response.statusCode == 200) {
        var content = response.body;
        var responseList = json.decode(content) as List;

        // Extracting string data from the first item in the list
        var firstItem = responseList[0];
        String empid = firstItem['EmpAttendPara_Empid'].toString();
        String attendanceRequired =
            firstItem['EmpAttendPara_AttendanceRequred'].toString();
        String attendAllowMobile =
            firstItem['EmpAttendPara_AttendAllowMobile'].toString();
        String locationAllow =
            firstItem['EmpAttendPara_LocationAllow'].toString();
        String pictureAllow =
            firstItem['EmpAttendPara_PictureAllow'].toString();
        String attendJurnanyAllow =
            firstItem['EmpAttendPara_AttendJurnanyAllow'].toString();
        String attendJurnanyEveryMinute =
            firstItem['EmpAttendPara_AttendJurnanyEveryMinute'].toString();
        String jurananyNotFoundMinute =
            firstItem['EmpAttendPara_Jurananynotfoundminute'].toString();
        String jurananyAbsentLeaveMark =
            firstItem['EmpAttendPara_JurananyAbsentLeaveMark'].toString();

        final prefs = await SharedPreferences.getInstance();
        // Saving values in SharedPreferences
        prefs.setString('EmpId', empid.toString());
        prefs.setString('AttendanceRequired', attendanceRequired.toString());
        prefs.setString('AttendAllowMobile', attendAllowMobile.toString());
        prefs.setString('LocationAllow', locationAllow.toString());
        prefs.setString('PictureAllow', pictureAllow.toString());
        prefs.setString('AttendJurnanyAllow', attendJurnanyAllow.toString());
        prefs.setString(
            'AttendJurnanyEveryMinute', attendJurnanyEveryMinute.toString());
        prefs.setString(
            'JurananyNotFoundMinute', jurananyNotFoundMinute.toString());
        prefs.setString(
            'JurananyAbsentLeaveMark', jurananyAbsentLeaveMark.toString());

        prefs.setString('PendingMessage', content);

        // Navigator.of(context).push(
        //   MaterialPageRoute(
        //    // builder: (context) => NotificationPage(pendingMessages: pendingMessages),
        //   ),
        // );
      }
    } catch (e) {
      print("Error: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> ModuleParameter() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      ServerDetails serverDetails = ServerDetails();

      String restUrl =
          '${AppCongifP.apiurllink}/${AppCongifP.applicationName}/ServiceData.aspx?callFor=ModuleList';

      debugPrint('URL: ${restUrl.replaceAll(' ', '')}');

      var uri = Uri.parse(restUrl.replaceAll(' ', ''));
      var response = await http.get(uri);

      debugPrint('Response: ${response.statusCode}');

      if (response.statusCode == 200) {
        var content = response.body;

        List<dynamic> modules = jsonDecode(content);

        // Iterate over the list to find the matching module
        for (var module in modules) {
          if (module['mnuModule_ename'] == 'ATTENDANCE MANAGEMENT' &&
              module['mnuModule_ActiveOnMobile'] == "N") {
            setState(() {
              //  mohinList.add({'title': 'Leave', 'icon': 'nwleave.PNG'});
              //   mohinList.add({'title': 'SalarySlip', 'icon': 'salary.PNG'});
            });
          } else if (module['mnuModule_ename'] == 'LEAVE MANAGEMENT' &&
              module['mnuModule_ActiveOnMobile'] == "N") {
            // mohinList.add({'title': 'Attendance', 'icon': 'attend.PNG'});
            // mohinList.add({'title': 'SalarySlip', 'icon': 'salary.PNG'});
          } else if (module['mnuModule_ename'] == 'PAYROLL MANAGEMENT' &&
              module['mnuModule_ActiveOnMobile'] == "N") {
            //       mohinList.add({'title': 'Attendance', 'icon': 'attend.PNG'});
            //  mohinList.add({'title': 'Leave', 'icon': 'nwleave.PNG'});
          } else if (module['mnuModule_ename'] == 'ATTENDANCE MANAGEMENT' &&
              module['mnuModule_ActiveOnMobile'] == "Y") {
            Attendlist.add({'title': 'Attendance', 'icon': 'attend.PNG'});
          } else if (module['mnuModule_ename'] == 'LEAVE MANAGEMENT' &&
              module['mnuModule_ActiveOnMobile'] == "Y") {
            Attendlist.add({'title': 'Leave', 'icon': 'nwleave.PNG'});
          } else if (module['mnuModule_ename'] == 'PAYROLL MANAGEMENT' &&
              module['mnuModule_ActiveOnMobile'] == "Y") {
            Attendlist.add({'title': 'SalarySlip', 'icon': 'salary.PNG'});
          } else if (module['mnuModule_ename'] == 'CLAIM MANAGEMENT' &&
              module['mnuModule_ActiveOnMobile'] == "N") {
          } else if (module['mnuModule_ename'] == 'CLAIM MANAGEMENT' &&
              module['mnuModule_ActiveOnMobile'] == "Y") {
            claimlist.add({'title': 'BRE Claim', 'icon': 'Claim.PNG'});
            claimlist.add({'title': 'Travel Request', 'icon': 'Travel.png'});
            claimlist.add({'title': 'Travel Claim', 'icon': 'Claim.PNG'});
          }
        }

        Set<String> titles = {};
        Set<String> titles1 = {};

        ViewData.modules = modules;

        for (var item in Attendlist) {
          if (!titles.contains(item['title'])) {
            titles.add(item['title'] ?? 'Default Title');
            attendfinallist.add(item);
          }
        }

        for (var item in claimlist) {
          if (!titles1.contains(item['title'])) {
            titles1.add(item['title'] ?? 'Default Title');
            claimfinallist.add(item);
          }
        }

        ViewData.Attendlist = Attendlist;
        ViewData.attendfinallist = attendfinallist;
        ViewData.claimlist = claimlist;
        ViewData.claimfinallist = claimfinallist;
      }
    } catch (e) {
      print("Error: $e");
      setState(() {
        var isLoading = false;
      });
    }
  }

  Future<void> checkConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              'Alert',
              style: TextStyle(fontSize: 12),
            ),
            content: const Text(
              'Please Check Your Mobile Connection',
              style: TextStyle(fontSize: 12),
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
          );
        },
      );
      return;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              'Alert',
              style: TextStyle(fontSize: 12),
            ),
            content: const Text(
              'Please Check Your Wi-Fi network',
              style: TextStyle(fontSize: 12),
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
          );
        },
      );
      return;
      // Connected to a Wi-Fi network.
      // ignore: unrelated_type_equality_checks
    } else if (connectivityResult == ConnectivityResult.none) {
      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              'Alert',
              style: TextStyle(fontSize: 12),
            ),
            content: const Text(
              'Please Check Your Internet Connection',
              style: TextStyle(fontSize: 12),
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
          );
        },
      );
      return;

      // Not connected to any network.
    }
  }

  Future<void> getCountingMessage() async {
    try {
      // Show loading indicator if necessary

      SharedPreferences prefs = await SharedPreferences.getInstance();
      ServerDetails serverDetails = ServerDetails();

      String empKid = prefs.getString('EmpKid') ??
          ''; // Replace with your method to get employee ID

      String restUrl =
          "${AppCongifP.apiurllink}/${AppCongifP.applicationName}/ServiceData.aspx?callFor=NotiFic&Empid=$empKid";
      debugPrint("URL: $restUrl");

      final response = await http.get(Uri.parse(restUrl));
      debugPrint("response: ${response.statusCode}");

      if (response.statusCode == 200) {
        final content = response.body;
        List<dynamic> jsonResponse = jsonDecode(content);
        List<PendingMessagee> trends =
            jsonResponse.map((data) => PendingMessagee.fromJson(data)).toList();

        setState(() {
          badgeText = trends[0].attendBack.toString();
          leaveText = trends[0].leave.toString();
          notificationCount = trends[0].notification.toString();
        });

        await prefs.setString('badgeText', badgeText);
        await prefs.setString('leaveText', leaveText);
        await prefs.setString('notificationCount', notificationCount);
      } else {
        // Handle unsuccessful response
      }
    } catch (ex) {
      debugPrint("ERROR: ${ex.toString()}");
    }
  }

  Future<void> GetMyAttendance() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      ServerDetails serverDetails = ServerDetails();

      String empKid = prefs.getString('EmpKid') ?? '';
      empimage = prefs.getString('source');

      await EasyLoading.show(status: 'Loading...');
      String restUrl =
          "${AppCongifP.apiurllink}/${AppCongifP.applicationName}/servicedata.aspx?callFor=AttendanceReportS&Empkid=$empKid";

      try {
        var response = await http.get(Uri.parse(restUrl));
        if (response.statusCode == 200) {
          var content = response.body;
          await EasyLoading.dismiss();
          List<dynamic> tr = jsonDecode(content);
          List<MyAttendanceDetail> trends =
              tr.map((e) => MyAttendanceDetail.fromJson(e)).toList();
          int presencee = trends[0].present;
          presence = presencee.toString();
          int absentss = trends[0].absent;
          absents = absentss.toString();
          int leavess = trends[0].Leave;
          leaves = leavess.toString();
          isLoading = false;
          // setState(() {
          //   presence = trends[0].present;
          //   absents = trends[0].absent;
          //  leaves = trends[0].Leave;

          // });
        } else {
          // Handle the error
          setState(() {
            isLoading = false;
          });
        }
        getWeeklyData();
      } catch (e) {
        print("Error: $e");
      }
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print("error:$e");
    }
  }

  Future<void> getSubordinateDetail() async {
    int P = 0, A = 0, L = 0;
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      ServerDetails serverDetails = ServerDetails();

      String empKid = prefs.getString('EmpKid') ?? '';

      String restUrl =
          "${AppCongifP.apiurllink}/${AppCongifP.applicationName}/ServiceData.aspx?callFor=AttendanceReportSS&Empkid=$empKid";

      print('URL: $restUrl');
      var uri = Uri.parse(restUrl.replaceAll(" ", ""));
      var response = await http.get(uri);

      print('Response: $response');
      if (response.statusCode == 200) {
        var content = response.body;
        if (content != "Message:Failed") {
          List<dynamic> jsonList = json.decode(content);
          List<MyAttendanceDetaill> trends = jsonList
              .map((json) => MyAttendanceDetaill.fromJson(json))
              .toList();
          List<String> jsonStringList =
              trends.map((item) => json.encode(item.toJson())).toList();

          // Store the list of JSON strings in SharedPreferences
          await prefs.setStringList('attendss', jsonStringList);

          P = 0;
          A = 0;
          L = 0;
          for (var trend in trends) {
            double totalTime =
                double.parse(trend.totalTime.replaceAll(':', '.'));
            if (totalTime >= 8) {
              trend.flag = 'P';
            }
            switch (trend.flag) {
              case 'P':
                P++;
                trend.status = 'Present';
                break;
              case 'A':
                A++;
                trend.status = 'Absent';
                break;
              case 'L':
                L++;
                trend.status = 'Leave';
                break;
              case 'H':
                L++;
                trend.status = 'Holiday';
                break;
            }
          }
          Pp = P.toString();
          Ll = L.toString();
          Aa = A.toString();
          Tt = (P + A + L).toString();
          return;
        }
      }
    } catch (e) {
      print('Error: $e');
    }
    return;
  }

  Future<List<MyAttendanceDetaill>> getAttendanceData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> jsonStringList = prefs.getStringList('attendss') ?? [];

    List<MyAttendanceDetaill> trends = jsonStringList
        .map((item) => MyAttendanceDetaill.fromJson(json.decode(item)))
        .toList();
    return trends;
  }

  Future<void> getWeeklyData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      ServerDetails serverDetails = ServerDetails();

      String empKid = prefs.getString('EmpKid') ?? '';

      String restUrl =
          "${AppCongifP.apiurllink}/${AppCongifP.applicationName}/servicedata.aspx?callFor=EmpWeekWiseAttendance&Empkid=$empKid";
      var response = await http.get(Uri.parse(restUrl));

      if (response.statusCode == 200) {
        var content = response.body;
        List<dynamic> tr = jsonDecode(content);
        List<WeeklyData> trends =
            tr.map((e) => WeeklyData.fromJson(e)).toList();

        for (var trend in trends) {
          switch (trend.WeekNo) {
            case '1':
              W1 = trend.WeekTotAttend.toString();
              // W1=week1.toString();
              break;
            case '2':
              W2 = trend.WeekTotAttend.toString();
              // W2=week2.toString();
              break;
            case '3':
              W3 = trend.WeekTotAttend.toString();
              // W3=week3.toString();
              break;
            case '4':
              W4 = trend.WeekTotAttend.toString();
              // W4=week4.toString();
              break;
            case '5':
              W5 = trend.WeekTotAttend.toString();
              // W5=week5.toString();
              break;
          }
        }

        setState(() {
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> onNotiClicked(BuildContext context) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      ServerDetails serverDetails = ServerDetails();

      String empKid = prefs.getString('EmpKid') ?? '';
      String restUrl =
          '${AppCongifP.apiurllink}/${AppCongifP.applicationName}/ServiceData.aspx?callFor=Notification&Empid=$empKid';
      debugPrint('URL: ${restUrl.replaceAll(' ', '')}');

      var uri = Uri.parse(restUrl.replaceAll(' ', ''));
      var response = await http.get(uri);

      debugPrint('Response: ${response.statusCode}');

      if (response.statusCode == 200) {
        var content = response.body;
        var pendingMessages = (json.decode(content) as List)
            .map((i) => PendingMessage.fromJson(i))
            .toList();

        prefs.setString('PendingMessage', content);

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) =>
                NotificationPage(pendingMessages: pendingMessages),
          ),
        );
      }
    } catch (e) {
      print("Error: $e");
      setState(() {
        isLoading = false;
      });
    }
  }
}
