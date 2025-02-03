class CREDITSVAEDATA {
  String? CREDITCARDNUMBER;
  String? BANKNAME;
  String? BillerID;
  String? CustomerName;
  String? CutomerMobileNumber;

  CREDITSVAEDATA({
    this.CREDITCARDNUMBER,
    this.BANKNAME,
    this.BillerID,
    this.CustomerName,
    this.CutomerMobileNumber,
  });

  // Factory constructor to create an instance from JSON
  factory CREDITSVAEDATA.fromJson(Map<String, dynamic> json) {
    return CREDITSVAEDATA(
      CREDITCARDNUMBER: json['crdrd_crdno'],
      BANKNAME: json['crdr_bnkname'],
      BillerID: json['crdr_billerid'],
      CustomerName: json['crdrd_name'],
      CutomerMobileNumber: json['crdrd_mobile'],
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'CREDITCARDNUMBER': CREDITCARDNUMBER,
      'BANKNAME': BANKNAME,
      'BillerID': BillerID,
      'CustomerName': CustomerName,
      'CutomerMobileNumber': CutomerMobileNumber,
    };
  }
}
