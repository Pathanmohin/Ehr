import 'package:ehr/Dashboard/Dashboard.dart';
import 'package:ehr/app.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class Changepassword extends StatefulWidget {
  @override
  _ChangepasswordState createState() => _ChangepasswordState();
}

class _ChangepasswordState extends State<Changepassword> {
  final TextEditingController _empCodeController = TextEditingController();
  final TextEditingController _oldPassController = TextEditingController();
  final TextEditingController _newPassController = TextEditingController();
  final TextEditingController _RenewPassController = TextEditingController();

  bool _isEmpCodeVisible =
      false; // Set to true if you want to show the empCode field initially
  bool _isOldPassVisible = false;
  bool _isNewPassVisible = false;
  bool _isReNewPassVisible = false;
  bool _isUpperCase = false;
  bool _isLowerCase = false;
  bool _isNumeric = false;
  bool _hasSpecialChars = false;

  _showAlertDialog(String title, String message) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Builder(builder: (context) {
          return MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: const TextScaler.linear(1.1)),
            child: AlertDialog(
              title: Text(title),
              content: Text(message),
              actions: <Widget>[
                TextButton(
                  child: const Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
      },
    );
  }

  Future<void> _onProceedButtonPressed() async {
    try {
      if (_oldPassController.text.isEmpty) {
        _showAlertDialog("Alert", "Please enter Old Password");
        return;
      } else if (_newPassController.text.isEmpty) {
        _showAlertDialog("Alert", "Please enter New Password");
        return;
      }

      String password = _newPassController.text;
      String oldPassword = _oldPassController.text;
      String reenterpassword = _RenewPassController.text;

      _isUpperCase = RegExp(r'[A-Z]').hasMatch(password);
      _isLowerCase = RegExp(r'[a-z]').hasMatch(password);
      _isNumeric = RegExp(r'[0-9]').hasMatch(password);
      _hasSpecialChars = RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password);
      if (!_isUpperCase) {
        _showAlertDialog(
            "Alert", "Password should contain At least one upper case letter");
        return;
        //  return 'Password must contain at least one uppercase letter';
      } else if (!_isLowerCase) {
        _showAlertDialog("Alert",
            "Password should contain At least one lower case letter..!");
        return;
        //  return 'Password must contain at least one lowercase letter';
      } else if (!_isNumeric) {
        _showAlertDialog(
            "Alert", "Password should contain At least one numeric value");
        return;
        // return 'Password must contain at least one number';
      } else if (!_hasSpecialChars) {
        _showAlertDialog("Alert", "Add Sepcial character");
        return;
        // return 'Password must contain at least one special character';
      }

      // Convert to Base64
      password = base64Encode(utf8.encode(password));
      oldPassword = base64Encode(utf8.encode(oldPassword));
      reenterpassword = base64Encode(utf8.encode(reenterpassword));

      if (reenterpassword.isEmpty) {
        _showAlertDialog("Alert", "Please Enter Re-Enter Password");
        return;
      }
      if (password != reenterpassword) {
        _showAlertDialog(
            "Alert", "Re-Enter Password does not match to New Password");
        return;
      }

      // Define your server details
      SharedPreferences prefs = await SharedPreferences.getInstance();

      ServerDetails serverDetails = ServerDetails();

      String employeeId = prefs.getString('userID') ?? '';

      String restUrl =
          "${AppCongifP.apiurllink}/${AppCongifP.applicationName}/ServiceData.aspx?callFor=EmployeePassword&Empcode=$employeeId&Emppass=$password&Empoldpass=$oldPassword&mode=reset";

      print("URL: $restUrl");
      var uri = Uri.parse(restUrl.trim());
      var response = await http.get(uri);

      print("Response: $response");
      if (response.statusCode == 200) {
        String content = response.body;
        await _showAlertDialog("Alert", content);

        // Navigate to Dashboard
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Dashboard()));
      } else {
        _showAlertDialog("Alert", "Unable to Connect to the Server");
      }
    } catch (ex) {
      print("ERROR: ${ex.toString()}");
      _showAlertDialog("Alert", "Unable to Connect to the Server");
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Dashboard()));
        return false;
      },
      child: Builder(builder: (context) {
        return MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: const TextScaler.linear(1.1)),
          child: Scaffold(
            appBar: AppBar(
              title: const Text(
                "Change Password",
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: "TimesNewRoman",
                  fontSize: 18,
                ),
              ),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                color: Colors.white,
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Dashboard()));
                },
              ),
              backgroundColor: Colors.blue,
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    const SizedBox(height: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text(
                          "Enter Old Password",
                          style: TextStyle(
                            fontFamily: "TimesNewRoman",
                            color: Color(0xFF547EC8),
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextField(
                          controller: _oldPassController,
                          obscureText: !_isOldPassVisible,
                          decoration: InputDecoration(
                            hintText: "Please Enter Old Password",
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isOldPassVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isOldPassVisible = !_isOldPassVisible;
                                });
                              },
                            ),
                          ),
                          style: const TextStyle(
                            fontFamily: "TimesNewRoman",
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text(
                          "Enter New Password",
                          style: TextStyle(
                            fontFamily: "TimesNewRoman",
                            color: Color(0xFF547EC8),
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextField(
                          controller: _newPassController,
                          obscureText: !_isNewPassVisible,
                          decoration: InputDecoration(
                            hintText: "Please Enter New Password",
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isNewPassVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isNewPassVisible = !_isNewPassVisible;
                                });
                              },
                            ),
                          ),
                          style: const TextStyle(
                            fontFamily: "TimesNewRoman",
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text(
                          "Re-Enter New Password",
                          style: TextStyle(
                            fontFamily: "TimesNewRoman",
                            color: Color(0xFF547EC8),
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextField(
                          controller: _RenewPassController,
                          obscureText: !_isReNewPassVisible,
                          decoration: InputDecoration(
                            hintText: "Please Re-Enter New Password",
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isReNewPassVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isReNewPassVisible = !_isReNewPassVisible;
                                });
                              },
                            ),
                          ),
                          style: const TextStyle(
                            fontFamily: "TimesNewRoman",
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: _onProceedButtonPressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 32),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      child: const Text(
                        'Proceed',
                        style: TextStyle(
                          fontFamily: "TimesNewRoman",
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Guidelines to change password:",
                          style: TextStyle(
                              fontFamily: "TimesNewRoman",
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "1. Minimum Password Length: 4 Characters",
                          style: TextStyle(fontFamily: "TimesNewRoman"),
                        ),
                        Text(
                          "2. Maximum Password Length: 10 Characters",
                          style: TextStyle(fontFamily: "TimesNewRoman"),
                        ),
                        Text(
                          "3. Password should contain all the following four character groups",
                          style: TextStyle(fontFamily: "TimesNewRoman"),
                        ),
                        Text(
                          " a. Uppercase letters ( A-Z )",
                          style: TextStyle(fontFamily: "TimesNewRoman"),
                        ),
                        Text(
                          " b. Lowercase letters ( a-z )",
                          style: TextStyle(fontFamily: "TimesNewRoman"),
                        ),
                        Text(
                          " c. Numbers ( 0-9 )",
                          style: TextStyle(fontFamily: "TimesNewRoman"),
                        ),
                        Text(
                          " d. Special Characters (!@#\$%^&*)",
                          style: TextStyle(fontFamily: "TimesNewRoman"),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
