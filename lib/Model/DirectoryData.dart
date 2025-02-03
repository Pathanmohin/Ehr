import 'dart:convert';

class DirectoryData {
  String name;
  String dept;
  String dsg;
  String mgr;
  String email;
  String mobile;
  String empemergencyMobile;
  String address;
  String posting;
  String empPhoto;
  String empPhotoTemp;

  DirectoryData({
    required this.name,
    required this.dept,
    required this.dsg,
    required this.mgr,
    required this.email,
    required this.mobile,
    required this.empemergencyMobile,
    required this.address,
    required this.posting,
    required this.empPhoto,
    required this.empPhotoTemp,
  });

  factory DirectoryData.fromJson(Map<String, dynamic> json) {
    return DirectoryData(
      name: json['Name'] ?? '',
      dept: json['Dept'] ?? '',
      dsg: json['dsg'] ?? '',
      mgr: json['MGR'] ?? '',
      email: json['Email'] ?? '',
      mobile: json['Mobile'] ?? '',
      empemergencyMobile: json['empemergencyMobile'] ?? '',
      address: json['Address'] ?? '',
      posting: json['Posting'] ?? '',
      empPhoto: json['EmpPhoto'] ?? '',
      empPhotoTemp: json['EmpPhotoTemp'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Name': name,
      'Dept': dept,
      'dsg': dsg,
      'MGR': mgr,
      'Email': email,
      'Mobile': mobile,
      'empemergencyMobile': empemergencyMobile,
      'Address': address,
      'Posting': posting,
      'EmpPhoto': empPhoto,
      'EmpPhotoTemp': empPhotoTemp,
    };
  }
}
