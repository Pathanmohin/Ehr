import 'dart:convert';
import 'package:ehr/Loginpage.dart';
import 'package:ehr/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Forgotpassword extends StatefulWidget {
  @override
  _ForgotpasswordState createState() => _ForgotpasswordState();
}

class _ForgotpasswordState extends State<Forgotpassword> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController panCardController = TextEditingController();
  final TextEditingController aadharController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool isOtpVisible = false;
  bool isNewPasswordVisible = false;
  bool _showEnterOTP = false;
  bool _showEnterNewPassword = false;
  bool _showGuidelines = false;
  bool _isLoading = false;

  // Update with your base URL

  Future<void> onVerify() async {
    try {
      if (otpController.text.length < 4) {
        showError("Please Enter 4-Digit OTP");
        // await _showAlert(context, "Please Enter 4-Digit OTP");
        return;
      }
      setState(() {
        _isLoading = true;
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();

      ServerDetails serverDetails = ServerDetails();

      String kid = prefs.getString('empkid')!;

      // Replace with the actual value
      String otp = otpController.text;

      String restUrl =
          '${AppCongifP.apiurllink}/${AppCongifP.applicationName}/servicedata.aspx?callFor=OTPvalidate&empkid=$kid&OTP=$otp';
      final response = await http.get(Uri.parse(restUrl));

      if (response.statusCode == 200) {
        final content = response.body;

        if (content ==
            "OTP validation successful.You can proceed with the password reset.") {
          setState(() {
            isOtpVisible = false;
            isNewPasswordVisible = true;
            _showGuidelines = true;
          });
        } else {
          showError(content);
          otpController.text = "";
        }
      }
    } catch (error) {
      showError("Unable to connect to the server.");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> onSubmitResetPassword() async {
    try {
      final password = newPasswordController.text;
      final confirmPassword = confirmPasswordController.text;

      final RegExp hasNumber = RegExp(r'[0-9]+');
      final RegExp hasUpperChar = RegExp(r'[A-Z]+');
      final RegExp hasLowerChar = RegExp(r'[a-z]+');
      final RegExp hasSpecialChar = RegExp(r'[@!$#%\s]+');
      final RegExp hasMinMaxChars = RegExp(r'.{8,15}');
      if (password.isEmpty) {
        await _showAlert(context, "Please enter New Password");
        return;
      }

      if (password.length < 8) {
        await _showAlert(
            context, "Please enter password as per Change password policy!");
        return;
      }

      if (!hasLowerChar.hasMatch(password)) {
        await _showAlert(
            context, "Please enter password as per Change password policy!");
        return;
      }

      if (!hasUpperChar.hasMatch(password)) {
        await _showAlert(
            context, "Please enter password as per Change password policy!");
        return;
      }

      if (!hasNumber.hasMatch(password)) {
        await _showAlert(
            context, "Please enter password as per Change password policy!");
        return;
      }

      if (!hasSpecialChar.hasMatch(password)) {
        await _showAlert(
            context, "Please enter password as per Change password policy!");
        return;
      }

      if (confirmPasswordController.text.isEmpty) {
        await _showAlert(context, "Please enter Confirm Password");
        return;
      }

      if (password != confirmPassword) {
        await _showAlert(
            context, "Confirm Password does not match New Password");
        return;
      }

      SharedPreferences prefs = await SharedPreferences.getInstance();

      String kid = prefs.getString('empkid')!;

      // Replace with
      String encodedPassword = base64.encode(utf8.encode(password));

      String restUrl =
          '${AppCongifP.apiurllink}/${AppCongifP.applicationName}/ServiceData.aspx?callFor=reset&empkid=$kid&pswd=$encodedPassword';
      final response = await http.get(Uri.parse(restUrl));

      if (response.statusCode == 200) {
        final content = response.body;

        await _showAlertDialog("Alert", content);

        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const Login()));
        // showSuccess(content);
      }
    } catch (error) {
      showError("Unable to connect to the server.");
    }
  }

  Future<void> onProcessRequest() async {
    try {
      final email = emailController.text;
      final mobile = mobileController.text;
      final panCard = panCardController.text;
      final aadhar = aadharController.text;

      if (email.isEmpty) {
        showError("Please enter Email ID.");
        return;
      }

      if (email.isNotEmpty) {
        final emailPattern = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
        if (!emailPattern.hasMatch(email)) {
          showError("Please enter a valid Email ID.");
          return;
        }
      } else {
        await _showAlert(context, "An error occurred. Please try again.");
      }

      if (mobile.isEmpty && panCard.isEmpty && aadhar.isEmpty) {
        showError(
            "Please enter altest one of the following: Mobile Number, PAN Card or AADHAR Card.");
        return;
      }

      if (panCard.isNotEmpty) {
        final panCardPattern = RegExp(r'^\d{3}[a-zA-Z]$');
        if (!panCardPattern.hasMatch(panCard)) {
          showError("Please enter a valid PAN Card.");
          return;
        }
      }

      if (mobile.isNotEmpty) {
        final mobilePattern = RegExp(r'^\d{10}$');
        if (!mobilePattern.hasMatch(mobile)) {
          showError("Please enter a valid Mobile Number.");
          return;
        }
      }

      if (aadhar.isNotEmpty) {
        final aadharPattern = RegExp(r'^\d{4}$');
        if (!aadharPattern.hasMatch(aadhar)) {
          showError("Please enter a valid AADHAR Card.");
          return;
        }
      }

      String restUrl =
          '${AppCongifP.apiurllink}/${AppCongifP.applicationName}/ServiceData.aspx?callFor=Employeeresetpassword&mailId=$email&mobno=$mobile&panno=$panCard&adharno=$aadhar';
      final response = await http.get(Uri.parse(restUrl));

      if (response.statusCode == 200) {
        final content = response.body;

        if (content ==
                "WE ARE SORRY. WE WEREN'T ABLE TO IDENTIFY YOU GIVEN THE INFORMATION PROVIDED.~N" ||
            content ==
                "WE ARE SORRY. WE WEREN'T ABLE TO IDENTIFY YOU GIVEN THE INFORMATION PROVIDED.~Y") {
          await _showAlertDialog("Alert",
              "SORRY. WE WEREN'T ABLE TO IDENTIFY YOUR GIVEN INFORMATION.");
          return;
        } else if (content ==
                "WE ARE SORRY. YOUR MOBILE NUMBER IS NOT REGISTERED~N" ||
            content == "WE ARE SORRY. YOUR MOBILE NUMBER IS NOT REGISTERED~Y") {
          await _showAlertDialog(
              "Alert", "WE ARE SORRY. YOUR MOBILE NUMBER IS NOT REGISTERED");
          return;
        } else if (content == "PLEASE ENTER A VALID EMAIL.~Y" ||
            content == "PLEASE ENTER A VALID EMAIL.~N") {
          await _showAlertDialog("Alert", "PLEASE ENTER A VALID EMAIL.");
          emailController.clear();
          mobileController.clear();
          panCardController.clear();
          aadharController.clear();
          return;
        } else if (content == "PLEASE ENTER VALID MOBILE NO.~N" ||
            content == "PLEASE ENTER VALID MOBILE NO.~Y") {
          await _showAlertDialog("Alert", "PLEASE ENTER VALID MOBILE NO.");
          mobileController.clear();
          panCardController.clear();
          aadharController.clear();
          return;
        } else if (content == "PLEASE ENTER VALID PAN NO.~N" ||
            content == "PLEASE ENTER VALID PAN NO.~Y") {
          await _showAlertDialog("Alert", "PLEASE ENTER VALID PAN NO.");
          panCardController.clear();
          aadharController.clear();
          return;
        } else if (content == "PLEASE ENTER VALID AADHAAR NO.~N" ||
            content == "PLEASE ENTER VALID AADHAAR NO.~Y") {
          await _showAlertDialog("Alert", "PLEASE ENTER VALID AADHAR NO.");
          aadharController.clear();
          return;
        } else {
          final str = content.split('~');
          String mobilenumber = str[1];
          String emailid = str[2];
          String empKidd = str[0];
          String otppara = str[3];
          final prefs = await SharedPreferences.getInstance();
          prefs.setString('empkid', empKidd.toString());

          // Store data in local state (or SharedPreferences for persistence)

          if (otppara == "Y") {
            setState(() {
              isNewPasswordVisible = true;
              _showGuidelines = true;
              newPasswordController.text = "";
              confirmPasswordController.text = "";
            });
          } else {
            setState(() {
              isOtpVisible = true;
              isNewPasswordVisible = false;
              _showGuidelines = false;
              otpController.text = "";
            });

            // Additional logic to handle OTP bypass or timer can go here
          }
        }
      } else {
        await _showAlert(context, "An error occurred. Please try again.");
      }
    } catch (error) {
      showError("Unable to connect to the server.");
    }
  }

  _showAlertDialog(String title, String message) async {
    await showDialog(
      barrierDismissible: false,
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
                  onPressed: () => Navigator.pop(context),
                  child: const Text("OK"),
                ),
              ],
            ),
          );
        });
      },
    );
  }

  Future<void> _showAlert(BuildContext context, String message) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Alert"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  void showError(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.green))));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Forgot Password",
          style: TextStyle(
              color: Colors.white, fontFamily: "TimesNewRoman", fontSize: 18),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const Login()));
          },
        ),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildInputRow(
                icon: Icons.person,
                controller: emailController,
                placeholder: "Enter Email ID",
              ),
              _buildInputRowNum(
                icon: Icons.phone,
                controller: mobileController,
                placeholder: "Enter Mobile Number",
                inputType: TextInputType.phone,
                maxLength: 10,
              ),
              const Text(
                "OR",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF547EC8),
                ),
              ),
              _buildInputRow(
                icon: Icons.credit_card,
                controller: panCardController,
                placeholder: "Last 4 Digit of PAN Card",
                maxLength: 4,
              ),
              const Text(
                "OR",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF547EC8),
                ),
              ),
              _buildInputRowNum(
                icon: Icons.perm_identity,
                controller: aadharController,
                placeholder: "Last 4 Digit of AADHAR Card",
                inputType: TextInputType.number,
                maxLength: 4,
              ),
              ElevatedButton(
                onPressed: onProcessRequest,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                child: const Text(
                  "Reset Password",
                  style: TextStyle(
                    fontFamily: "TimesNewRoman",
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Visibility(
                visible: isOtpVisible,
                child: Column(
                  children: [
                    const Text(
                      "Registered Mobile Number or Email ID Receiving OTP",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF547EC8),
                      ),
                    ),
                    OTPFIELD(
                        icon: Icons.lock,
                        controller: otpController,
                        placeholder: "Please Enter OTP",
                        isPassword: true,
                        maxLength: 4),
                    SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: onVerify,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        child: const Text(
                          "Verify OTP",
                          style: TextStyle(
                            fontFamily: "TimesNewRoman",
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: isNewPasswordVisible,
                child: Column(
                  children: [
                    _buildInputRow(
                      icon: Icons.lock,
                      controller: newPasswordController,
                      placeholder: "New Password",
                      isPassword: true,
                    ),
                    _buildInputRow(
                      icon: Icons.lock,
                      controller: confirmPasswordController,
                      placeholder: "Confirm Password",
                      isPassword: true,
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: onSubmitResetPassword,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        child: const Text(
                          "Proceed",
                          style: TextStyle(
                            fontFamily: "TimesNewRoman",
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Visibility(
                visible: _showGuidelines,
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Guidelines to change password:",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF547EC8),
                      ),
                    ),
                    Text("1. Minimum Password Length – 8 Characters"),
                    Text(
                        "2. Password should contain all the following four character groups"),
                    Text("  a. Uppercase letters ( A-Z )"),
                    Text("  b. Lowercase letters ( a-z )"),
                    Text("  c. Numbers ( 0-9 )"),
                    Text("  d. Special Characters ('!', '\$', '#', '%', '@')"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputRow({
    required IconData icon,
    required TextEditingController controller,
    required String placeholder,
    TextInputType inputType = TextInputType.text,
    int? maxLength,
    bool isPassword = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(icon, size: 40, color: const Color(0xFFBD830A)),
            ),
          ),
          Expanded(
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: controller,
                  maxLength: maxLength,
                  obscureText: isPassword,
                  keyboardType: inputType,
                  decoration: InputDecoration(
                    hintText: placeholder,
                    hintStyle: const TextStyle(color: Color(0xFF547EC8)),
                    border: InputBorder.none,
                    counterText: '',
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget OTPFIELD({
    required IconData icon,
    required TextEditingController controller,
    required String placeholder,
    TextInputType inputType = TextInputType.number,
    int? maxLength,
    bool isPassword = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(icon, size: 40, color: const Color(0xFFBD830A)),
            ),
          ),
          Expanded(
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: controller,
                  maxLength: maxLength,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  obscureText: isPassword,
                  keyboardType: inputType,
                  decoration: InputDecoration(
                    hintText: placeholder,
                    hintStyle: const TextStyle(color: Color(0xFF547EC8)),
                    border: InputBorder.none,
                    counterText: '',
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputRowNum({
    required IconData icon,
    required TextEditingController controller,
    required String placeholder,
    TextInputType inputType = TextInputType.text,
    int? maxLength,
    bool isPassword = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(icon, size: 40, color: const Color(0xFFBD830A)),
            ),
          ),
          Expanded(
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: controller,
                  maxLength: maxLength,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(10),
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  obscureText: isPassword,
                  keyboardType: inputType,
                  decoration: InputDecoration(
                    hintText: placeholder,
                    hintStyle: const TextStyle(color: Color(0xFF547EC8)),
                    border: InputBorder.none,
                    counterText: '',
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
