import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProfileData {
  final String EmpPhoto;
  final String EmpName;
  final String Manager;
  final String empjoin_empno;
  final String empjoin_bldgrp;
  final String dsg_ename;
  final String dept_ename;
  final String Doj;
  final String Postingoffice;
  final String BANKACCOUNT;
  final String IFSC;
  final String PRANNO;
  final String GPFNO;
  final String CategoryName;
  final String Grade;
  final String Cadre;

  ProfileData({
    required this.EmpPhoto,
    required this.EmpName,
    required this.Manager,
    required this.empjoin_empno,
    required this.empjoin_bldgrp,
    required this.dsg_ename,
    required this.dept_ename,
    required this.Doj,
    required this.Postingoffice,
    required this.BANKACCOUNT,
    required this.IFSC,
    required this.PRANNO,
    required this.GPFNO,
    required this.CategoryName,
    required this.Grade,
    required this.Cadre,
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    return ProfileData(
      EmpPhoto: json['EmpPhoto'] ?? '',
      EmpName: json['EmpName'] ?? '',
      Manager: json['Manager'] ?? '',
      empjoin_empno: json['empjoin_empno'] ?? '',
      empjoin_bldgrp: json['empjoin_bldgrp'] ?? '',
      dsg_ename: json['dsg_ename'] ?? '',
      dept_ename: json['dept_ename'] ?? '',
      Doj: json['Doj'] ?? '',
      Postingoffice: json['Postingoffice'] ?? '',
      BANKACCOUNT: json['BANKACCOUNT'] ?? '',
      IFSC: json['IFSC'] ?? '',
      PRANNO: json['PRANNO'] ?? '',
      GPFNO: json['GPFNO'] ?? '',
      CategoryName: json['CategoryName'] ?? '',
      Grade: json['Grade'] ?? '',
      Cadre: json['Cadre'] ?? '',
    );
  }
}
