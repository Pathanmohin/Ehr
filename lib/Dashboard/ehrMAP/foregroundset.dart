import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

class ForeShow extends StatefulWidget {  @override
  State<StatefulWidget> createState()  => _ForeShowState();
}

class _ForeShowState  extends State<ForeShow>{
   String text = "Stop Service";

  
   @override
  
Widget build(BuildContext context) {
 
return Scaffold(
appBar: AppBar(title: Text("Home Page"),),
body: Center(
  child: Column(children: [
  
    ElevatedButton(onPressed: (){

      FlutterBackgroundService().invoke('setAsForeground');
    }, child: const Text("Foreground")),
  
  
  
    ElevatedButton(onPressed: (){
   FlutterBackgroundService().invoke('setAsBackground');
    }, child: const Text("Background")),
  
  
    ElevatedButton(onPressed: () async{
  
     final service = FlutterBackgroundService();
     bool isRunning = await service.isRunning();
     
     if(isRunning){

       service.invoke('stopServices');
  
     }else{

        service.startService();
  
     }
  
  if(! isRunning){
  text = "Stop Service";
  }else{

    text = "Start Service";
  }
  
  setState(() {
    
  });
  
    }, child: Text(text)),
  
  
  ],),
),
 );

  }
}
