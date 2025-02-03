import 'package:flutter/material.dart';

class DropdownExample extends StatelessWidget {
  String? selectedValue;

  final List<Map<String, dynamic>> data = [
    {"category": "AIR", "kid": 1, "value": "EXECUTIVE CLASS"},
    {"category": "AIR", "kid": 2, "value": "BUSINESS CLASS"},
    {"category": "AIR", "kid": 3, "value": "ECONOMY CLASS"},
    {"category": "ROAD", "kid": 4, "value": "NON AC BUS"},
    {"category": "ROAD", "kid": 5, "value": "ORDINARY PUBLIC BUS"},
    {"category": "ROAD", "kid": 6, "value": "TAXI"},
    {"category": "ROAD", "kid": 7, "value": "AC TAXI"},
    {"category": "TRAIN", "kid": 8, "value": "AC 1 CLASS"},
    {"category": "TRAIN", "kid": 9, "value": "SLEEPER"},

    // Add more items here...
  ];
  List<DropdownMenuItem<String>> _buildDropdownItems() {
    List<DropdownMenuItem<String>> items = [];

    String? currentCategory;
    for (var item in data) {
      if (item['category'] != currentCategory) {
        // Add category header
        items.add(
          DropdownMenuItem<String>(
            enabled: false, // Make the header unselectable
            child: Text(
              item['category'],
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ),
        );
        currentCategory = item['category'];
      }
      // Add item under the category
      items.add(
        DropdownMenuItem<String>(
          value: item['value'],
          child: Padding(
            padding:
                const EdgeInsets.only(left: 16.0), // Indent item under header
            child: Text(item['value']),
          ),
        ),
      );
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Grouped Dropdown Example")),
      body: Center(
        child: DropdownButtonFormField<String>(
          value: selectedValue,
          items: _buildDropdownItems(),
          onChanged: (newValue) {
            // setState(() {
            //   selectedValue = newValue;
            // });
          },
          decoration: InputDecoration(
            labelText: "Select an Option",
            border: OutlineInputBorder(),
          ),
        ),
      ),
    );
  }
}
