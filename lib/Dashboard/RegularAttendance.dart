import 'dart:convert';
import 'package:ehr/Dashboard/BackDateInsert.dart';
import 'package:ehr/app.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class RegularattendancePage extends StatefulWidget {
  @override
  RegularattendancePageState createState() => RegularattendancePageState();
}

class RegularattendancePageState extends State<RegularattendancePage> {
  List<AttendHistory> attendHistory = [];

  @override
  void initState() {
    super.initState();
    onGetList();
  }

  Future<void> onGetList() async {
    try {
      // Server details
     SharedPreferences prefs = await SharedPreferences.getInstance();

    ServerDetails serverDetails = ServerDetails();
    
    String empKid = prefs.getString('EmpKid') ?? '';

  
      String restUrl = '${AppCongifP.apiurllink}/${AppCongifP.applicationName}/servicedata.aspx?callFor=AttendanceReport&Empkid=$empKid';
      final response = await http.get(Uri.parse(restUrl));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          attendHistory = data.map((json) => AttendHistory.fromJson(json)).toList();
          attendHistory.forEach((item) {
            if (item.flag == 'P') {
              item.color = Colors.green;
              item.label = 'Present';
              item.enable = false;
            } else if (item.flag == 'H') {
              item.color = Colors.blue;
              item.label = 'Half Day';
              item.enable = false;
            } else if (item.flag == 'T') {
              item.color = Colors.orange;
              item.label = 'Travel';
              item.enable = false;
            } else if (item.flag == 'L') {
              item.color = Colors.pink;
              item.label = 'Leave';
              item.enable = false;
            } else if (item.flag == 'F') {
              item.color = Colors.blue;
              item.label = 'Holiday';
              item.enable = true;
            } else if (item.flag == 'A') {
              if (item.request == 1) {
                item.color = Colors.red;
                item.label = 'Requested';
                item.enable = false;
              } else {
                item.color = Colors.red;
                item.label = 'Absent';
                item.enable = true;
              }
            }
            if (item.late != null && item.late.isNotEmpty) {
              item.late = item.late.split(':')[0] + ' Hour ' + item.late.split(':')[1] + ' Minute';
            }
            if (item.early != null && item.early.isNotEmpty) {
              item.early = item.early.split(':')[0] + ' Hour ' + item.early.split(':')[1] + ' Minute';
            }
          });
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return MediaQuery(
       data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)),
          child: Scaffold(
            
            body: Container(
              child: ListView.builder(
                itemCount: attendHistory.length,
                itemBuilder: (context, index) {
                  final item = attendHistory[index];
                  return Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Card(
                      color: const Color(0xFFF6F6F6),
                      elevation: 2.0,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                const Text('Date:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold,fontFamily: "TimesnewRoman", color: Color(0xFF547EC8))),
                                Text(item.dateCol, style: const TextStyle(fontSize: 12 ,fontFamily: "TimesnewRoman" , color: Color(0xFF547EC8))),
                                const Text('Total Working Hours:', style: TextStyle(fontSize: 12 ,fontFamily: "TimesnewRoman" , fontWeight: FontWeight.bold, color: Color(0xFF547EC8))),
                                Text(item.totalTime, style: const TextStyle(fontSize: 12 ,fontFamily: "TimesnewRoman", color: Color(0xFF547EC8))),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                const Text('In Time:', style: TextStyle(fontSize: 12 ,fontFamily: "TimesnewRoman", fontWeight: FontWeight.bold, color: Color(0xFF547EC8))),
                                Text(item.inTime, style: const TextStyle(fontSize: 12 ,fontFamily: "TimesnewRoman", color: Color(0xFF547EC8))),
                                const Text('Out Time:', style: TextStyle(fontSize: 12 ,fontFamily: "TimesnewRoman", fontWeight: FontWeight.bold, color: Color(0xFF547EC8))),
                                Text(item.outTime, style: const TextStyle(fontSize: 12 ,fontFamily: "TimesnewRoman", color: Color(0xFF547EC8))),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                const Text('Coming Late:', style: TextStyle(fontSize: 12 ,fontFamily: "TimesnewRoman", fontWeight: FontWeight.bold, color: Color(0xFF547EC8))),
                                const SizedBox(width: 5),
                                Text(item.late ?? '', style: const TextStyle(fontSize: 12 ,fontFamily: "TimesnewRoman", color: Color(0xFF547EC8))),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                const Text('Status', style: TextStyle(fontSize: 12 ,fontFamily: "TimesnewRoman", color: Color(0xFF547EC8))),
                                GestureDetector(
                                  onTap: () => _view(item),
                                  child: Text(
                                    item.label,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "TimesnewRoman",
                                      color: item.color,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      }
    );
  }

 



void _view(AttendHistory item) {
    try {
      Navigator.pop(context); // Close the current modal
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BackdateInsertPage(
            backDate: item.dateCol,
          ),
        ),
      );
    } catch (e) {
      print('Error: $e');
    }
  }
}

class AttendHistory {
  final int request;
  String late;
  String early;
  final String flag;
  final String dateCol;
  final String outTime;
  final String inTime;
  final String totalTime;
  String label;
  Color color;
  bool enable;
  

  AttendHistory({
    required this.request,
    required this.late,
    required this.early,
    required this.flag,
    required this.dateCol,
    required this.outTime,
    required this.inTime,
    required this.totalTime,
    required this.label,
    required this.color,
    required this.enable,
   
  });

  factory AttendHistory.fromJson(Map<String, dynamic> json) {
    return AttendHistory(
      request: json['Request'],
      late: json['late'],
      early: json['early'],
      flag: json['Flag'],
      dateCol: json['DateCol'],
      outTime: json['OutTime'],
      inTime: json['InTime'],
      totalTime: json['TotalTime'],
      label: '',
      color: Colors.black,
      enable: false,
     
    );
  }
}
