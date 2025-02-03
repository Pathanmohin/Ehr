

import 'package:ehr/Dashboard/Dashboard.dart';
import 'package:ehr/Dashboard/ehrMAP/View_Map.dart';
import 'package:ehr/Dashboard/ehrMAP/back_service.dart';
import 'package:ehr/Dashboard/ehrMAP/models/vobject.dart';
import 'package:ehr/Dashboard/ehrMAP/secondpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';



class JourneyAdd extends StatefulWidget { 
  
  const JourneyAdd({super.key});

   @override
  State<StatefulWidget> createState() => _JourneyAdd();
}

class _JourneyAdd extends State<JourneyAdd>{

  
  final myController = TextEditingController();
 
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }
 

 



 Future<void> getAllJourney(String Jname) async {

DateTime _selectedDate = DateTime.now();
 String DataValue =  "${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}";

  // Define the endpoint URL
  var url = Uri.parse('http://192.168.1.120:8590/CobaSys/rest/SalePortal/V1/getLocationHistory');

  // Prepare your data to be sent
  var data = {"usrKid":"1","Date":DataValue,"JourneyName": "-1"};

  // Encode your data to JSON
  var jsonData = jsonEncode(data);

  try {
    
    // Make the POST request
    var response = await http.post(      
      url,

      headers: <String, String>{
        
        'Content-Type': 'application/json; charset=UTF-8',

      },

      body: jsonData,

    );

   
    if (response.statusCode == 200) {
      
       
var a = response.body;

Map<String, dynamic> decodedResponse = json.decode(a);
var getData = decodedResponse["Data"];

//var dataGet = JsonEncoder(getData);

List ab = json.decode(getData);






if(ab.length == 0){

    SharedPreferences  prefs = await SharedPreferences.getInstance();



                    final service = FlutterBackgroundService();
                         bool isRunning = await service.isRunning();

                  prefs.setString("keyJourney", myController.text);

                  prefs.setBool("journey", true);


               if(isRunning == false){

               initializeService();
               
              FlutterBackgroundService().invoke('setAsForeground');

              service.startService();

              

             
       }else{



      service.invoke('stopServices');

       Fluttertoast.showToast(
        msg: "Fail",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0
    );
                 initializeService();
                 await service.startService();
                 FlutterBackgroundService().invoke('setAsForeground');
                
       }

// Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MapScreen()));

  return;
}


for(int i=0;i<ab.length;i++){

JourneyList data = new JourneyList();


String Data = ab[i]["JourneyName"].toString();

if(Jname == Data){


       Fluttertoast.showToast(
        msg: "This Journey Aleady Ended....",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0
    );


  return;
}





}


             SharedPreferences  prefs = await SharedPreferences.getInstance();



                    final service = FlutterBackgroundService();
                         bool isRunning = await service.isRunning();

                  prefs.setString("keyJourney", myController.text);

                  prefs.setBool("journey", true);


               if(isRunning == false){

                initializeService();

              FlutterBackgroundService().invoke('setAsForeground');

              service.startService();

               }

  // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MapScreen()));


    } else {
      // Handle error if any

      
       Fluttertoast.showToast(
        msg: "${response.statusCode}",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0
    );
    
      print('Failed with status code: ${response.statusCode}');

    }
  } on SocketException catch (e) {
    // Handle socket errors

           Fluttertoast.showToast(
        msg: "$e",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0
    );

    print('Socket Exception: $e');

  } catch (e) {
    // Handle any other exceptions

       Fluttertoast.showToast(
        msg: "$e",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0
    );

    print('Exception: $e');
  }
}









  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         title: const Text(
                  "View Journey",
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
        backgroundColor: Colors.blue,

      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(

            mainAxisAlignment: MainAxisAlignment.center,
            
            children: [

             
               


                GestureDetector(onTap: () async {
                      

                       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MapScreen()));


                      if(myController.text == "" || myController.text == null){
                            
                        Fluttertoast.showToast(
                        msg: 'Please Enter Correct Journey Name',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0
                        );

                        return;

                      }else{



                 // getAllJourney(myController.text);


                
             }

                },
                child:Container(
                      padding: const EdgeInsets.all(12),
                      width: 250,
                      height: 55,
                      decoration: BoxDecoration(
                        
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      
                      child: 
                      const Center(
                        child: Text('View Map',
                        style: TextStyle(color: Colors.white,fontSize: 20),)),
                                 ),

                ),

               const SizedBox(height: 10,),



                GestureDetector(
                   
                    onTap: () {
                      
                     Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) =>  SecondRoute()),
                              );

                                     },
                                   
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      width: 250,
                      height: 55,
                      decoration: BoxDecoration(
                        
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: 
                      const Center(
                        child: Text('View Journey',
                        style: TextStyle(color: Colors.white,fontSize: 20),)),
                                 ),
                              ),
                          ],
                        ),
                      ),
                    ),  
                );
              }
            }


