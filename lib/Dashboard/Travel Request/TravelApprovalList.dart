import 'dart:convert';
import 'package:ehr/Dashboard/Travel%20Request/TravelApprovalbyManager.dart';
import 'package:ehr/app.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Travelapprovallist extends StatefulWidget {
  @override
  _TravelapprovallistState createState() => _TravelapprovallistState();
}

class _TravelapprovallistState extends State<Travelapprovallist> {
  List<TourRequestList> tourRequestList = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
   travellist();
  }

 Future<void> travellist() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    ServerDetails serverDetails = ServerDetails();
    
    
    
   
    String empKid = prefs.getString('EmpKid') ?? '';
    
    final String restUrl ='${AppCongifP.apiurllink}/${AppCongifP.applicationName}/servicedata.aspx?callFor=TravelAuthoList&EmpId=$empKid';

    final response = await http.get(Uri.parse(restUrl));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      setState(() {
        tourRequestList = List<TourRequestList>.from(data.map((item) => TourRequestList.fromJson(item)));
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  void onButtonClicked(String travelRequestKid, String empId ){
    // Navigate to the details page
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TravelApprovalByManager(  travelRequestKid: travelRequestKid,
          empId: empId,)),
    );
  }

  

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Alert"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: tourRequestList.length,
              itemBuilder: (context, index) {
                final item = tourRequestList[index];
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildRow("Name", item.empName),
                        _buildRow("Start Date", item.startDate),
                        _buildRow("End Date", item.endDate),
                        _buildRow("Destination", item.destination),
                        _buildRow("Status", item.status),
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            onPressed: () => onButtonClicked(item.travelRequestID,item.empKid.toString()),
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              backgroundColor: const Color(0xFF547EC8),
                            ),
                            child: const Text(
                              "View Details",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            "$label:",
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value ?? "",
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}

class TourRequestList {
  final int srNo;
  final int empKid;
  final String empNo;
  final String empName;
  final String travelRequestID;
  final String startDate;
  final String endDate;
  final String destination;
  final String requestDate;
  final double estimatedCost;
  final String status;
  final String urlString;
  final String trvKid;

  TourRequestList({
    required this.srNo,
    required this.empKid,
    required this.empNo,
    required this.empName,
    required this.travelRequestID,
    required this.startDate,
    required this.endDate,
    required this.destination,
    required this.requestDate,
    required this.estimatedCost,
    required this.status,
    required this.urlString,
    required this.trvKid,
  });

  factory TourRequestList.fromJson(Map<String, dynamic> json) {
    return TourRequestList(
      srNo: json['SrNo'] ?? '',
      empKid: json['EmpKid'] ?? '',
      empNo: json['EmpNo'] ?? '',
      empName: json['EmpName'] ?? '',
      travelRequestID: json['TravelRequestID'] ?? '',
      startDate: json['StartDate'] ?? '',
      endDate: json['EndDate'] ?? '',
      destination: json['Destination'] ?? '',
      requestDate: json['RequestDate'] ?? '',
      estimatedCost: json['EstimatedCost'] ?? '',
      status: json['Status'] ?? '',
      urlString: json['UrlString'] ?? '',
      trvKid: json['TrvKid'] ?? '',
    );
  }
}




