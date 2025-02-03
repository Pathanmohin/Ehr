// ignore_for_file: library_private_types_in_public_api, deprecated_member_use

import 'dart:convert';

import 'package:ehr/Dashboard/Dashboard.dart';
import 'package:ehr/Dashboard/LeaveApprovalbymanager.dart';
import 'package:ehr/Dashboard/LeaveBalance.dart';
import 'package:ehr/Dashboard/LeaveCancel.dart';
import 'package:ehr/Dashboard/LeaveRequest.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';




class Leavedashboard extends StatefulWidget {
  const Leavedashboard({super.key});

  @override
  _LeavedashboardState createState() => _LeavedashboardState();
}


class _LeavedashboardState extends State<Leavedashboard> {


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: WillPopScope(onWillPop: () async {
      Navigator.push(context, MaterialPageRoute(builder: (context) => Dashboard()));
return false; 
        
      },
        child: Builder(
          builder: (context) {
            return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.1)),
              child: Scaffold(
                appBar: AppBar(
                  title: const Text(
                    "Leave Dashboard",
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
                  backgroundColor: const Color.fromARGB(255, 9, 145, 207),
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
                    Tab(text: 'Leave Request'),
                    Tab(text: 'Leave Balance'),
                    Tab(text: 'Leave Cancel'),
                    Tab(text: 'Leave Approval'),
                    
                  ],
                ),
              ),
              body: TabBarView( 
                children: [
                 
                  Leaverequest(),
                  Leavebalance(),
                  Leavecancel(),
                 Leaveapprovalbymanager(),
                 
                ],
              ),
              ),
            );
          }
        ),
      ),
    );
  }
}