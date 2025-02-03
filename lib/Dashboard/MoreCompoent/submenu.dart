import 'package:ehr/Dashboard/AttendanceCalendar.dart';
import 'package:ehr/Dashboard/CircularGuideline.dart';
import 'package:ehr/Dashboard/Holidaylist.dart';
import 'package:ehr/Dashboard/ehrMAP/journey_add.dart';
import 'package:ehr/Dashboard/viewmore/Loan/applyforloan.dart';
import 'package:ehr/Dashboard/viewmore/viewmore.dart';
import 'package:ehr/bbps/bbps.dart';
import 'package:flutter/material.dart';

class SubMenuMore extends StatelessWidget {
  final String img1;
  final String titel1;

  final String img2;
  final titel2;

  final String img;
  final String titel3;

  const SubMenuMore(
      this.img1, this.titel1, this.img2, this.titel2, this.img, this.titel3,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => JourneyAdd()));
            },
            child: Column(
              children: [
                SizedBox(
                  height: 42,
                  width: 42,
                  child: Image.asset("assets/images/$img1"),
                ),
                Text(
                  titel1,
                  style: TextStyle(fontFamily: "TimesNewRoman"),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => BBPS()));
            },
            child: Column(
              children: [
                SizedBox(
                  height: 42,
                  width: 42,
                  child: Image.asset("assets/images/$img2"),
                ),
                Text(
                  titel2,
                  style: TextStyle(fontFamily: "TimesNewRoman"),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const Applyforloan()));
            },
            child: Column(
              children: [
                SizedBox(
                  height: 42,
                  width: 42,
                  child: Image.asset("assets/images/$img"),
                ),
                Text(
                  titel3,
                  style: TextStyle(fontFamily: "TimesNewRoman"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
