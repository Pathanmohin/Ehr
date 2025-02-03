import 'package:ehr/Dashboard/Dashboard.dart';
import 'package:ehr/Model/DirectoryData.dart';
import 'package:ehr/app.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';

import 'package:shared_preferences/shared_preferences.dart';

class DirectoryPage extends StatefulWidget {
  @override
  _DirectoryPageState createState() => _DirectoryPageState();
}

class _DirectoryPageState extends State<DirectoryPage> {
  TextEditingController searchController = TextEditingController();
  List<DirectoryData> directoryData = [];
  bool isLoading = false;

  Future<void> fetchData(String query) async {
    setState(() {
      isLoading = true;
    });

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      ServerDetails serverDetails = ServerDetails();

      String userId =
          prefs.getString("userID") ?? ''; // Replace with your actual user ID
      String restUrl =
          '${AppCongifP.apiurllink}/${AppCongifP.applicationName}/ServiceData.aspx?callFor=EmployeeSerach&Emp=$query';

      final response = await http.get(Uri.parse(restUrl));
      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
        List<DirectoryData> trends =
            jsonResponse.map((data) => DirectoryData.fromJson(data)).toList();

        for (var item in trends) {
          if (item.empPhoto.isNotEmpty) {
            Uint8List bytes = base64Decode(item.empPhoto);
            item.empPhotoTemp = 'data:image/png;base64,' + base64Encode(bytes);
          } else {
            item.empPhotoTemp =
                'assets/images/profileuser.png'; // Path to a local image asset
          }
        }

        setState(() {
          directoryData = trends;
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unable to connect to the server')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchDataa(String managerId) async {
    setState(() {
      isLoading = true;
    });

    try {
      ServerDetails serverDetails = ServerDetails();

      String restUrl =
          '${AppCongifP.apiurllink}/${AppCongifP.applicationName}/ServiceData.aspx?callFor=EmployeeSerach&Emp=$managerId';

      final response = await http.get(Uri.parse(restUrl));
      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
        List<DirectoryData> trends =
            jsonResponse.map((data) => DirectoryData.fromJson(data)).toList();

        for (var item in trends) {
          if (item.empPhoto.isNotEmpty) {
            Uint8List bytes = base64Decode(item.empPhoto);
            item.empPhotoTemp = 'data:image/png;base64,' + base64Encode(bytes);
          } else {
            item.empPhotoTemp =
                'assets/images/profileuser.png'; // Path to a local image asset
          }
        }

        setState(() {
          directoryData = trends;
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unable to connect to the server')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void handleTap(String managerCode) {
    String managerId = managerCode.split(')')[0].replaceAll('(', '').trim();
    fetchData(managerId);
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
                "Directory",
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: "TimesNewRoman",
                    fontSize: 18),
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
            body: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                children: [
                  SearchBar(
                    controller: searchController,
                    placeholder: 'Employee Code or Name',
                    onSearch: (query) {
                      fetchData(query);
                    },
                  ),
                  SizedBox(height: 10),
                  isLoading
                      ? CircularProgressIndicator()
                      : Expanded(
                          child: ListView.builder(
                            itemCount: directoryData.length,
                            itemBuilder: (context, index) {
                              return EmployeeCard(
                                data: directoryData[index],
                                onTap: handleTap,
                              );
                            },
                          ),
                        ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}

class SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final String placeholder;
  final Function(String) onSearch;

  SearchBar(
      {required this.controller,
      required this.placeholder,
      required this.onSearch});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: placeholder,
        hintStyle: TextStyle(
            color: Color(0xFF547EC8),
            fontSize: 12,
            fontStyle: FontStyle.italic),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        prefixIcon: Icon(Icons.search, color: Color(0xFF547EC8)),
      ),
      textAlign: TextAlign.center,
      style: TextStyle(color: Colors.black),
      onSubmitted: onSearch,
    );
  }
}

class EmployeeCard extends StatelessWidget {
  final DirectoryData data;
  final Function(String) onTap;

  EmployeeCard({required this.data, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap(data.mgr); // Pass the manager code to the onTap function
      },
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 5),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: Color(0xFFBD830A)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 45,
                  backgroundImage: data.empPhotoTemp.startsWith('data:image')
                      ? MemoryImage(
                          base64Decode(data.empPhotoTemp.split(',')[1]))
                      : AssetImage(data.empPhotoTemp) as ImageProvider,
                ),
              ),
              SizedBox(height: 10),
              InfoRow(label: 'Name', value: data.name),
              InfoRow(label: 'Department', value: data.dept),
              InfoRow(label: 'Designation', value: data.dsg),
              InfoRow(
                  label: 'Reporting Authority', value: data.mgr, isBold: true),
              InfoRow(label: 'Email', value: data.email),
              InfoRow(label: 'Mobile No', value: data.mobile),
              InfoRow(label: 'Emergency', value: data.empemergencyMobile),
              InfoRow(label: 'Address', value: data.address),
              InfoRow(label: 'Posting Office', value: data.posting),
            ],
          ),
        ),
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;

  InfoRow({required this.label, required this.value, this.isBold = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              color: Color(0xFF547EC8),
              fontSize: 15,
              fontFamily: 'TimesNewRoman',
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontFamily: 'TimesNewRoman',
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
