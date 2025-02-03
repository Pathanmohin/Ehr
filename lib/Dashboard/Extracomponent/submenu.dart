import 'dart:convert';

import 'package:ehr/Dashboard/AttendanceCalendar.dart';
import 'package:ehr/Dashboard/CircularGuideline.dart';
import 'package:ehr/Dashboard/Holidaylist.dart';
import 'package:ehr/Dashboard/TravelClaim/comman.dart/Alert_Box.dart';
import 'package:ehr/Dashboard/viewmore/model/menumodel.dart';
import 'package:ehr/Dashboard/viewmore/model/viewdatavalid.dart';
import 'package:ehr/Dashboard/viewmore/viewmore.dart';
import 'package:ehr/app.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SubMenu2 extends StatelessWidget {
  final String img1;
  final String titel1;

  final String img2;
  final titel2;

  final String img;
  final String titel3;

  const SubMenu2(
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
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AttendanceCalendar()));
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
                  context,
                  MaterialPageRoute(
                      builder: (context) => CircularGuilelinePage()));
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
            onTap: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();

              ViewData.emikid = prefs.getString("EmpKid").toString();

              await menulist(context);
//Navigator.push(context, MaterialPageRoute(builder: (context)=> const BBPS()));
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

  Future<void> menulist(BuildContext context) async {
    // String empKid = prefs.getString('EmpKid') ?? '';
    String restUrl =
        '${AppCongifP.apiurllink}/${AppCongifP.applicationName}/ServiceData.aspx?callFor=MenuList';

    var uri = Uri.parse(restUrl.replaceAll(' ', ''));
    var response = await http.get(uri);

    try {
      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          var res = jsonDecode(response.body);

          List<PrMobileMenu> listMenu = [];
          MenuList.listMenu.clear();

          for (int i = 0; i < res.length; i++) {
            var data = res[i];

            print(data);

            PrMobileMenu object = PrMobileMenu();

            object.mobileMenuParentName = data["MobileMenu_ParentName"];
            object.mobileMenuIcon = data["MobileMenu_MobileMenuIcon"];

            listMenu.add(object);
          }

          MenuList.listMenu = listMenu;

          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const ViewMore()));
        } else {
          Alert_DialogBox.showAlert(context, "Menu List Not Available");
        }
      } else {
        Alert_DialogBox.showAlert(context, "Unable to connect with server");
      }
    } catch (e) {
      Alert_DialogBox.showAlert(context, "Unable to connect with server");
    }
  }
}
