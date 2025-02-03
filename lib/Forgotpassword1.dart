
import 'package:ehr/Forgetpassword.dart';
import 'package:ehr/Loginpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Forgotpassword1 extends StatefulWidget {
  @override
  _Forgotpassword1State createState() => _Forgotpassword1State();
}

class _Forgotpassword1State extends State<Forgotpassword1> {


  final TextEditingController _newPassController = TextEditingController();
    final TextEditingController _RenewPassController = TextEditingController();

  
  bool _isNewPassVisible = false;
  bool _isReNewPassVisible = false;
   bool _isUpperCase = false;
    bool _isLowerCase = false;
    bool _isNumeric = false;
    bool _hasSpecialChars = false;

   @override
  Widget build(BuildContext context) {
    return   Scaffold(
        appBar: AppBar(
          title: const Text(
            "Forgot Password?",
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
              Navigator.push(context, MaterialPageRoute(builder: (context) => const Login()));
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
                            _isNewPassVisible ? Icons.visibility : Icons.visibility_off,
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
                            _isReNewPassVisible ? Icons.visibility : Icons.visibility_off,
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
                Row(
  children: [
    Expanded(
      child: ElevatedButton(
        onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context)=>const Login()));},
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          padding: const EdgeInsets.symmetric(vertical: 12),
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
    ),
    const SizedBox(width: 10),
    Expanded(
      child: ElevatedButton(
        onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context)=>Forgetpassword()));},
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        child: const Text(
          'Cancel',
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
               const Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text("Guidelines to change password:",style: TextStyle(fontFamily: "TimesNewRoman",fontWeight: FontWeight.bold),),
    Text("1. Minimum Password Length: 4 Characters",style: TextStyle(fontFamily: "TimesNewRoman"),),
    Text("2. Maximum Password Length: 10 Characters",style: TextStyle(fontFamily: "TimesNewRoman"),),
    Text("3. Password should contain all the following four character groups",style: TextStyle(fontFamily: "TimesNewRoman"),),
    Text(" a. Uppercase letters ( A-Z )",style: TextStyle(fontFamily: "TimesNewRoman"),),
    Text(" b. Lowercase letters ( a-z )",style: TextStyle(fontFamily: "TimesNewRoman"),),
    Text(" c. Numbers ( 0-9 )",style: TextStyle(fontFamily: "TimesNewRoman"),),
    Text(" d. Special Characters (!@#\$%^&*)",style: TextStyle(fontFamily: "TimesNewRoman"),),
  ],
)
              ],
            ),
          ),
        ),
      );}}