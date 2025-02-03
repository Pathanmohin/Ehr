
import 'package:ehr/bbps/CableTv/cabletv.dart';
import 'package:ehr/bbps/CableTv/successfullyscreen.dart';
import 'package:flutter/material.dart';

class CableTVFatchBill extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CableTVFatchBill();
}

class _CableTVFatchBill extends State<CableTVFatchBill> {
  @override
  Widget build(BuildContext context) {
    double _getButtonFontSize(BuildContext context) {
      double screenWidth = MediaQuery.of(context).size.width;
      if (screenWidth > 600) {
        return 14.0; // Large screen
      } else if (screenWidth > 400) {
        return 15.0; // Medium screen
      } else {
        return 16.0; // Default size
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Fatch Bill",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CABLETV()),
            );
          },
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
        ),
        backgroundColor: const Color(0xFF0057C2),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: Container(
                width: 55,
                height: 45,
                decoration: const BoxDecoration(
                    // borderRadius: BorderRadius.circular(100.0),
                    color: Colors.white),
                child: Image.asset("assets/images/BBPS_Logo.png")),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Container(
              //width: size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 10, right: 8, left: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow('CONSUMER NAME', 'RONAK NYARIYA'),
                    _buildDetailRow('BILL DUE DATE', '9/10/2024'),
                    _buildDetailRow('BILL DATE', '21/9/2024'),
                    _buildDetailRow('AMOUNT', '₹1,765.61'),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          InkWell(
            onTap: () async {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SuccessfullyCabletv()));
            },
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 10.0, left: 10.0, right: 10.0, bottom: 10.0),
              child: Container(
                height: 55,
                decoration: BoxDecoration(
                  color: const Color(0xFF0057C2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    "PAY NOW",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: _getButtonFontSize(context),
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }                   

  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              title,
              style: const TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    );
  }
}
