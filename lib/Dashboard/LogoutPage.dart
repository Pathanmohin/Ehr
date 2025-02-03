import 'dart:convert';
import 'dart:typed_data';
import 'package:ehr/Dashboard/Dashboard.dart';
import 'package:ehr/Loginpage.dart';
import 'package:ehr/Model/profiledata.dart';
import 'package:ehr/app.dart';
import 'package:flutter/material.dart';
import 'package:profile_view/profile_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


class LogoutPage extends StatefulWidget {
  @override
  _LogoutPageState createState() => _LogoutPageState();
}

class _LogoutPageState extends State<LogoutPage> {
  late Future<ProfileData> futureProfileData;

  @override
  void initState() {
    super.initState();
    futureProfileData = fetchProfileData();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(onWillPop: () async {
              Navigator.push(context, MaterialPageRoute(builder: (context) => Dashboard()));
return false;      
    },
      child: Builder(
        builder: (context) {
          return MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.1)),
            child: Scaffold(
              appBar: AppBar(
                title: const Text(
                  "Profile Details",
                  style: TextStyle(color: Colors.white,fontFamily: "TimesNewRoman", fontSize: 18),
                ),
                leading: IconButton(
                  
                  icon: const Icon(Icons.arrow_back),
                  color: Colors.white,
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Dashboard()));
                  },
                ),
                backgroundColor: Colors.blue,
              ),
              body: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          FutureBuilder<ProfileData>(
                            future: futureProfileData,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const Center(child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return Center(child: Text('Error: ${snapshot.error}'));
                              } else if (!snapshot.hasData) {
                                return const Center(child: Text('No profile data found'));
                              } else {
                                ProfileData profileData = snapshot.data!;
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                         _buildProfileImage(profileData.EmpPhoto,(){}),
                                        const SizedBox(height: 16),
                                        buildDetailRow('Name', profileData.EmpName),
                                        buildDivider(),
                                        buildDetailRow('Reporting Authority', profileData.Manager),
                                        buildDivider(),
                                        buildDetailRow('Employee Code', profileData.empjoin_empno),
                                        buildDivider(),
                                        buildDetailRow('Blood Group', profileData.empjoin_bldgrp),
                                        buildDivider(),
                                        buildDetailRow('Designation', profileData.dsg_ename),
                                        buildDivider(),
                                        buildDetailRow('Department', profileData.dept_ename),
                                        buildDivider(),
                                        buildDetailRow('Date Of Joining', profileData.Doj),
                                        buildDivider(),
                                        buildDetailRow('Present Posting', profileData.Postingoffice),
                                        buildDivider(),
                                        buildDetailRow('Grade', profileData.Grade),
                                        buildDivider(),
                                        buildDetailRow('Cadre', profileData.Cadre),
                                        buildDivider(),
                                      ],
                                    ),
                                  ),
                                );
                              }
                            },
                            
                          ),
                          // InkWell(
                          //       onTap: () async {
                          //         Navigator.push(context, MaterialPageRoute(builder: (context)=>const Login()));
                          //         return;
                          //       },
                          //       child: Padding(
                          //         padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          //         child: Container(
                          //           height: 55,
                          //           decoration: BoxDecoration(
                          //             color: Colors.blue,
                          //             borderRadius: BorderRadius.circular(10),
                          //           ),
                          //           child: const Center(
                          //             child: Text(
                          //               "LOGOUT",
                          //               style: TextStyle( fontFamily:"TimesNewRoman",
                          //                   color: Colors.white,
                          //                   fontSize: 18,
                          //                   fontWeight: FontWeight.bold),
                          //             ),
                          //           ),
                          //         ),
                          //       ),
                          //     ),
                              
                        ],
                      ),
                    ),
                  ),
                   InkWell(
                                onTap: () async {
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>const Login()));
                                  return;
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                  child: Container(
                                    height: 55,
                                    decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        "LOGOUT",
                                        style: TextStyle( fontFamily:"TimesNewRoman",
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 20,)
                              
                ],
              ),
               
            ),
          );
        }
      ),
    );
  }

  Widget buildDetailRow(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'TimesNewRoman',
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Color(0xFF547EC8),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'TimesNewRoman',
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget buildDivider() {
    return const Divider(
      color: Colors.black,
      thickness: 1,
    );
  }

  Future<ProfileData> fetchProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

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

      prefs.setString("source", profileData.EmpPhoto.isNotEmpty ? profileData.EmpPhoto : "");
      
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

      return profileData;
    } else {
      throw Exception('Failed to load profile data');
    }
  }



  Widget _buildProfileImage(String base64Image, VoidCallback onTap) {
  return Center(
    child: GestureDetector(
      onTap: onTap,
      child: ProfileView(
        image: base64Image.isNotEmpty
            ? MemoryImage(base64Decode(base64Image)) // Decode base64 image
            : const AssetImage('assets/images/profileuser.png'),
        height: 100, // Adjust height
        width: 100,  // Adjust width
        circle: true, // Circular profile view
        borderRadius: 0.0, // Ignored when `circle` is true
      ),
    ),
  );
}


 

}
