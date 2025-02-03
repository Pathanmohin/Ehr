// ignore_for_file: avoid_print, library_private_types_in_public_api, non_constant_identifier_names, sized_box_for_whitespace, file_names, unused_local_variable

import 'dart:convert';
import 'package:ehr/app.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Testingpage extends StatefulWidget {
  const Testingpage({super.key});

  @override
  _TestingpageState createState() => _TestingpageState();
}

class _TestingpageState extends State<Testingpage> {

 

  String inTime = '';
  String outTime = '';
  String offtime='';
  String exittime='';
  String duration = '';
  double progressValue = 0.0;

  @override
  void initState() {
    super.initState();
    OnGetResponse();
    onShifttime();
  }
 

 Future<void> onShifttime() async{

  SharedPreferences prefs = await SharedPreferences.getInstance();
    ServerDetails serverDetails = ServerDetails();
    
    
    
   
    String userId = prefs.getString("userID") ?? '';

    final String restUrl = '${AppCongifP.apiurllink}/${AppCongifP.applicationName}/ServiceData.aspx?callFor=Alarm&empcode=$userId';
try {
      var response = await http.get(Uri.parse(restUrl));
      if (response.statusCode == 200) {
        String content = response.body;
      
        if (content != "[]") {
          List<dynamic> file = jsonDecode(content);
          for (var item in file) {
            setState(() {
            DateTime offDateTime = DateFormat('HH:mm').parse(item["timepara_offtime"]);
            DateTime exitDateTime = DateFormat('HH:mm').parse(item["timepara_exittime"]);

            offtime = DateFormat('hh:mm a').format(offDateTime);
            exittime = DateFormat('hh:mm a').format(exitDateTime);   
              }

            );}
          }
        }
       
      else {
        print('Failed to load data');
      }
     }
     catch (e) {
      print('Error fetching data: $e');
    }

 }


  Future<void> OnGetResponse() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    ServerDetails serverDetails = ServerDetails();
    
    
    
   
    String userId = prefs.getString("userID") ?? '';
       
    final String restUrl = '${AppCongifP.apiurllink}/${AppCongifP.applicationName}/ServiceData.aspx?callFor=CheckAttendance&empcode=$userId';

    try {
      var response = await http.get(Uri.parse(restUrl));

      if (response.statusCode == 200) {
        String content = response.body;
        
        if(content=="[]"){
          inTime="00:00";
          outTime="00:00";
          duration="00:00:00";
        }
        if (content != "[]") {
          List<dynamic> file = jsonDecode(content);
          for (var item in file) {
            setState(() {
                         DateTime now = DateTime.now();

            DateTime inDateTime = DateFormat('HH:mm').parse(item["AttendInTime"]);
             inDateTime = DateTime(now.year, now.month, now.day, inDateTime.hour, inDateTime.minute);


            DateTime outDateTime = DateFormat('HH:mm').parse(item["AttendExitTime"]);
            outDateTime = DateTime(now.year, now.month, now.day, outDateTime.hour, outDateTime.minute);

            inTime = DateFormat('hh:mm a').format(inDateTime); 
            outTime = DateFormat('hh:mm a').format(outDateTime);   

              // inTime = item["AttendInTime"];
              // outTime = item["AttendExitTime"];
              
               if (item["AttendExitTime"] == "00:00") {
                
               // DateTime inDateTime = DateFormat('HH:mm').parse(inTime);
                DateTime currentDateTime = DateTime.now();
                Duration difference = currentDateTime.difference(inDateTime);
                duration = _formatDuration(difference);
                double totalHours = difference.inMinutes / 60.0;
                progressValue = totalHours / 9.0;
                
                
              }
              else{
               // DateTime inDateTime = DateFormat('HH:mm').parse(inTime);
              //  DateTime outDateTime = DateFormat('HH:mm').parse(outTime);
                Duration difference=outDateTime.difference(inDateTime);
                duration=_formatDuration(difference);
                double totalHours = difference.inMinutes / 60.0;
                 if (totalHours >= 9.0) {
                  progressValue = 1.0; // Full progress
                } else {
                  progressValue = totalHours / 9.0; // Calculate progress percentage
                }


              }

            });
          }
        }
      } else {
        print('Failed to load data');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }
   String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
  DateTime now = DateTime.now();
  String formattedDate = DateFormat('EEE MMM d yyyy').format(now);
  String currentTime = DateFormat('HH:mm:ss').format(now);
    return Scaffold( 
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: ClockOutCard(inTime: inTime, outTime: outTime, currentTime: currentTime, formattedDate: formattedDate,duration: duration,progressValue: progressValue, offtime: offtime,exittime: exittime,),
          ),
        ],
      ),
    );
  }
}

class ClockOutCard extends StatelessWidget {
  final String inTime;
  final String outTime;
  final String currentTime;
  final String formattedDate;
  final String duration;
  final double progressValue;
  final String offtime;
  final String exittime;
 

  const ClockOutCard({super.key, required this.inTime, required this.outTime, required this.currentTime, required this.formattedDate,required this.duration, required this.progressValue, required this.exittime,required this.offtime});





  
  
  @override
  Widget build(BuildContext context) {
   
    
    return Builder(
      builder: (context) {
        return MediaQuery(
         data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)),
          child: Card(
            
            margin: const EdgeInsets.all(10.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
              
            ),
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                const SizedBox(
                  height: 30,
                ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Today',
                        style: TextStyle(
                          fontFamily: "TimesNewRoman",
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        duration,
                        style: const TextStyle(
                          fontFamily: "TimesNewRoman",
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    formattedDate,
                    style: const TextStyle(
                      fontFamily: "TimesNewRoman",
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: progressValue, // Dummy progress value
                    color: Colors.green,
                    backgroundColor: Colors.grey[300],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        inTime,
                        style: const TextStyle(fontFamily: "TimesNewRoman",fontWeight: FontWeight.bold),
                      ),
                      Text(
                        outTime,
                        style: const TextStyle(fontFamily: "TimesNewRoman",fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Shift: $offtime - $exittime',
                        style: const TextStyle(
                          fontSize: 16,
                          fontFamily: "TimesNewRoman",
                         // fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      }
    );
  }
}
