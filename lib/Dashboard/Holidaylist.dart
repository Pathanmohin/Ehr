// ignore_for_file: unused_local_variable

import 'package:ehr/Dashboard/Dashboard.dart';
import 'package:ehr/app.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';


class HolidaylistPage extends StatefulWidget {
  @override
  _HolidaylistPageState createState() => _HolidaylistPageState();
}

class Holiday {
  final String date;
  final String day;
  final String holiday;
  final Color color;
  final Color textColor;

  Holiday({
    required this.date,
    required this.day,
    required this.holiday,
    required this.color,
    required this.textColor,
  });

  factory Holiday.fromJson(Map<String, dynamic> json) {
    String holidayDesc = json['holiday_edesc'];
    return Holiday(
      date: json['holiday_daate'],
      day: json['DateNames'],
      holiday: holidayDesc,
      color: Colors.grey[300]!,  // Default color
      textColor: holidayDesc == "weekly off" ? Colors.red : Colors.green,
    );
  }
}

class _HolidaylistPageState extends State<HolidaylistPage> {
  List<Holiday> holidays = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchHolidayList();
  }

  Future<void> fetchHolidayList() async {
    try {
     SharedPreferences prefs = await SharedPreferences.getInstance();

    ServerDetails serverDetails = ServerDetails();
    
    
    
   
    String userId = prefs.getString("userID") ?? ''; // Replace with actual application name
      String restUrl = '${AppCongifP.apiurllink}/${AppCongifP.applicationName}/servicedata.aspx?callFor=HolidayList&empcode=$userId';

      final response = await http.get(Uri.parse(restUrl));

      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(response.body);
        List<Holiday> fetchedHolidays = jsonData.map((json) => Holiday.fromJson(json)).toList();
        setState(() {
          holidays = fetchedHolidays;
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load holidays');
      }
    } catch (e) {
      print('ERROR: $e');
      setState(() {
        isLoading = false;
      });
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Alert',style: TextStyle(fontFamily: "TimesNewRoman")),
            content: const Text('Unable to connect to the server',style: TextStyle(fontFamily: "TimesNewRoman"),),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return MediaQuery(
           data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.1)),
          child: Scaffold(
            appBar: AppBar(
              title: const Text(
                "Holiday List",
                style: TextStyle(
                    color: Colors.white, fontFamily: "TimesNewRoman", fontSize: 18),
              ),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                color: Colors.white,
                onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => Dashboard()));
                },
              ),
              backgroundColor: Colors.blue,
            ),
            body: WillPopScope(
              onWillPop: () async{
                        Navigator.push(
                      context, MaterialPageRoute(builder: (context) => Dashboard()));
                      return false;
               
              },
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Container(
                      color: Colors.white,
                      margin: const EdgeInsets.all(5),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(5),
                            color: Colors.blue,
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 38,
                                  child: Text(
                                    "Date",
                                    style: TextStyle(
                                      fontFamily: 'TimesNewRoman',
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                   textAlign: TextAlign.start,
              
                                  ),
                                ),
                                Expanded(
                                  flex: 38,
                                  child: Text(
                                    "Day",
                                    style: TextStyle(
                                      fontFamily: 'TimesNewRoman',
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),      
                                 textAlign: TextAlign.start,
              
                                  ),
                                ),
                                Expanded(
                                  flex: 38,
                                  child: Text(
                                    "Holiday",
                                    style: TextStyle(
                                      fontFamily: 'TimesNewRoman',
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                               textAlign: TextAlign.start,
               
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: holidays.length,
                              itemBuilder: (context, index) {
                                final holiday = holidays[index];
                                return Container(
                                  padding: const EdgeInsets.all(5),
                                  color: holiday.color,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        flex: 25,
                                        child: Builder(
                                          builder: (context) {
                                            return MediaQuery(
                     data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.1)),
                                              child: Text(
                                                holiday.date,
                                                style: const TextStyle(
                                                  fontFamily: 'TimesNewRoman',
                                                  fontSize: 11,
                                                  color: Colors.black,
                                                ),
                                                textAlign: TextAlign.start,
                                              ),
                                            );
                                          }
                                        ),
                                      ),
                                      Expanded(
                                        flex: 25,
                                        child: Builder(
                                          builder: (context) {
                                            return MediaQuery(
                 data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.1)),
                                              child: Text(
                                                holiday.day,
                                                style: const TextStyle(
                                                  fontFamily: 'TimesNewRoman',
                                                  fontSize: 11,
                                                  color: Colors.black,
                                                ),
                                                textAlign: TextAlign.start,
                                              ),
                                            );
                                          }
                                        ),
                                      ),
                                      Expanded(
                                        flex: 25,
                                        child: Builder(
                                          builder: (context) {
                                            return MediaQuery(
                                            data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.1)),
                                              child: Text(
                                                holiday.holiday,
                                                style: TextStyle(
                                                  fontFamily: 'TimesNewRoman',
                                                  fontSize: 11,
                                                  color: holiday.textColor,
                                                ),
                                                textAlign: TextAlign.start,
                                              ),
                                            );
                                          }
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ),
        );
      }
    );
  }
}

void main() {
  runApp(MaterialApp(home: HolidaylistPage()));
}
