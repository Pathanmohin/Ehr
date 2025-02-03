import 'dart:convert';

import 'package:ehr/Dashboard/Dashboard.dart';
import 'package:ehr/Dashboard/LeaveCancelbyEmployee.dart';
import 'package:ehr/app.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Leavecancel extends StatefulWidget {
  @override
  _LeavecancelState createState() => _LeavecancelState();
}

class LeaveList {
  int srNo;
  String? levTypeCategory;
  int levRequestKid;
  String? leaveName;
  String? fromDate;
  String? toDate;
  double totalLeaves;
  String? levRequestReqDate;
  String? status;

  LeaveList({
    required this.srNo,
    this.levTypeCategory,
    required this.levRequestKid,
    this.leaveName,
    this.fromDate,
    this.toDate,
    required this.totalLeaves,
    this.levRequestReqDate,
    this.status,
  });

  factory LeaveList.fromJson(Map<String, dynamic> json) {
    return LeaveList(
      srNo: json['SrNo'],
      levTypeCategory: json['levType_Category'] as String?,
      levRequestKid: json['levRequest_Kid'],
      leaveName: json['leaveName'] as String?,
      fromDate: json['FROMDate'] as String?,
      toDate: json['ToDate'] as String?,
      totalLeaves: json['TotalLeaves'],
      levRequestReqDate: json['levRequest_ReqDate'] as String?,
      status: json['Status'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'SrNo': srNo,
      'levType_Category': levTypeCategory,
      'levRequest_Kid': levRequestKid,
      'leaveName': leaveName,
      'FromDate': fromDate,
      'ToDate': toDate,
      'TotalLeaves': totalLeaves,
      'levRequest_ReqDate': levRequestReqDate,
      'Status': status,
    };
  }
}

class _LeavecancelState extends State<Leavecancel> {
  List<LeaveList> leaveHistoryData = [];

  @override
  void initState() {
    super.initState();
    OnGetList();
  }

  Future<void> OnGetList() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      ServerDetails serverDetails = ServerDetails();

      String userId = prefs.getString("userID") ?? '';

      String restUrl =
          '${AppCongifP.apiurllink}/${AppCongifP.applicationName}/servicedata.aspx?callFor=LeaveCancelListIOS&empcode=$userId';

      final response = await http.get(Uri.parse(restUrl));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        setState(() {
          leaveHistoryData = List<LeaveList>.from(
              data.map((item) => LeaveList.fromJson(item)));
          // leaveHistoryData.sort((a, b) => b.toDate.compareTo(a.toDate));
        });
      } else {
        throw Exception('Failed to load leave history');
      }
    } catch (e) {
      print('ERROR: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: const TextScaler.linear(1.1)),
        child: Scaffold(
          body: Container(
            height: 500,
            child: ListView.builder(
              itemCount: leaveHistoryData.length,
              itemBuilder: (context, index) {
                final item = leaveHistoryData[index];
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
                              const Text('Start Date:',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "TimesnewRoman",
                                      color: Color(0xFF547EC8))),
                              Text(item.fromDate.toString(),
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontFamily: "TimesnewRoman",
                                      color: Color(0xFF547EC8))),
                              const Text('End Date',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: "TimesnewRoman",
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF547EC8))),
                              Text(item.toDate.toString(),
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontFamily: "TimesnewRoman",
                                      color: Color(0xFF547EC8))),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              const Text('Action',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: "TimesnewRoman",
                                      color: Color(0xFF547EC8))),
                              GestureDetector(
                                onTap: () => _view(item),
                                child: const Text(
                                  "View",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "TimesnewRoman",
                                    color: Colors.blue,
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
    });
  }

  void _view(LeaveList item) {
    try {
      Navigator.pop(context); // Close the current modal
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Leavecancelbyemployee(
            backDate: item.levRequestKid.toString(),
          ),
        ),
      );
    } catch (e) {
      print('Error: $e');
    }
  }
}
