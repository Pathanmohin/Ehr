

import 'package:ehr/Dashboard/ehrMAP/servicecheck.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

class NotifiactionAlert extends StatefulWidget {  @override
  State<StatefulWidget> createState() => _NotifiactionAlertState();
}

class _NotifiactionAlertState extends State<NotifiactionAlert> {

NotificationsServices notificationServices = new NotificationsServices();

 late PermissionStatus _permissionStatus;

@override
  void initState() {

    super.initState();

     _checkNotificationPermission();
  
     notificationServices.initialiseNotification();
     
  }

  Future<void> _checkNotificationPermission() async {
    PermissionStatus status = await Permission.notification.status;
    setState(() {
      _permissionStatus = status;
    });
  }

  Future<void> _requestNotificationPermission() async {
    PermissionStatus status = await Permission.notification.request();
    setState(() {
      _permissionStatus = status;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Alert"), backgroundColor: Colors.blue,),

      body: SizedBox(
width: double.infinity,

child:  Column(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [


          ElevatedButton(onPressed: (){
          _requestNotificationPermission();
          notificationServices.sendNotification("Alert", "Please change your location.."); 

          }, child: Text("Send Notification")),

          SizedBox(height: 10,),

           ElevatedButton(onPressed: (){

        //  _requestNotificationPermission();
        //  notificationServices.sendNotification("Alert", "Please change your location.."); 

         notificationServices.sendNotificationSed("Alert", "Please change your location.."); 
            

          }, child: Text("Schedule Notification")),
       
           SizedBox(height: 10,),

           ElevatedButton(onPressed: (){
            
            notificationServices.sendNotificationSed("Alert", "Please change your location.."); 

          }, child: Text("Stop Notification")),
       
    

],),
      
    ),
    
    );
  }
}
