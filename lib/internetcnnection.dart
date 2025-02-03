import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:ehr/Dashboard/Dashboard.dart';

import 'package:flutter/material.dart';

class ConnectivityService {
  StreamSubscription<ConnectivityResult>? _subscription;

  void startMonitoring(BuildContext context) {
    _subscription = Connectivity().onConnectivityChanged.listen((result) {
      if (result == ConnectivityResult.none) {
        _showNoConnectionDialog(context);
      } else {
       Navigator.push(context, MaterialPageRoute(builder: (context)=> Dashboard()));

//-------------------------------------------------------------------------------------------------------------------------
      }
    }) as StreamSubscription<ConnectivityResult>?;
  }

  void _showNoConnectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("No Internet Connection"),
        content: Text("Please check your internet connection."),
        actions: <Widget>[
          TextButton(
            child: Text("OK"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  void dispose() {
    _subscription?.cancel();
  }
}
