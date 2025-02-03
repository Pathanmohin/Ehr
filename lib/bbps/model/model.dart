class LoginPar {
  String? authorise;
  String? userType;
  String? validUser;
  String? customerId;
  String? sessionId;
  String? custName;
  String? lastlogin;
  String? mobileNo;
  String? accountNo;
  String? custRoll;
  String? ifsc;
  String? branchCode;
  String? branchName;
  String? sibusrFor;
  String? tokenNo;
  String? ibUsrKid;
  String? brnemail;
  String? custemail;
  String? errorMsg;
  String? otp;
  String? responseCode;
  String? userid;
  String? secondusermob;
  String? branchIFSC;

  LoginPar(
      {this.authorise,
      this.userType,
      this.validUser,
      this.customerId,
      this.sessionId,
      this.custName,
      this.lastlogin,
      this.mobileNo,
      this.accountNo,
      this.custRoll,
      this.ifsc,
      this.branchCode,
      this.branchName,
      this.sibusrFor,
      this.tokenNo,
      this.ibUsrKid,
      this.brnemail,
      this.custemail,
      this.errorMsg,
      this.otp,
      this.responseCode,
      this.userid,
      this.secondusermob,
      this.branchIFSC});

  LoginPar.fromJson(Map<String, dynamic> json) {
    authorise = json['authorise'];
    userType = json['userType'];
    validUser = json['validUser'];
    customerId = json['customerId'];
    sessionId = json['sessionId'];
    custName = json['custName'];
    lastlogin = json['lastlogin'];
    mobileNo = json['mobileNo'];
    accountNo = json['accountNo'];
    custRoll = json['custRoll'];
    ifsc = json['ifsc'];
    branchCode = json['BranchCode'];
    branchName = json['branchName'];
    sibusrFor = json['sibusrFor'];
    tokenNo = json['tokenNo'];
    ibUsrKid = json['ibUsrKid'];
    brnemail = json['brnemail'];
    custemail = json['custemail'];
    errorMsg = json['errorMsg'];
    otp = json['Otp'];
    responseCode = json['responseCode'];
    userid = json['Userid'];
    secondusermob = json['secondusermob'];
    branchIFSC = json['branchIFSC'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['authorise'] = authorise;
    data['userType'] = userType;
    data['validUser'] = validUser;
    data['customerId'] = customerId;
    data['sessionId'] = sessionId;
    data['custName'] = custName;
    data['lastlogin'] = lastlogin;
    data['mobileNo'] = mobileNo;
    data['accountNo'] = accountNo;
    data['custRoll'] = custRoll;
    data['ifsc'] = ifsc;
    data['BranchCode'] = branchCode;
    data['branchName'] = branchName;
    data['sibusrFor'] = sibusrFor;
    data['tokenNo'] = tokenNo;
    data['ibUsrKid'] = ibUsrKid;
    data['brnemail'] = brnemail;
    data['custemail'] = custemail;
    data['errorMsg'] = errorMsg;
    data['Otp'] = otp;
    data['responseCode'] = responseCode;
    data['Userid'] = userid;
    data['secondusermob'] = secondusermob;
    data['branchIFSC'] = branchIFSC;
    return data;
  }
}

class Payee {
  String? nickName;
  String? mobileNo;
  String? accNo;
  String? ifsCode;
  String? payeeType;
  String? payeeName;
  String? accType;
  String? kid;

  Payee({
    this.nickName,
    this.mobileNo,
    this.accNo,
    this.ifsCode,
    this.payeeType,
    this.payeeName,
    this.accType,
    this.kid,
  });

  factory Payee.fromJson(Map<String, dynamic> json) {
    return Payee(
      nickName: json['nickName'],
      mobileNo: json['mobileNo'],
      accNo: json['accNo'],
      ifsCode: json['ifsCode'],
      payeeType: json['payeeType'],
      payeeName: json['payeeName'],
      accType: json['accType'],
      kid: json['kid'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nickName': nickName,
      'mobileNo': mobileNo,
      'accNo': accNo,
      'ifsCode': ifsCode,
      'payeeType': payeeType,
      'payeeName': payeeName,
      'accType': accType,
      'kid': kid,
    };
  }
}
