import 'package:flutter/material.dart';

class DataEntryPage extends StatefulWidget {
  @override
  _DataEntryPageState createState() => _DataEntryPageState();
}

class _DataEntryPageState extends State<DataEntryPage> {
  // Controllers for text fields
  TextEditingController field1Controller = TextEditingController();
  TextEditingController field2Controller = TextEditingController();
  TextEditingController field3Controller = TextEditingController();

  // List to store the entered data
  List<String> dataList = [];

  // Function to add data to the list and clear the text fields
  void addData() {
    String field1 = field1Controller.text;
    String field2 = field2Controller.text;
    String field3 = field3Controller.text;

    // Add data to the list
    setState(() {
      dataList.add('Field 1: $field1, Field 2: $field2, Field 3: $field3');

      // Clear the text fields
      field1Controller.clear();
      field2Controller.clear();
      field3Controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Data Example'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Input Fields
            TextField(
              controller: field1Controller,
              decoration: InputDecoration(labelText: 'Field 1'),
            ),
            TextField(
              controller: field2Controller,
              decoration: InputDecoration(labelText: 'Field 2'),
            ),
            TextField(
              controller: field3Controller,
              decoration: InputDecoration(labelText: 'Field 3'),
            ),

            SizedBox(height: 20),

            // "Add" Button
            ElevatedButton(
              onPressed: addData,
              child: Text('Add'),
            ),

            SizedBox(height: 20),

            // Display the list of added items
            Expanded(
              child: ListView.builder(
                itemCount: dataList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(dataList[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
