// ignore_for_file: non_constant_identifier_names

import 'dart:convert';


import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:ehr/bbps/DTH/DTHRecharge.dart';
import 'package:ehr/bbps/EducationBill/Education.dart';
import 'package:ehr/bbps/ElectricityRecharge/Electricity.dart';
import 'package:ehr/bbps/FastTagRecharge/fasttage.dart';
import 'package:ehr/bbps/MobilePospaidRecharge/mobilepostpaid.dart';
import 'package:ehr/bbps/MobileRecharge/mobilerecharge.dart';
import 'package:ehr/bbps/Water/WaterRecharge.dart';
import 'package:ehr/bbps/model/recharge.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class BBPSMenu extends StatelessWidget {
  final IconData iconCode;
  final String title;

  const BBPSMenu({super.key, required this.iconCode, required this.title});
  static List<Rechargmobile> accounts_list_for_transfer_new = <Rechargmobile>[];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        InkWell(
          onTap: () async {
            final List<ConnectivityResult> connectivityResult =
                await (Connectivity().checkConnectivity());
            if (connectivityResult.contains(ConnectivityResult.none)) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Builder(builder: (context) {
                    return MediaQuery(
                      data: MediaQuery.of(context)
                          .copyWith(textScaler: const TextScaler.linear(1.0)),
                      child: AlertDialog(
                        title: const Text(
                          'Alert',
                          style: TextStyle(fontSize: 16),
                        ),
                        content: const Text(
                          'Please Check Your Internet Connection',
                          style: TextStyle(fontSize: 16),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text(
                              'OK',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    );
                  });
                },
              );

              return;
            } else if (title == "Mobile Recharge") {
              Loader.show(context,
                  progressIndicator: CircularProgressIndicator());
              Loader.hide();
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Recharge()));
              await Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Recharge()));
            } else if (title == "Mobile PostPaid") {
              Loader.show(context,
                  progressIndicator: CircularProgressIndicator());
              Loader.hide();
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => PostPaid()));
            } else if (title == "Electricity") {
              Loader.show(context,
                  progressIndicator: CircularProgressIndicator());
              Loader.hide();
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Electricity()));
            } else if (title == "DTH") {
              Loader.show(context,
                  progressIndicator: CircularProgressIndicator());
              Loader.hide();
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => DTHRecharhemobile()));
            } else if (title == "Water") {
              Loader.show(context,
                  progressIndicator: CircularProgressIndicator());
              Loader.hide();
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => WaterRecharge()));
            } else if (title == "FASTag") {
              Loader.show(context,
                  progressIndicator: CircularProgressIndicator());
              Loader.hide();
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => FastTag()));
            } else if (title == "Education") {
              Loader.show(context,
                  progressIndicator: CircularProgressIndicator());
              Loader.hide();
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Education()));
            }
          },
          child: Column(
            children: [
              Icon(
                iconCode,
                color: const Color(0xFF0057C2),
                size: 42,
              ),
              Text(
                title,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        // Icon(
        //   IconData(
        //     iconCode,
        //     fontFamily: 'MaterialIcons',
        //   ),
        //   color: const Color(0xFF0057C2),
        //   size: 32,
        // ),
        // Text(title),
      ],
    );
  }
}
