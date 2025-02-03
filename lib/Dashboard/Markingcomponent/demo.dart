import 'package:flutter/material.dart';

class CustomUI extends StatefulWidget {
  @override
  _CustomUIState createState() => _CustomUIState();
}

class _CustomUIState extends State<CustomUI> {
  // List of items to display
  List<Map<String, String>> tiles = [
    
    {'title': 'Visa', 'icon': 'Icons.event'},
    {'title': 'Salary Slip', 'icon': 'Icons.receipt'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Custom UI'),
      ),
      body: Column(
        children: [

          Padding(
      padding: const EdgeInsets.only(top: 10.0,left: 10.0,right: 10.0),
      child: Container(
        height: 140,
        width: 450,   
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          
           
           color: Colors.white,

         boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 3,
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],


        ),
        child: Column(
          
          mainAxisAlignment: MainAxisAlignment.start,
          children: [

             Row(
            children: [
              CircleAvatar(
                radius: 30,
                child: Icon(Icons.person, size: 30),
              ),
              SizedBox(width: 10),
              Text(
                "Mr. X's Attendance Leave Balance",
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: tiles.map((tile) {
              return Column(
                children: [
                  Icon(Icons.image, size: 40), // Replace with actual icons
                  SizedBox(height: 5),
                  Text(tile['title'] ?? ''),
                ],
              );
            }).toList(),
          ),

          ],
        ),
      ),
          // Profile row
         
          // Tiles row
          
          // (height: 20),
          // // Button to remove Attendance tile
          // ElevatedButton(
          //   onPressed: () {
          //     setState(() {
          //       tiles.removeWhere((tile) => tile['title'] == 'Attendance');
          //     });
          //   },
          //   child: Text('Remove Attendance'),
          // ),
          )
        ],
      ),
    );
  }
}


