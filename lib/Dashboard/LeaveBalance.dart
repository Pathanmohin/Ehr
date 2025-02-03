import 'dart:convert';

import 'package:ehr/app.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Leavebalance extends StatefulWidget {
  @override
  _LeavebalanceState createState() => _LeavebalanceState();
}

class LeaveData {
  int srNo;
  String leaveCode;
  String leaveName;
  double balance;
  double requested;
  double sanctioned;
  double remaining;
  double maxAccum;
  double maxLevTakenAtATime;
  double rejected;
  double canceled;
  double requested1;
  double avilad;

  LeaveData({
    required this.srNo,
    required this.leaveCode,
    required this.leaveName,
    required this.balance,
    required this.requested,
    required this.sanctioned,
    required this.remaining,
    required this.maxAccum,
    required this.maxLevTakenAtATime,
    required this.rejected,
    required this.canceled,
    required this.avilad,
    required this.requested1,
  });

  factory LeaveData.fromJson(Map<String, dynamic> json) {
    return LeaveData(
      srNo: json['SrNo'],
      leaveCode: json['LeaveCode'],
      leaveName: json['LeaveName'],
      balance: json['Balance'],
      requested: json['Requested'],
      sanctioned: json['Sanctioned'],
      remaining: json['Remaining'],
      maxAccum: json['MaxAccum'],
      maxLevTakenAtATime: json['MaxLevTakenAtATime'],
      rejected: json['Rejected'],
      canceled: json['Canceled'],
      avilad: json['Avilad'],
      requested1: json['Requested1'],
    );
  }
}

class LeaveHistory {
  final String levType;
  final String fromDate;
  final String toDate;
  final double levRequestNoOfDays;
  final String status;

  LeaveHistory({
    required this.levType,
    required this.fromDate,
    required this.toDate,
    required this.levRequestNoOfDays,
    required this.status,
  });

  factory LeaveHistory.fromJson(Map<String, dynamic> json) {
    return LeaveHistory(
      levType: json['levType'],
      fromDate: json['FromDate'],
      toDate: json['ToDate'],
      levRequestNoOfDays: json['levRequest_NoOfDays'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'levType': levType,
      'FromDate': fromDate,
      'ToDate': toDate,
      'levRequest_NoOfDays': levRequestNoOfDays,
      'status': status,
    };
  }
}

class _LeavebalanceState extends State<Leavebalance> {
  List<LeaveData> leaveBalanceData = [];
  List<LeaveHistory> leaveHistoryData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchLeaveData();
    getLeaveHistory();
  }

  Future<void> fetchLeaveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    ServerDetails serverDetails = ServerDetails();

    String userId = prefs.getString("userID") ?? '';
    String restUrl =
        "${AppCongifP.apiurllink}/${AppCongifP.applicationName}/servicedata.aspx?callFor=GetEmpLeaveStatus&empcode=$userId";
    var response = await http.get(Uri.parse(restUrl));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        leaveBalanceData =
            List<LeaveData>.from(data.map((item) => LeaveData.fromJson(item)));
        // leaveHistoryData = List<LeaveData>.from(data['leaveHistory'].map((item) => LeaveData.fromJson(item)));
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> getLeaveHistory() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      ServerDetails serverDetails = ServerDetails();

      String Kid = prefs.getString('EmpKid')!;

      String restUrl =
          '${AppCongifP.apiurllink}/${AppCongifP.applicationName}/servicedata.aspx?callFor=LeaveReportList&Empcode=$Kid';

      final response = await http.get(Uri.parse(restUrl));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        setState(() {
          leaveHistoryData = List<LeaveHistory>.from(
              data.map((item) => LeaveHistory.fromJson(item)));
          leaveHistoryData.sort((a, b) => b.toDate.compareTo(a.toDate));
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
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        "Leave Balance",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                            fontSize: 18,
                            fontFamily: "TimesNewRoman"),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    color: Colors.blue,
                    padding: const EdgeInsets.all(5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Leave Type", style: headerTextStyle),
                        Text("Requested", style: headerTextStyle),
                        Text("Sanctioned", style: headerTextStyle),
                        Text("Balance", style: headerTextStyle),
                      ],
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: leaveBalanceData.length,
                    itemBuilder: (context, index) {
                      final item = leaveBalanceData[index];
                      return Container(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(item.leaveCode, style: itemTextStyle),
                            Text(item.requested.toString(),
                                style: itemTextStyle),
                            Text(item.sanctioned.toString(),
                                style: itemTextStyle),
                            Text(item.remaining.toString(),
                                style: itemTextStyle),
                          ],
                        ),
                      );
                    },
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                    child: Text(
                      "Leave Summary",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0D3092),
                        fontSize: 15,
                        fontFamily: "TimesNewRoman",
                      ),
                    ),
                  ),
                  Container(
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      const Text('Leave Type:',
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: "TimesnewRoman",
                                              color: Color(0xFF547EC8))),
                                      Text(item.levType,
                                          style: const TextStyle(
                                              fontSize: 12,
                                              fontFamily: "TimesnewRoman",
                                              color: Color(0xFF547EC8))),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      const Text('From Date:',
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontFamily: "TimesnewRoman",
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF547EC8))),
                                      Text(item.fromDate,
                                          style: const TextStyle(
                                              fontSize: 12,
                                              fontFamily: "TimesnewRoman",
                                              color: Color(0xFF547EC8))),
                                      const Text('To Date:',
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontFamily: "TimesnewRoman",
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF547EC8))),
                                      Text(item.toDate,
                                          style: const TextStyle(
                                              fontSize: 12,
                                              fontFamily: "TimesnewRoman",
                                              color: Color(0xFF547EC8))),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      const Text('Total Leave:',
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontFamily: "TimesnewRoman",
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF547EC8))),
                                      Text(item.levRequestNoOfDays.toString(),
                                          style: const TextStyle(
                                              fontSize: 12,
                                              fontFamily: "TimesnewRoman",
                                              color: Color(0xFF547EC8))),
                                      const Text('Status:',
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontFamily: "TimesnewRoman",
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF547EC8))),
                                      Text(item.status.toString(),
                                          style: const TextStyle(
                                              fontSize: 12,
                                              fontFamily: "TimesnewRoman",
                                              color: Color(0xFF547EC8))),
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
                ],
              ),
            ),
    );
  }

  Widget rowItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: const TextStyle(
                  color: Color(0xFF547EC8),
                  fontSize: 12,
                  fontFamily: "TimesNewRoman",
                  fontWeight: FontWeight.bold)),
          Text(value,
              style: const TextStyle(
                  color: Color(0xFF547EC8),
                  fontSize: 12,
                  fontFamily: "TimesNewRoman")),
        ],
      ),
    );
  }

  final TextStyle headerTextStyle = const TextStyle(
    color: Colors.white,
    fontSize: 11,
    fontWeight: FontWeight.bold,
    fontFamily: "TimesNewRoman",
  );

  final TextStyle itemTextStyle = const TextStyle(
    color: Colors.black,
    fontSize: 11,
    fontFamily: "TimesNewRoman",
  );
}
