// ignore_for_file: library_private_types_in_public_api, prefer_final_fields, non_constant_identifier_names, unused_field, use_build_context_synchronously, avoid_print, unused_local_variable, duplicate_ignore, unnecessary_null_comparison

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:ehr/Dashboard/Dashboard.dart';
import 'package:ehr/Model/bodymodel.dart';
import 'package:ehr/Model/profiledata.dart';
import 'package:ehr/app.dart';
import 'package:ehr/forgotpassword.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:local_auth/error_codes.dart';
import 'package:local_auth/local_auth.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:sim_card_info/sim_card_info.dart';
import 'package:sim_card_info/sim_info.dart';
import 'package:url_launcher/url_launcher.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<Login> {
  static const platform = MethodChannel('com.nscspl.eHRNatural/debugging');

  static const platform1 =
      MethodChannel('com.nscspl.eHRNatural/suspicious_apps');

  String _debuggingStatus = "Checking...";

  String uniqueID = "";

  final _formKey = GlobalKey<FormState>();
  bool savePassword = false;
  List<Parameter> Moduleparameter = [];
  final LocalAuthentication auth = LocalAuthentication();
  bool _isBiometricAvailable = false;
  bool _isBiometricEnabled = false;
  bool isBiometricAvailable = false;
  String currentVersion = "";
  String playStoreVersion = "";
  TextEditingController EmployeeCode = TextEditingController();
  TextEditingController password = TextEditingController();
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

  List<SimInfo>? _simInfo;
  final _simCardInfoPlugin = SimCardInfo();
  bool isSupported = true;

  @override
  void initState() {
    super.initState();
    //_checkUsbDebugging();
    //initSimInfoState();

    //checkForSuspiciousApps();
    _getAppVersion();
    _requestPermissions();
    ModuleParameter();

    //q  checkForSuspiciousApps();
    _checkWifiStatus();
    _loadCredentials();
    _checkBiometricAvailability();
  }

  Future<void> initSimInfoState() async {
    await Permission.phone.request();
    List<SimInfo>? simCardInfo;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      simCardInfo = await _simCardInfoPlugin.getSimInfo() ?? [];
    } on PlatformException {
      simCardInfo = [];
      setState(() {
        isSupported = false;
      });
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
    setState(() {
      _simInfo = simCardInfo;
    });
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => Builder(builder: (context) {
            return MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: const TextScaler.linear(1.1)),
              child: AlertDialog(
                title: new Text('Exit Page?'),
                content: const Text(
                  'Are you sure you want to exit this App? You will not be able to continue it.',
                  style: const TextStyle(fontSize: 16),
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text(
                      'No',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  TextButton(
                    onPressed: () => {exit(0)},
                    child: const Text(
                      'Yes',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            );
          }),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Builder(builder: (context) {
        return MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: const TextScaler.linear(1.1)),
          child: Scaffold(
            backgroundColor: Colors.white,
            body: Stack(children: [
              SingleChildScrollView(
                child: SafeArea(
                    child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 50),
                          child: SizedBox(
                            width: 150,
                            height: 150,
                            child: Image.asset(
                              'assets/images/logonn.jpg',
                            ),
                          ),
                        ),
                        MediaQuery(
                          data: MediaQuery.of(context).copyWith(
                              textScaler: const TextScaler.linear(1.0)),
                          child: const Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 100),
                              child: Text(" Welcome to eHR",
                                  style: TextStyle(
                                      fontFamily: 'TimesNewRoman',
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold))),
                        ),
                        const Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 5.0, horizontal: 100),
                            child: Text("Login",
                                style: TextStyle(
                                    fontFamily: 'TimesNewRoman',
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold))),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Container(
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.black, width: 1),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 2),
                                  child: Image.asset(
                                    "assets/images/profileuser.png",
                                    width: 53,
                                    height: 53,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                                child: Padding(
                              padding:
                                  const EdgeInsets.only(right: 10, left: 5),
                              child: TextFormField(
                                controller: EmployeeCode,
                                decoration: InputDecoration(
                                    border: const OutlineInputBorder(),
                                    hintText: EmployeeCode.text.isEmpty
                                        ? 'Enter Employee ID'
                                        : "Enter Employee ID",
                                    labelText: 'Username ',
                                    labelStyle: const TextStyle(
                                        fontFamily: 'TimesNewRoman'),
                                    hintStyle: const TextStyle(
                                        fontFamily: 'TimesNewRoman')),
                                style: const TextStyle(
                                    fontFamily: 'TimesNewRoman'),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please Enter Employee ID';
                                  }
                                  return null;
                                },
                              ),
                            )),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 8, left: 5),
                              child: Container(
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.black, width: 1),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 2),
                                  child: Image.asset(
                                    "assets/images/keys.png",
                                    width: 53,
                                    height: 53,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                                child: Padding(
                              padding: const EdgeInsets.only(
                                  right: 10, top: 5, left: 5),
                              child: TextFormField(
                                controller: password,
                                obscureText: true,
                                decoration: InputDecoration(
                                    border: const OutlineInputBorder(),
                                    hintText: password.text.isEmpty
                                        ? 'Enter Password'
                                        : "Enter Password",
                                    labelText: 'Password',
                                    labelStyle: const TextStyle(
                                        fontFamily: 'TimesNewRoman'),
                                    hintStyle: const TextStyle(
                                        fontFamily: 'TimesNewRoman')),
                                style: const TextStyle(
                                    fontFamily: 'TimesNewRoman'),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please Enter Password';
                                  }
                                  return null;
                                },
                              ),
                            )),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 10.0),
                              child: Text(
                                "Save Password",
                                style: TextStyle(
                                    fontFamily: "TimesNewRoman",
                                    color: Colors.black),
                              ),
                            ),
                            Checkbox(
                              value: savePassword,
                              onChanged: (bool? newValue) {
                                setState(() {
                                  savePassword = newValue!;
                                  _saveCredentials();
                                });
                              },
                              activeColor: const Color.fromARGB(255, 8, 6, 6),
                            )
                          ],
                        ),
                        InkWell(
                          onTap: () async {
                            final List<ConnectivityResult> connectivityResult =
                                await (Connectivity().checkConnectivity());
                            if (connectivityResult
                                .contains(ConnectivityResult.none)) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return Builder(builder: (context) {
                                    return MediaQuery(
                                      data: MediaQuery.of(context).copyWith(
                                          textScaler:
                                              const TextScaler.linear(1.1)),
                                      child: AlertDialog(
                                        title: const Text(
                                          'Alert',
                                          style: TextStyle(fontSize: 12),
                                        ),
                                        content: const Text(
                                          'Please Check Your Internet Connection',
                                          style: TextStyle(fontSize: 12),
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
                            }

                            // call API
                            if (_formKey.currentState!.validate()) {
                              if (isBiometricAvailable == false) {
                                getLogin(
                                    context, EmployeeCode.text, password.text);
                              } else {
                                _checkLatency();
                              }

                              if (savePassword) {
                                _saveCredentials();
                              }
                            } else {
                              return;
                            }
                          },
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  "LOGIN",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: _getButtonFontSize(context),
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        InkWell(
                          onTap: () async {
                            final List<ConnectivityResult> connectivityResult =
                                await (Connectivity().checkConnectivity());
                            if (connectivityResult
                                .contains(ConnectivityResult.none)) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return Builder(builder: (context) {
                                    return MediaQuery(
                                      data: MediaQuery.of(context).copyWith(
                                          textScaler:
                                              const TextScaler.linear(1.1)),
                                      child: AlertDialog(
                                        title: const Text(
                                          'Alert',
                                          style: TextStyle(fontSize: 12),
                                        ),
                                        content: const Text(
                                          'Please Check Your Internet Connection',
                                          style: TextStyle(fontSize: 12),
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
                            }

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Forgotpassword()));
                          },
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  "FORGOT PASSWORD",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: _getButtonFontSize(context),
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    "Version:",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontFamily: 'TimesNewRoman',
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    currentVersion,
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontFamily: 'TimesNewRoman'),
                                  ),
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: () async {
                                String url = 'https://naturalgrp.com';
                                Uri pdfUrl = Uri.parse(url);
                                launchUrl(
                                  pdfUrl,
                                  mode: LaunchMode.externalApplication,
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Image.asset(
                                        'assets/images/aboutt.png',
                                        width: 30,
                                        height: 30,
                                      ),
                                    ),
                                    const Text(
                                      "About Us",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontFamily: 'TimesNewRoman'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        MediaQuery(
                          data: MediaQuery.of(context).copyWith(
                              textScaler: const TextScaler.linear(1.0)),
                          child: const Align(
                            alignment: Alignment.bottomCenter,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                          "Copyright: Natural Support Consultancy Services Private Limited",
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.black,
                                              fontFamily: "TimesNewRoman")),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
              ),
              // MediaQuery(
              //   data: MediaQuery.of(context)
              //       .copyWith(textScaler: const TextScaler.linear(1.0)),
              //   child: const Align(
              //     alignment: Alignment.bottomCenter,
              //     child: Column(
              //       mainAxisAlignment: MainAxisAlignment.end,
              //       children: [
              //         Padding(
              //           padding: EdgeInsets.all(8),
              //           child: Column(
              //             mainAxisAlignment: MainAxisAlignment.start,
              //             children: [
              //               Text(
              //                   "Copyright: Natural Support Consultancy Services Private Limited",
              //                   style: TextStyle(
              //                       fontSize: 12,
              //                       color: Colors.black,
              //                       fontFamily: "TimesNewRoman")),
              //             ],
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
            ]),
          ),
        );
      }),
    );
  }

// Check if device is rooted
// Future<void> _checkRootStatus() async {
//   bool? isRooted = await RootCheck.checkForRootNative;

//   // if (isRooted != null && isRooted) {
//   //   print("Device is rooted");
//   // } else if (isRooted == false) {
//   //   print("Device is not rooted");
//   // } else {
//   //   print("Unable to determine root status");
//   // }
// }

// Check if WiFi is enabled
  Future<void> _checkWifiStatus() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.wifi) {
      _showWifiStatus(context);
    } else {
      print("WiFi is not enabled");
    }
  }

  Future<void> _requestPermissions() async {
    // Request Camera Permission
    PermissionStatus cameraStatus = await Permission.camera.request();
    if (cameraStatus.isGranted) {
      print("Camera permission granted.");
    } else if (cameraStatus.isDenied) {
      print("Camera permission denied.");
    } else if (cameraStatus.isPermanentlyDenied) {
      openAppSettings(); // Open app settings if the permission is permanently denied
    }

    // Request Location Permission
    PermissionStatus locationStatus = await Permission.location.request();
    if (locationStatus.isGranted) {
      print("Location permission granted.");
    } else if (locationStatus.isDenied) {
      print("Location permission denied.");
    } else if (locationStatus.isPermanentlyDenied) {
      openAppSettings(); // Open app settings if the permission is permanently denied
    }
  }

  void _showWifiStatus(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Builder(builder: (context) {
          return MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: const TextScaler.linear(1.1)),
            child: AlertDialog(
              title: const Text("WIFI is Enabled"),
              content: const Text(
                "We have detected WIFI mode is on. Please Turn it off use eHR HRMS Mobile Application.  ",
                style: TextStyle(fontSize: 15),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text(
                    "EXIT",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    SystemNavigator.pop(); // Closes the application
                  },
                ),
              ],
            ),
          );
        });
      },
    );
  }

  Future<void> _checkUsbDebugging() async {
    bool usbDebuggingEnabled;
    try {
      usbDebuggingEnabled =
          await platform.invokeMethod('isUsbDebuggingEnabled');
    } on PlatformException catch (e) {
      usbDebuggingEnabled = false;
      print("Failed to get USB debugging status: '${e.message}'.");
    }

    if (usbDebuggingEnabled) {
      _showDebuggingStatus();
    }
  }

  void _showDebuggingStatus() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Builder(builder: (context) {
          return MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: const TextScaler.linear(1.1)),
            child: AlertDialog(
              title: const Text("Turn Off USB Debugging"),
              content: const Text(
                "We have detected USB Debugging mode is on. Please Turn it off. Go to settings and disable developer mode to use eHR HRMS Mobile Application.\n1. Go to developer mode\n2. Find USB Debugging Mode\n3. Turn OFF USB Debugging",
                style: TextStyle(fontSize: 15),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text(
                    "EXIT",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    SystemNavigator.pop(); // Closes the application
                  },
                ),
              ],
            ),
          );
        });
      },
    );
  }

  Future<void> checkForSuspiciousApps() async {
    try {
      // Invoke the method channel to get the list of installed apps
      final List<dynamic> installedAppsDynamic =
          await platform1.invokeMethod('getInstalledApps');

      // Cast the result to a List<String>
      final List<String> installedApps = installedAppsDynamic.cast<String>();

      // List of suspicious apps to check against
      List<String> suspiciousApps = [
        // General Suspicious Apps
        "com.anydesk.anydeskandroid",
        "com.example.malwareapp", // Example for a known malware app
        "com.spyware.tracker", // Example for a spyware or tracking app
        "com.fakebanking.app", // Example for a phishing or fake banking app
        "com.freemium.hacktool", // Example for a hacking tool disguised as a freemium app
        "com.rootkit.hider", // Example for a rootkit or system-hiding tool
        "com.pirated.software", // Example for a pirated or cracked software distribution
        "com.ransomware.encryption", // Example for ransomware that encrypts files
        "com.keylogger.stealer", // Example for a keylogger or password-stealing app
        "com.adware.intrusive", // Example for adware that shows intrusive ads
        "com.fakeantivirus.scanner", // Example for a fake antivirus app that prompts unnecessary actions,

        // Suspicious VPN Apps
        "com.example.malwarevpn", // Example for a VPN app associated with malware
        "com.vpnfree.untrusted", // Example for a free VPN with questionable security
        "com.vpnproxy.fake", // Example for a VPN that falsely advertises security features
        "com.vpnhider.spy", // Example for a VPN app that secretly tracks user data
        "com.vpnservice.trojan", // Example for a VPN app that acts as a trojan
        "com.vpn.unsecure", // Example for a VPN app known for data leaks
        "com.fakevpn.ads", // Example for a VPN app that shows intrusive ads and lacks security
        "com.vpntracker.malicious", // Example for a VPN app that includes tracking and spyware components
        "com.piratevpn.illegal", // Example for a VPN app used for accessing illegal content
        "com.vpnhack.tool", // Example for a VPN app used as a hacking tool

        // Suspicious Remote Desktop Apps
        "com.example.remotedesktopmalware", // Example for a remote desktop app associated with malware
        "com.remotedesktop.spy", // Example for a remote desktop app that may spy on users
        "com.rdp.hacker", // Example for a remote desktop app used for hacking
        "com.remotecontrol.untrusted", // Example for an untrusted remote control app
        "com.remotedesktop.trojan", // Example for a remote desktop app that acts as a trojan
        "com.remoteaccess.unsecure", // Example for a remote desktop app known for security vulnerabilities
        "com.fake.rdpapp", // Example for a fake remote desktop app that performs malicious activities
        "com.spyware.remotedesktop", // Example for a remote desktop app that includes spyware components
        "com.unverified.remotedesktop", // Example for an unverified or untrusted remote desktop app
        "com.malicious.rdp", // Example for a remote desktop app associated with malicious activities
      ];

      // Check if any installed apps match the suspicious apps
      bool foundSuspicious = false;
      for (var app in installedApps) {
        if (suspiciousApps.contains(app)) {
          foundSuspicious = true;
          break;
        }
      }

      _showInstallationStatusDialog(foundSuspicious);

      // If suspicious apps are found, show an alert
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print("Failed to get installed apps: '${e.message}'.");
      }
    }
  }

  void _showInstallationStatusDialog(bool foundSuspicious) {
    if (foundSuspicious) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return Builder(
            builder: (context) {
              return MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(textScaler: const TextScaler.linear(1.1)),
                child: AlertDialog(
                  contentPadding: EdgeInsets.zero,
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Fixed header section
                      Container(
                        color: Colors.blue,
                        padding: const EdgeInsets.all(16.0),
                        child: const Row(
                          children: [
                            Icon(Icons.warning, color: Colors.white),
                            SizedBox(width: 8),
                            Text(
                              "Security Alert",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Scrollable section below the header
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Center(
                                  child: const Text(
                                    "Security Alert!",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  "Remote access apps installed on your device can be used to steal the app information.",
                                  style: TextStyle(fontSize: 16),
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  "Suspicious Apps on your device:",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                ListTile(
                                  leading: Image.asset(
                                    'assets/images/anydesk.png',
                                    height: 40,
                                  ),
                                  title: const Text("AnyDesk"),
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  "As per regulatory guidelines, the remote access application may be misused to steal your information.",
                                  style: TextStyle(fontSize: 14),
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  "To continue using your app, please uninstall these applications from your device:",
                                  style: TextStyle(fontSize: 14),
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  "1. Go to device settings\n2. Find these apps\n3. Tap on Uninstall",
                                  style: TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      child: const Text("EXIT"),
                      onPressed: () {
                        SystemNavigator.pop(); // This will close the app
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      );
    }
  }

  Future<void> ModuleParameter() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      ServerDetails serverDetails = ServerDetails();

      String empKid = prefs.getString('EmpKid') ?? '';
      String restUrl =
          '${AppCongifP.apiurllink}/${AppCongifP.applicationName}/ServiceData.aspx?callFor=ModuleList';

      debugPrint('URL: ${restUrl.replaceAll(' ', '')}');

      var uri = Uri.parse(restUrl.replaceAll(' ', ''));
      var response = await http.get(uri);

      debugPrint('Response: ${response.statusCode}');

      if (response.statusCode == 200) {
        var content = response.body;
        //  Moduleparameter = (jsonDecode(content) as List)
        //      .map((i) => Parameter.fromJson(i))
        //      .toList();

        List<dynamic> modules = jsonDecode(content);

        // Iterate over the list to find the matching module
        for (var module in modules) {
          if (module['mnuModule_ename'] == 'EMPLOYEE MANAGEMENT') {
            // ignore: unused_local_variable
            String biometric = "BIOMATERIC ";
            break;
          }
        }
      }
    } catch (e) {
      print("Error: $e");
      setState(() {
        var isLoading = false;
      });
    }
  }

  Future<void> _checkBiometricAvailability() async {
    // Check if the device can perform biometric authentication
    bool canCheckBiometrics = await auth.canCheckBiometrics;
    isBiometricAvailable = canCheckBiometrics && await auth.isDeviceSupported();
    List<BiometricType> availableBiometrics =
        await auth.getAvailableBiometrics();

    if (isBiometricAvailable && availableBiometrics.isNotEmpty) {
      // Biometric is available and configured
      setState(() {
        _isBiometricAvailable = true;
      });

      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool? _isBiometricEnabled = prefs.getBool('isBiometricEnabled');

      if (_isBiometricEnabled == true) {
        _authenticate();
      }
    } else {
      // No biometric capabilities or not configured
      setState(() {
        _isBiometricAvailable = false;
        _isBiometricEnabled = false;
      });

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('isBiometricEnabled', false);

      // Show an alert dialog if biometric is not available
      showDialog(
        context: context,
        builder: (BuildContext context) => Builder(builder: (context) {
          return MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: const TextScaler.linear(1.1)),
            child: AlertDialog(
              title: const Text('Alert'),
              content: const Text('Biometric not registered on the device'),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        }),
      );
    }
  }

  Future<void> _authenticate() async {
    try {
      bool authenticated = await auth.authenticate(
          localizedReason: 'Please authenticate to log in',
          options: const AuthenticationOptions(biometricOnly: true));

      if (authenticated) {
        getLogin(context, EmployeeCode.text, password.text);
      } else {
        // If authentication was canceled, navigate to another page
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => exit(0)),
        );
      }
    } on PlatformException catch (e) {
      if (e.code == permanentlyLockedOut) {
        _handleLockout();
      } else {
        print(e);
      }
    }
  }

  void _handleLockout() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Builder(builder: (context) {
          return MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: const TextScaler.linear(1.1)),
            child: AlertDialog(
              title: const Text('Permanently Locked Out'),
              content: const Text(
                  'Biometric authentication has been disabled due to multiple failed attempts. '
                  'Please use your device PIN, password, or pattern to unlock biometrics.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    // Optional: Navigate to a screen where the user can enter their password/PIN
                    // For example, show a password entry screen
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => PasswordLoginScreen()));
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        });
      },
    );
  }

  void _startLockoutTimer() {
    Timer(const Duration(seconds: 30), () {
      // Enable biometric authentication again after 30 seconds
      _authenticate();
    });
  }

  Future<void> _checkLatency() async {
    await QuickAlert.show(
        context: context,
        type: QuickAlertType.warning,
        headerBackgroundColor: Colors.yellow,
        title: 'Biometric Authentication',
        text:
            ' If you want to continue using biometric authentication, click "Enabled." Otherwise, choose "Disabled"',
        confirmBtnText: 'Enabled',
        cancelBtnText: 'Disabled',
        onConfirmBtnTap: () async {
          Navigator.pop(context);
          //  _isBiometricEnabled=true;
          // getLogin(context, EmployeeCode.text, password.text);

          // Update the _isBiometricEnabled state and shared preferences
          SharedPreferences prefs = await SharedPreferences.getInstance();
          setState(() {
            _isBiometricEnabled = true;
          });
          prefs.setBool('isBiometricEnabled', true);

          // Call the authentication function
          // _authenticate();

          getLogin(context, EmployeeCode.text, password.text);
        },
        onCancelBtnTap: () async {
          Navigator.pop(context);
          SharedPreferences prefs = await SharedPreferences.getInstance();
          setState(() {
            _isBiometricEnabled = false;
          });
          prefs.setBool('isBiometricEnabled', false);

          // _authenticate();
          getLogin(context, EmployeeCode.text, password.text);
        },
        showCancelBtn: true,
        confirmBtnColor: Colors.green,
        barrierDismissible: false);
  }

  _loadCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      EmployeeCode.text = prefs.getString('employeeCode') ?? '';
      password.text = prefs.getString('password') ?? '';
      savePassword = prefs.getBool('savePassword') ?? false;
    });
  }

  _saveCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (savePassword) {
      await prefs.setString('employeeCode', EmployeeCode.text);
      await prefs.setString('password', password.text);
      await prefs.setBool('savePassword', savePassword);
    } else {
      await prefs.remove('employeeCode');
      await prefs.remove('password');
      await prefs.setBool('savePassword', savePassword);
    }
  }

  Future<void> _getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      // currentVersion = packageInfo.version;
      currentVersion = "13.20";
    });

    // Now get the Play Store version
    //  await _getPlayStoreVersion();
  }

  Future<void> _getPlayStoreVersion() async {
    const String packageName = 'com.nscspl.eHRNatural';
    final String playStoreUrl =
        'https://play.google.com/store/apps/details?id=$packageName';

    try {
      // Make an HTTP request to fetch the Play Store page HTML
      final response = await http.get(Uri.parse(playStoreUrl));

      if (response.statusCode == 200) {
        // Parse the HTML document
        var document = parser.parse(response.body);

        // Look for the app version in the metadata
        var versionElement = document.querySelector('span[class="htlgb"]');

        if (versionElement != null) {
          setState(() {
            playStoreVersion = versionElement.text.trim();
          });
          print("Play Store Version: $playStoreVersion");
        } else {
          throw 'App version not found';
        }
      } else {
        throw 'Failed to load the Play Store page';
      }

      _checkVersion();
    } catch (e) {
      print('Error fetching Play Store version: $e');
    }
  }

  // Fetch the latest version from Play Store (scraping the HTML page)
  // Future<void> _getPlayStoreVersion() async {
  //   const String packageName =
  //       'com.nscspl.eHRNatural'; // Replace with your app's package name
  //   const playStoreUrl =
  //       'https://play.google.com/store/apps/details?id=$packageName';

  //   try {
  //     // Make HTTP request to fetch the Play Store page HTML
  //     final response = await http.get(Uri.parse(playStoreUrl));

  //     if (response.statusCode == 200) {
  //       // Parse the HTML document
  //       var document = parser.parse(response.body);

  //       // Find the app version in the HTML meta tag
  //       var versionElement =
  //           document.querySelector('div[itemprop="softwareVersion"]');

  //       if (versionElement != null) {
  //         setState(() {
  //           playStoreVersion = versionElement.text.trim();
  //         });
  //       }
  //     } else {
  //       throw 'Failed to load the Play Store page';
  //     }

  //     _checkVersion();
  //   } catch (e) {
  //     print('Error fetching Play Store version: $e');
  //   }
  // }

  // Compare app version with Play Store version
  void _checkVersion() async {
    if (currentVersion != playStoreVersion) {
      await _showUpdateDialog();
    }
  }

  //Show dialog prompting the user to update the app
  _showUpdateDialog() async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Update Available'),
          content: const Text(
              'A new version of the app is available. Please update to the latest version.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _openPlayStore();
              },
              child: const Text('Update Now'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Later'),
            ),
          ],
        );
      },
    );
  }

  // Navigate to the Play Store to update the app
  void _openPlayStore() async {
    const String packageName =
        'com.nscspl.eHRNatural'; // Replace with your app's package name
    const String playStoreUrl =
        'https://play.google.com/store/apps/details?id=$packageName';

    if (await canLaunch(playStoreUrl)) {
      await launch(playStoreUrl);
    } else {
      throw 'Could not open Play Store';
    }
  }

  Future<void> getLogin(
      BuildContext context, String employeeCode, String password) async {
    final prefs = await SharedPreferences.getInstance();

    if (EmployeeCode == null) {
      showDialog(
        context: context,
        builder: (BuildContext context) => Builder(builder: (context) {
          return MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: const TextScaler.linear(1.1)),
            child: AlertDialog(
              title: const Text('Alert'),
              content: const Text('Please enter Employee Code'),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        }),
      );
      return;
    }

    if (password.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) => Builder(builder: (context) {
          return MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: const TextScaler.linear(1.1)),
            child: AlertDialog(
              title: const Text('Alert'),
              content: const Text('Please enter Password'),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        }),
      );
      return;
    }
    final List<ConnectivityResult> connectivityResult =
        await (Connectivity().checkConnectivity());
    if (connectivityResult.contains(ConnectivityResult.none)) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Builder(builder: (context) {
            return MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: const TextScaler.linear(1.1)),
              child: AlertDialog(
                title: const Text(
                  'Alert',
                  style: TextStyle(fontSize: 12),
                ),
                content: const Text(
                  'Please Check Your Internet Connection',
                  style: TextStyle(fontSize: 12),
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
    }

    //  await EasyLoading.show(status: 'Loading...');
    String username = employeeCode.trim();
    String base64Password = base64.encode(utf8.encode(password));
    // String encPassword = Crypt().generateMd5(password);
    //  String encryptedText = EncryptionHelper.encrypt(password, key);
    //String base64Password = EncryptionHelper().en(password);

    await prefs.setString('employeeCode', EmployeeCode.text);
    await prefs.setString('password', password);
    String jsonString = jsonEncode(UserInput(
            user: employeeCode,
            password: base64Password,
            DeviceId: uniqueID,
            VERSION: currentVersion)
        .toJson());

    Loader.show(context, progressIndicator: const CircularProgressIndicator());

    try {
      ServerDetails serverDetails = ServerDetails();

      //String? deviceId = await PlatformDeviceId.getDeviceId;
//---------------------------------------------------------------------------------------------------------------

      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

      String restUrl =
          "${AppCongifP.apiurllink}/${AppCongifP.applicationName}/ServiceData.aspx?callFor=userAuthenticate&user=$username&password=$base64Password&DeviceId=${androidInfo.id}$username&VERSION=$currentVersion";

//String restUrl = "https://dev.nscspl.in/ehrnatural/ServiceData.aspx?callFor=userAuthenticate&user=$username&password=$base64Password&DeviceId=${androidInfo.id}&VERSION=13.22";

      var uri = Uri.parse(restUrl.replaceAll(" ", ""));
      var response = await http.get(uri);

      if (response.statusCode == 200) {
        String content = response.body;
        // await EasyLoading.dismiss();

        if (content == "You are Unauthorise user..!") {
          showDialog(
            context: context,
            builder: (BuildContext context) => Builder(builder: (context) {
              return MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(textScaler: const TextScaler.linear(1.1)),
                child: AlertDialog(
                  title: const Text('Alert'),
                  content: const Text('You are Unauthorise user..!'),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('OK'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              );
            }),
          );
          Loader.hide();
          return;
        }

        List<String> responseParts = content.split(',');

        if (responseParts[0] == "success") {
          // await EasyLoading.dismiss();

          await prefs.setString('userID', username);
          await prefs.setString('success', responseParts[0]);
          await prefs.setString('userName', responseParts[1]);
          await prefs.setString('ManagerID', responseParts[3]);
          await prefs.setString('EmpKid', responseParts[4]);
          await prefs.setString('acckId', responseParts[2]);

          await onGetList(context);
        } else if (content == "failure,") {
          //  await EasyLoading.dismiss();

          showDialog(
            context: context,
            builder: (BuildContext context) => Builder(builder: (context) {
              return MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(textScaler: const TextScaler.linear(1.1)),
                child: AlertDialog(
                  title: const Text('Alert'),
                  content: const Text('You are Unauthorise user..!'),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('OK'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              );
            }),
          );
          Loader.hide();
          return;
        } else {
          //  await EasyLoading.dismiss();

          showDialog(
            context: context,
            builder: (BuildContext context) => Builder(builder: (context) {
              return MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(textScaler: const TextScaler.linear(1.1)),
                child: AlertDialog(
                  title: const Text('Alert'),
                  content: Text(content),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('OK'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              );
            }),
          );
          Loader.hide();
          return;
        }
      }
    } catch (e) {
      print("ERROR: $e");
    } finally {
      Loader.hide();
    }
  }

  Future<void> onGetList(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      ServerDetails serverDetails = ServerDetails();

      String userId = prefs.getString("userID") ?? '';

      String restUrl =
          "${AppCongifP.apiurllink}/${AppCongifP.applicationName}/servicedata.aspx?callFor=Profile&empcode=$userId";
      var response = await http.get(Uri.parse(restUrl));

      if (response.statusCode == 200) {
        var content = response.body;
        var td = (jsonDecode(content) as List)
            .map((i) => ProfileData.fromJson(i))
            .toList();

        ProfileData profileData = td[0];

        prefs.setString("source",
            profileData.EmpPhoto.isNotEmpty ? profileData.EmpPhoto : "");
        prefs.setString("name", profileData.EmpName);
        prefs.setString("mngr", profileData.Manager);
        prefs.setString("empnum", profileData.empjoin_empno);
        prefs.setString("bldgrp", profileData.empjoin_bldgrp);
        prefs.setString("dsg_ename", profileData.dsg_ename);
        prefs.setString("dept_ename", profileData.dept_ename);
        prefs.setString("Joiningdate", profileData.Doj);
        prefs.setString("Posting", profileData.Postingoffice);
        prefs.setString("BANKACCOUNT", profileData.BANKACCOUNT);
        prefs.setString("IFSC", profileData.IFSC);
        prefs.setString("PRANNO", profileData.PRANNO);
        prefs.setString("GPFNO", profileData.GPFNO);
        prefs.setString("CategoryName", profileData.CategoryName);
        prefs.setString("Grade", profileData.Grade);
        prefs.setString("Cadre", profileData.Cadre);
      }

      Navigator.pop(context); // Assuming you are closing a loading popup

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Dashboard()),
      );
//------------------------------------------------------------------------------------------------------------------
      await prefs.reload();
    } catch (e) {
      print("Error: $e");
    }
  }
}

class Parameter {
  final String modulename;
  final String moduleonmobile;

  Parameter({
    required this.modulename,
    required this.moduleonmobile,
  });

  factory Parameter.fromJson(Map<String, dynamic> json) {
    return Parameter(
        modulename: json["mnuModule_ename"],
        moduleonmobile: json['mnuModule_ActiveOnMobile']);
  }
}
