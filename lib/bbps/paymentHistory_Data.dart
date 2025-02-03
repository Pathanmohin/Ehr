class paymentDataH {
  String? ammount;
  String? dataee;
  String? paymentmode;
  String? taxnidd;
 

  paymentDataH({
    this.ammount,
    this.dataee,
    this.paymentmode,
    this.taxnidd,
   
  });

  // Factory constructor to create an instance from JSON
  factory paymentDataH.fromJson(Map<String, dynamic> json) {
    return paymentDataH(
      ammount: json['crdrd_crdno'],
      dataee: json['crdr_bnkname'],
      paymentmode: json['crdr_billerid'],
      taxnidd: json['crdrd_name'],
      
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'ammountt': ammount,
      'dateeeee': dataee,
      'paymentmodee': paymentmode,
      'taxnidd': taxnidd,
      
    };
  }
}
