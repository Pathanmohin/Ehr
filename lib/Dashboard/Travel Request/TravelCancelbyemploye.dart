// ignore_for_file: library_private_types_in_public_api, unused_local_variable, unnecessary_null_comparison

import 'dart:convert';
import 'package:ehr/Dashboard/Travel%20Request/Traveldashboard.dart';
import 'package:ehr/app.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Travelcancelbyemploye extends StatefulWidget {
  final String travelRequestKid;
  final String empId;

  const Travelcancelbyemploye({
    Key? key,
    required this.travelRequestKid,
    required this.empId,
  }) : super(key: key);

  @override
  _TravelcancelbyemployeState createState() =>
      _TravelcancelbyemployeState();
}

class _TravelcancelbyemployeState extends State<Travelcancelbyemploye> {
  List<TourDetail> tourDetails = [];
  List<Approvelist>approvelist=[];
late Future<void> _fetchFuture;
 String? _selectedAction ;
 String? Actionn;
 TextEditingController Remark=TextEditingController();

  @override
void initState() {
  super.initState();
  _fetchFuture = fetchTravelDetails();
 
}

  Future<void> fetchTravelDetails() async {
  try {
    final serverDetails = ServerDetails();
    SharedPreferences prefs = await SharedPreferences.getInstance();

     String empKid = prefs.getString('EmpKid') ?? '';
    final url =
        "${AppCongifP.apiurllink}/${AppCongifP.applicationName}/servicedata.aspx"
        "?callFor=TravelCancelReqDetFill&EmpId=$empKid&TravelReqCode=${widget.travelRequestKid}";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      print("Response Data: ${response.body}"); // Debugging

      final data = json.decode(response.body) as List<dynamic>;
      setState(() {
        tourDetails = data
            .map((item) => TourDetail.fromJson(item as Map<String, dynamic>))
            .toList();
      });
    } else {
      throw Exception('Failed to fetch data: ${response.statusCode}');
    }
  } catch (e) {
    print("Error: $e"); // Debugging
    throw Exception("Error: Unable to connect to the server");
  }
}


  
Future<void> travelApprove() async {
    try {


      if(Remark.text==null || Remark.text=="")
      {
      _showAlertDialogg("Alert","Please Enter Remark");
      return;
      }
     
     
     SharedPreferences prefs = await SharedPreferences.getInstance();

    ServerDetails serverDetails = ServerDetails();
    
    
    
   
        String empKid = prefs.getString('EmpKid') ?? '';
       String managerid = prefs.getString('ManagerID') ?? '';

   
      String restUrl = '${AppCongifP.apiurllink}/${AppCongifP.applicationName}/servicedata.aspx?callFor=TravelAuthoReq&TravAuthoRemark=${Remark.text}&ManagerID=$managerid&Action=T&EmpId=$empKid&TravelReqCode=${widget.travelRequestKid}';

      final response = await http.get(Uri.parse(restUrl));

      if (response.statusCode == 200) {
       
 String content = response.body;
    
    

       _showAlertDialog("Alert", content);


      } else {
        throw Exception('Failed ');
      }
    } catch (e) {
      print('ERROR: $e');
      setState(() {
        
      });

          }
        
  }
void _showAlertDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Builder(
          builder: (context) {
            return MediaQuery(
                     data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.1)),
              child: AlertDialog(
                title: Text(title),
                content: Text(message),
                actions: <Widget>[
                  TextButton(
                    child: const Text("OK"),
                    onPressed: () {
                      Navigator.pushReplacement(
           context, MaterialPageRoute(builder: (context) => Traveldashboard()));
                    },
                  ),
                ],
              ),
            );
          }
        );
      },
    );
  }

  void _showAlertDialogg(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Builder(
          builder: (context) {
            return MediaQuery(
                     data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.1)),
              child: AlertDialog(
                title: Text(title),
                content: Text(message),
                actions: <Widget>[
                  TextButton(
                    child: const Text("OK"),
                    onPressed: () {
                       Navigator.of(context).pop();
                       
                    },
                  ),
                ],
              ),
            );
          }
        );
      },
    );
  }



@override
Widget build(BuildContext context) {
  return Scaffold(
     appBar: AppBar(
                title: const Text(
                  "Tour Approval",
                  style: TextStyle(color: Colors.white, fontFamily: "TimesNewRoman", fontSize: 18),
                ),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  color: Colors.white,
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Traveldashboard()));
                  },
                ),
                backgroundColor: Colors.blue,
              ),
    body: FutureBuilder(
      future: _fetchFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (tourDetails.isEmpty) {
          return const Center(child: Text("No Data Available"));
        } else {
          return buildDetails();
        }
      },
    ),
  );
}



Widget buildDetails() {
  final detail = tourDetails[0];
  return SingleChildScrollView(
    padding: const EdgeInsets.all(8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var item in _buildDetailFields(detail)) item,
        const SizedBox(height: 10),
        // Dropdown for Approve/Reject
        
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildButton(' Send Cancel Request', () {
             travelApprove();
            }),
          ],
        ),
      ],
    ),
  );
}


  List<Widget> _buildDetailFields(TourDetail detail) {
    return [
      buildLabel('Employee Name'),
      buildDisabledEntry(detail.employeeName),
      buildLabel('Travel ID'),
      buildDisabledEntry(detail.travelRequestID),
      buildLabel('Status'),
      buildDisabledEntry(detail.status),
      buildLabel('Travel Type'),
      buildDisabledEntry(detail.travelType),
      buildLabel('Purpose Visit'),
      buildDisabledEntry(detail.purposeVisit),
      buildLabel('Travel Mode'),
      buildDisabledEntry(detail.travelMode),
      buildLabel('Start Date'),
      buildDisabledEntry(detail.startDate),
      buildLabel('End Date'),
      buildDisabledEntry(detail.endDate),
      buildLabel('Source'),
      buildDisabledEntry(detail.source),
      buildLabel('Destination'),
      buildDisabledEntry(detail.destination),
      buildLabel('Advance Details'),
      buildDisabledEntry(detail.advDetails),
      buildLabel('Purpose Details'),
      buildDisabledEntry(detail.purVisitDet),
      buildLabel('Guest House'),
      buildDisabledEntry(detail.guesthouseName),
      buildLabel('Group Type'),
      buildDisabledEntry(detail.grptype),
      buildLabel('Vehicle '),
      buildDisabledEntry(detail.vehicle),
      buildLabel('Estimated Fare'),
      buildDisabledEntry(detail.Estimatedfare.toString()),
      buildLabel('Estimated Boarding'),
      buildDisabledEntry(detail.Estimatedborading.toString()),
      buildLabel('Estimated Other'),
      buildDisabledEntry(detail.Estimatedother.toString()),
      buildLabel('Total Amount'),
      buildDisabledEntry(detail.Total.toString()),
      buildLabel('Advance Amount'),
      buildDisabledEntry(detail.estimatedAdv.toString()),
      buildLabel('Remark'),
      buildEntry("Enter Remark", controller: Remark),
    ];
  }

  Widget buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF547EC8),
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget buildDisabledEntry(String? placeholder) {
  return TextField(
    decoration: InputDecoration(
      hintText: placeholder ?? 'N/A',
      hintStyle: const TextStyle(color: Colors.black54, fontSize: 12),
      border: const OutlineInputBorder(),
    ),
    style: const TextStyle(color: Colors.black, fontSize: 12),
    enabled: false,
  );
}

Widget buildEntry(String? remark, {required TextEditingController controller}) {
  return TextFormField( 
    decoration: InputDecoration(
      hintText: remark ?? 'N/A',
      
      hintStyle: const TextStyle(color: Colors.black54, fontSize: 12),
      border: const OutlineInputBorder(),
    ),controller: Remark,
    style: const TextStyle(color: Colors.black, fontSize: 12),
  );
}


  Widget buildButton(String text, VoidCallback onPressed) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        side: const BorderSide(color: Color(0xFFBD830A)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF547EC8),
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  
}

class TourDetail {
  final String employeeName;
  final String travelRequestID;
  final String status;
  final String travelType;
  final String purposeVisit;
  final String travelMode;
  final String startDate;
  final String endDate;
  final String source;
  final String destination;
  final String advDetails;
  final String purVisitDet;
  final String guesthouseName;
  final double estimatedAdv;
  final String englishRemark;
  final double Estimatedfare;
  final double Estimatedborading;
  final double Estimatedother;
  final double Total;
  final String SPPlace;
  final String EPPlace;
  final String grptype;
  final String vehicle;



  TourDetail({
    required this.employeeName,
    required this.travelRequestID,
    required this.status,
    required this.travelType,
    required this.purposeVisit,
    required this.travelMode,
    required this.startDate,
    required this.endDate,
    required this.source,
    required this.destination,
    required this.advDetails,
    required this.purVisitDet,
    required this.guesthouseName,
    required this.estimatedAdv,
    required this.englishRemark,
    required this.Estimatedfare,
    required this.Estimatedborading,
    required this.Estimatedother,
    required this.EPPlace,
    required this.SPPlace,
    required this.Total,
    required this.grptype,
    required this.vehicle,
  });

  factory TourDetail.fromJson(Map<String, dynamic> json) {
  return TourDetail(
    employeeName: json['EmployeeName'] ?? 'N/A',
    travelRequestID: json['TravelRequestID'] ?? 'N/A',
    status: json['Status'] ?? 'N/A',
    travelType: json['TravelType'] ?? 'N/A',
    purposeVisit: json['PurposeVisit'] ?? 'N/A',
    travelMode: json['TravelMode'] ?? 'N/A',
    startDate: json['StartDate'] ?? 'N/A',
    endDate: json['EndDate'] ?? 'N/A',
    source: json['Source'] ?? 'N/A',
    destination: json['Destination'] ?? 'N/A',
    advDetails: json['ADVDetaisl'] ?? 'N/A',
    purVisitDet: json['PurVisitDet'] ?? 'N/A',
    guesthouseName: json['GuesthouseName'] ?? 'N/A',
    estimatedAdv: (json['Estimatedadv'] as num?)?.toDouble() ?? 0.0,
    englishRemark: json['EnglishRemark'] ?? 'N/A',
    Estimatedborading: (json['Estimatedborading'] as num?)?.toDouble() ?? 0.0,
    Estimatedfare: (json['Estimatedfare'] as num?)?.toDouble() ?? 0.0,
    Estimatedother: (json['Estimated other'] as num?)?.toDouble() ?? 0.0,
    Total: (json['Total'] as num?)?.toDouble() ?? 0.0,
    SPPlace: json['SPPlace'] ?? 'N/A',
    EPPlace: json['EPPlace'] ?? 'N/A',
    grptype: json['GrpType'] ?? 'N/A',
    vehicle: json['vehtype'] ?? 'N/A',
  );
}

}

class Approvelist {
   final int kid;
   final String value;
   final String text;

  Approvelist({
    required this.kid,
     required this.value,
     required  this.text,

  });

  factory Approvelist.fromJson(Map<String, dynamic> json) {
    return Approvelist(
      kid: json['Kid'] ,
      value: json["Name"],
      text: json['Flag']
    );
  }
}

