import 'dart:convert';
import 'package:ehr/Dashboard/BackDateAuthorizedMgr.dart';
import 'package:ehr/app.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class BackdateauthorizelistPage extends StatefulWidget {
  @override
  _BackdateauthorizelistPageState createState() =>
      _BackdateauthorizelistPageState();
}

class _BackdateauthorizelistPageState extends State<BackdateauthorizelistPage> {
  List<BackdateItem> items = [];
  bool isVisible = false; // Control the visibility of the ListView
  bool showAlert = false; // Control the visibility of the alert Label
  bool isLoading = true; // Control the loading state

  @override
  void initState() {
    super.initState();
    _getList();
  }

  Future<void> _getList() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      ServerDetails serverDetails = ServerDetails();

      String empKid = prefs.getString('EmpKid') ?? '';

      String restUrl ='${AppCongifP.apiurllink}/${AppCongifP.applicationName}/servicedata.aspx?callFor=AttendanceShowApprovList&Empid=$empKid';
      //String restUrl ='${AppCongifP.apiurllink}/${AppCongifP.applicationName}/servicedata.aspx?callFor=AttendanceShowApprovList&Empid=308';

      final response = await http.get(Uri.parse(restUrl));

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        List<BackdateItem> fetchedItems =
            data.map((item) => BackdateItem.fromJson(item)).toList();

        setState(() {
          items = fetchedItems;
          isVisible = items.isNotEmpty;
          showAlert = items.isEmpty;
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      setState(() {
        showAlert = true;
      });
      print('ERROR: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: const TextScaler.linear(1.1)),
        child: Scaffold(
          body: isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    Visibility(
                      visible: showAlert,
                      child: const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          "Nothing is pending for approval",
                          style: TextStyle(
                            fontFamily: "TimesNewRoman",
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0D3092),
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Expanded(
                      child: BackdateList(items: items, isVisible: isVisible),
                    ),
                  ],
                ),
        ),
      );
    });
  }
}

class BackdateList extends StatelessWidget {
  final List<BackdateItem> items;
  final bool isVisible;

  BackdateList({required this.items, this.isVisible = false});

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: const TextScaler.linear(1.0)),
        child: Visibility(
          visible: isVisible,
          child: ListView.builder(
            itemCount: items.length,
            padding: const EdgeInsets.all(5),
            itemBuilder: (context, index) {
              final item = items[index];
              return Card(
                // shape: RoundedRectangleBorder(
                //   side: BorderSide(color: Color(0xFFBD830A)),
                // ),
                color: const Color(0xFFF6F6F6), elevation: 2.0,
                margin: const EdgeInsets.symmetric(vertical: 5),
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'Name :   ',
                            style: TextStyle(
                                color: Color(0xFF547EC8),
                                fontSize: 12,
                                fontFamily: "TimesNewRoman"),
                          ),
                          Text(
                            item.name,
                            style: const TextStyle(
                                color: Color(0xFF547EC8),
                                fontSize: 12,
                                fontFamily: "TimesNewRoman"),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          const Text(
                            'Date :    ',
                            style: TextStyle(
                                color: Color(0xFF547EC8),
                                fontSize: 12,
                                fontFamily: "TimesNewRoman"),
                          ),
                          Text(
                            item.date,
                            style: const TextStyle(
                                color: Color(0xFF547EC8),
                                fontSize: 12,
                                fontFamily: "TimesNewRoman"),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          const Text(
                            'Action : ',
                            style: TextStyle(
                                color: Color(0xFF547EC8),
                                fontSize: 12,
                                fontFamily: "TimesNewRoman"),
                          ),
                          GestureDetector(
                            onTap: () => _viewItem(context, item),
                            child: const Text(
                              'View',
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "TimesNewRoman"),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      );
    });
  }

  void _viewItem(BuildContext context, BackdateItem item) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
          'BackKid', item.Id.toString()); // Ensure id is stored as a string

      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Backdateauthorizedmgrpage()),
      );
    } catch (e) {
      print('ERROR: $e');
    }
  }
}

class BackdateItem {
  final String name;
  final String date;
  final int Id;

  BackdateItem({required this.name, required this.date, required this.Id});

  factory BackdateItem.fromJson(Map<String, dynamic> json) {
    return BackdateItem(
      name: json['Name'],
      date: json['Date'],
      Id: json['id'],
    );
  }
}
