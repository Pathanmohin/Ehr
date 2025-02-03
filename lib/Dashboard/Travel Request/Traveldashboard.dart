import 'package:ehr/Dashboard/Dashboard.dart';
import 'package:ehr/Dashboard/Travel%20Request/TravelApprovalList.dart';
import 'package:ehr/Dashboard/Travel%20Request/TravelCancelStatusList.dart';
import 'package:ehr/Dashboard/Travel%20Request/travelrequest.dart';
import 'package:flutter/material.dart';


class Traveldashboard extends StatefulWidget {
  @override
  _TraveldashboardState createState() => _TraveldashboardState();
}

class _TraveldashboardState extends State<Traveldashboard> {

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
                    "Travel Dashboard",
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
                    Tab(text: 'Travel Request'),
                    Tab(text: 'Travel Approval'),
                    Tab(text: 'Travel Cancel'),
                   
                    
                  ],
                ),
              ),
              body: TabBarView( 
                children: [
                TravelRequest(),
                 Travelapprovallist(),
                 Travelcancelstatuslist(),
              
                 
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