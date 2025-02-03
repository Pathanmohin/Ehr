import 'dart:convert';
import 'package:ehr/Dashboard/Dashboard.dart';
import 'package:ehr/app.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class CircularGuilelinePage extends StatefulWidget {
  @override
  _CircularGuilelinePageState createState() => _CircularGuilelinePageState();
}

class _CircularGuilelinePageState extends State<CircularGuilelinePage> {
  List<Policy> policies = [];

  @override
  void initState() {
    super.initState();
    onGetList();
  }

  Future<void> onGetList() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      ServerDetails serverDetails = ServerDetails();

      String employeeId = prefs.getString('userID') ??
          ''; // replace with Application.Current.Properties["userID"].ToString()
      String restUrl =
          "${AppCongifP.apiurllink}/${AppCongifP.applicationName}/servicedata.aspx?callFor=GetCircularsList&Mode=1";

      // String restUrl = '${AppCongifP.apiurllink}/${AppCongifP.applicationName}/servicedata.aspx?callType=_TravelMode';

      var response = await http.get(Uri.parse(restUrl));
      if (response.statusCode == 200) {
        if (response.body == "[]") {
          await showDialog(
              context: context,
              builder: (context) => Builder(builder: (context) {
                    return MediaQuery(
                      data: MediaQuery.of(context)
                          .copyWith(textScaler: const TextScaler.linear(1.1)),
                      child: AlertDialog(
                        title: const Text('Alert'),
                        content: const Text('Data Not Available'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Dashboard()));
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  }));
        } else {
          var content = jsonDecode(response.body) as List;
          setState(() {
            policies = content.map((e) => Policy.fromJson(e)).toList();
          });
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      await showDialog(
        context: context,
        builder: (context) => Builder(builder: (context) {
          return MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: const TextScaler.linear(1.1)),
            child: AlertDialog(
              title: const Text('Alert'),
              content: const Text('Unable to Connect to the Server'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }),
      );
    }
  }

  Future<void> buttonClicked(String id) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      ServerDetails serverDetails = ServerDetails();

      String employeeId = prefs.getString('userID') ?? '';
      String restUrl =
          "${AppCongifP.apiurllink}/${AppCongifP.applicationName}/servicedata.aspx?callFor=GetCircularsList&Mode=2&CircularsListID=$id";
      var pdfUrl = Uri.parse(restUrl);

      if (await canLaunch(pdfUrl.toString())) {
        await launch(pdfUrl.toString());
      } else {
        throw 'Could not launch $pdfUrl';
      }
    } catch (e) {
      print('ERROR $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
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
                "Circular & GuideLines",
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: "TimesNewRoman",
                    fontSize: 18),
              ),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                color: Colors.white,
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Dashboard()));
                },
              ),
              backgroundColor: Colors.blue,
            ),
            body:
                PolicyList(policies: policies, onButtonClicked: buttonClicked),
          ),
        );
      }),
    );
  }
}

class Policy {
  final String policyName;
  final String date;
  final String mstName;
  final int kid;

  Policy(
      {required this.policyName,
      required this.date,
      required this.mstName,
      required this.kid});

  factory Policy.fromJson(Map<String, dynamic> json) {
    return Policy(
      policyName:
          json['policyName'] ?? 'Unknown Policy', // Default value if null
      date: json['frmguidopr_date'] ?? 'Unknown Date', // Default value if null
      mstName:
          json['frmguidopr_mstname'] ?? 'Unknown Name', // Default value if null
      kid: json['frmguidopr_kid'] ?? '',
    );
  }
}

class PolicyList extends StatelessWidget {
  final List<Policy> policies;
  final Function(String) onButtonClicked;

  PolicyList({required this.policies, required this.onButtonClicked});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      child: ListView.builder(
        itemCount: policies.length,
        itemBuilder: (context, index) {
          return PolicyCard(
              policy: policies[index], onButtonClicked: onButtonClicked);
        },
      ),
    );
  }
}

class PolicyCard extends StatelessWidget {
  final Policy policy;
  final Function(String) onButtonClicked;

  PolicyCard({required this.policy, required this.onButtonClicked});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFFF6F6F6),
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Color(0xFFBD830A)),
        borderRadius: BorderRadius.circular(4.0),
      ),
      margin: const EdgeInsets.all(5.0),
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Column(
          children: [
            Row(
              children: [
                const Text(
                  'Policy Name',
                  style: TextStyle(
                    color: Color(0xFF547EC8),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    fontFamily: 'Calibri',
                  ),
                ),
                const Spacer(),
                const Text(
                  'Travel',
                  style: TextStyle(fontSize: 12, color: Colors.black),
                ),
                const Spacer(),
                const Text(
                  'Date',
                  style: TextStyle(
                    color: Color(0xFF547EC8),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    fontFamily: 'Calibri',
                  ),
                ),
                const Spacer(),
                Text(
                  policy.date,
                  style: const TextStyle(fontSize: 12, color: Colors.black),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  policy.mstName,
                  style: const TextStyle(
                    color: Color(0xFF547EC8),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    fontFamily: 'Calibri',
                  ),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () => onButtonClicked(policy.kid.toString()),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text(
                    'View',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
