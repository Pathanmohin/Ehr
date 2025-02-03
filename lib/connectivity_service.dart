import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:ehr/Loginpage.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class ConnectivityService {
  bool isPreviouslyDisconnected = false;
  late StreamSubscription<ConnectivityResult> connectivitySubscription;

  void initialize(BuildContext context) {
    // connectivitySubscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
    //   _handleConnectivityChange(context, result);
    // });
  }

  void _handleConnectivityChange(BuildContext context, ConnectivityResult result) {
    if (result == ConnectivityResult.none) {
      isPreviouslyDisconnected = true;
      _showAlertDialog(context, "Network Error", "Please check your internet connection.", () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Login()),
        );
      });
    } else if (isPreviouslyDisconnected) {
      isPreviouslyDisconnected = false;
      _showAlertDialog(context, "Network Status", "You are online now.", () {});
    }
  }

  void _showAlertDialog(BuildContext context, String title, String content, VoidCallback onPressed) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
                onPressed();
              },
            ),
          ],
        );
      },
    );
  }

  void dispose() {
    connectivitySubscription.cancel();
  }
}
