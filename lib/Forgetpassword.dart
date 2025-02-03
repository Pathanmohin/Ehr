import 'dart:convert';
import 'package:ehr/Forgotpassword1.dart';
import 'package:ehr/Loginpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Forgetpassword extends StatefulWidget {
  @override
  _ForgetpasswordState createState() => _ForgetpasswordState();
}

class _ForgetpasswordState extends State<Forgetpassword> {


  final TextEditingController _empCodeController = TextEditingController();
  final TextEditingController _oldPassController = TextEditingController();
  final TextEditingController _newPassController = TextEditingController();
  final TextEditingController _RenewPassController = TextEditingController();
  TextEditingController _controller = TextEditingController();


 
   bool _isUpperCase = false;
    bool _isLowerCase = false;
    bool _isNumeric = false;
    bool _hasSpecialChars = false;

 @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final text = _controller.text.toUpperCase();
      if (_controller.text != text) {
        _controller.value = _controller.value.copyWith(
          text: text,
          selection: TextSelection.collapsed(offset: text.length),
        );
      }
    });
  }
   @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          title: const Text(
            "Forgot Password",
            style: TextStyle(color: Colors.white, fontFamily: "TimesNewRoman", fontSize: 18),
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
          child:
          
           Padding(
            padding: const EdgeInsets.all(16.0),
            
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              
              children: <Widget>[
                
                // Conditionally render the empCode field
                 Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: <Widget>[
    const Text(
      "eHR Registered E-mail Address",
      style: TextStyle(
        fontFamily: "TimesNewRoman",
        color: Color(0xFF547EC8),
        fontSize: 15,
        fontWeight: FontWeight.bold,
      ),
    ),
    Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        height: 55,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF475269).withOpacity(0.3),
              blurRadius: 5,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(Icons.email),
            const SizedBox(width: 10),
            Container(
              width: 250,
              child: TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'E-mail Address',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an email address';
                  }
                  String pattern =
                      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$';
                  RegExp regex = RegExp(pattern);
                  if (!regex.hasMatch(value)) {
                    return 'Enter a valid email address';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
      ),
    ),
  ],
),

                  
                const SizedBox(height: 10),
                const Divider(
      color: Colors.black,
      thickness: 2,
    ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      "eHR Registered Mobile Number",
                      style: TextStyle(
                        fontFamily: "TimesNewRoman",
                        color: Color(0xFF547EC8),
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                     Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 5),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                height: 55,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                          color: const Color(0xFF475269).withOpacity(0.3),
                          blurRadius: 5,
                          spreadRadius: 1),
                    ]),
                child: Row(
                  children: [
                    const Icon(Icons.phone),
                    const SizedBox(width: 10),
                    Container(
                      width: 250,
                      
                      child: TextFormField( inputFormatters: [LengthLimitingTextInputFormatter(10)],keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Mobile Number'),
                            
                      ),
                    )
                  ],
                ),
              ),
            ),
                  ],
                ),
                const SizedBox(height: 10),
                 const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "OR",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      "eHR Registered Last 4 digit of Aadhaar",
                      style: TextStyle(
                        fontFamily: "TimesNewRoman",
                        color: Color(0xFF547EC8),
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                   Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 5),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                height: 55,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                          color: const Color(0xFF475269).withOpacity(0.3),
                          blurRadius: 5,
                          spreadRadius: 1),
                    ]),
                child: Row(
                  children: [
                    const Icon(Icons.pan_tool),
                    const SizedBox(width: 10),
                    Container(
                      width: 250,
                      child: TextFormField(
                        inputFormatters: [LengthLimitingTextInputFormatter(6)],keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Last 4 digit of Aadhaar'), 
                      ),
                    )
                  ],
                ),
              ),
            ),
                  ],
                ),
            const SizedBox(height: 10),
             const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "OR",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.bold),
                    ),
                  ),


                 Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      "eHR Registered Last 6 digit of PAN card",
                      style: TextStyle(
                        fontFamily: "TimesNewRoman",
                        color: Color(0xFF547EC8),
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 5),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                height: 55,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                          color: const Color(0xFF475269).withOpacity(0.3),
                          blurRadius: 5,
                          spreadRadius: 1),
                    ]),
                child: Row(
                  children: [
                    const Icon(Icons.pan_tool),
                    const SizedBox(width: 10),
                    Container(
                      width: 250,
                     
                      child: TextFormField(
                        controller: _controller,
                        inputFormatters: [LengthLimitingTextInputFormatter(6), FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),],
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Last 6 digit of PAN card'), //beautifulpetal370
                      ),
                    )
                  ],
                ),
              ),
            ),
                  ],
                ),



                const SizedBox(height: 15),
 Row(
  children: [
    Expanded(
      child: ElevatedButton(
        onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context)=>Forgotpassword1()));},
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        child: const Text(
          'Reset Password',
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
        onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context)=>const Login()));},
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
)

              ],
            ),
          ),
        ),
    );}}