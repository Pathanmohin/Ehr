class Employee {
  final String salutation;
  final String firstName;
  final String lastName;
  final String middleName;
  final String empJoinEmpNo;
  final String empJoinDob;
  final int age;
  final String mail;
  final String mobile;
  final String parentSpouseName;
  final String fatherName;
  final String motherName;
  final String spouseName;
  final String panCard;
  final String adharCard;
  final String gender;
  final String maritalStatus;
  final String religion;
  final String empJoinBldGrp;
  final String deptEname;
  final String dsgEname;
  final String manager;
  final String doj;
  final String postingOffice;
  final String bankAccount;
  final String ifsc;
  final String categoryName;
  final String grade;
  final String cadre;

  Employee({
    required this.salutation,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.empJoinEmpNo,
    required this.empJoinDob,
    required this.age,
    required this.mail,
    required this.mobile,
    required this.parentSpouseName,
    required this.fatherName,
    required this.motherName,
    required this.spouseName,
    required this.panCard,
    required this.adharCard,
    required this.gender,
    required this.maritalStatus,
    required this.religion,
    required this.empJoinBldGrp,
    required this.deptEname,
    required this.dsgEname,
    required this.manager,
    required this.doj,
    required this.postingOffice,
    required this.bankAccount,
    required this.ifsc,
    required this.categoryName,
    required this.grade,
    required this.cadre,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      salutation: json['Salutation'] ?? '',
      firstName: json['First Name'] ?? '',
      lastName: json['Last Name'] ?? '',
      middleName: json['Middle Name'] ?? '',
      empJoinEmpNo: json['empjoin_empno'] ?? '',
      empJoinDob: json['empjoin_dob'] ?? '',
      age: json['Age'] ?? 0,
      mail: json['Mail'] ?? '',
      mobile: json['Mobile'] ?? '',
      parentSpouseName: json['Parent/Spouse Name'] ?? '',
      fatherName: json['Father name'] ?? '',
      motherName: json['Mother name'] ?? '',
      spouseName: json['Husband/Wife Name'] ?? '',
      panCard: json['Pan Card'] ?? '',
      adharCard: json['Adhar Card'] ?? '',
      gender: json['Gender'] ?? '',
      maritalStatus: json['Marital Status'] ?? '',
      religion: json['Religion'] ?? '',
      empJoinBldGrp: json['empjoin_bldgrp'] ?? '',
      deptEname: json['dept_ename'] ?? '',
      dsgEname: json['dsg_ename'] ?? '',
      manager: json['Manager'] ?? '',
      doj: json['Doj'] ?? '',
      postingOffice: json['PostingOffice'] ?? '',
      bankAccount: json['BANKACCOUNT'] ?? '',
      ifsc: json['IFSC'] ?? '',
      categoryName: json['CategoryName'] ?? '',
      grade: json['Grade'] ?? '',
      cadre: json['Cadre'] ?? '',
    );
  }
}
