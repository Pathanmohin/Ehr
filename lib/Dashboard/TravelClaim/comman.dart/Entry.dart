import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TaxFieldd extends StatelessWidget {
  final String entryName;
  final String labelName;
  final TextEditingController entryController;
  final TextEditingController labelController;

  // Constructor to accept controllers
  TaxFieldd({
    required this.entryName,
    required this.labelName,
    required this.entryController,
    required this.labelController,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Column for "Bill No" field
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              entryName,
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  fontFamily: "TimesNewRoman",
                  color: Color(0xFF547EC8)),
            ),
            Container(
              width: 150,
              height: 45, // Matching width for TextFormField container
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(5),
              ),
              child: TextFormField(
                controller: entryController, // Using the passed controller
                keyboardType: TextInputType.text,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  hintText: entryName,
                  border: InputBorder.none, // Remove the inner border
                ),
              ),
            ),
          ],
        ),
        // Column for "Item Details" field
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              labelName,
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  fontFamily: "TimesNewRoman",
                  color: Color(0xFF547EC8)),
            ),
            Container(
              width: 150,
              height: 45, // Matching width for TextFormField container
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(5),
              ),
              child: TextFormField(
                controller: labelController, // Using the passed controller
                keyboardType: TextInputType.text,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  hintText: labelName,
                  border: InputBorder.none, // Remove the inner border
                ),
                // onChanged: (value)=>,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
