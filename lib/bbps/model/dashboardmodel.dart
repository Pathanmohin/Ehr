class SimpleObject {
  String? textValue;
  String? accountType;
  String? dataValue;
  String? customerName;
  String? actEname;
  String? availbalance;
  String? brancode;
  String? brnEname;
  String? headerTitle;
  String? actkid;

  List<SimpleObject>? childModelsList;

  SimpleObject({
    this.textValue,
    this.accountType,
    this.dataValue,
    this.customerName,
    this.actEname,
    this.availbalance,
    this.brancode,
    this.brnEname,
    this.headerTitle,
    this.actkid,
    this.childModelsList,
  });

  factory SimpleObject.fromJson(Map<String, dynamic> json) {
    return SimpleObject(
      textValue: json['textValue'],
      accountType: json['accountType'],
      dataValue: json['dataValue'],
      customerName: json['customerName'],
      actEname: json['actEname'],
      availbalance: json['availbalance'],
      brancode: json['brancode'],
      brnEname: json['brnEname'],
      headerTitle: json['headerTitle'],
      actkid: json['actkid'],
      childModelsList: json['childModelsList'] != null
          ? List<SimpleObject>.from(json['childModelsList']
              .map((item) => SimpleObject.fromJson(item)))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'textValue': textValue,
      'accountType': accountType,
      'dataValue': dataValue,
      'customerName': customerName,
      'actEname': actEname,
      'availbalance': availbalance,
      'brancode': brancode,
      'brnEname': brnEname,
      'headerTitle': headerTitle,
      'actkid': actkid,
      'childModelsList': childModelsList != null
          ? List<dynamic>.from(childModelsList!.map((item) => item.toJson()))
          : null,
    };
  }
}

class EVENTLIST {
  String? textValue;
  String? accountType;

  EVENTLIST({
    this.textValue,
    this.accountType,
  });

  factory EVENTLIST.fromJson(Map<String, dynamic> json) {
    return EVENTLIST(
      textValue: json['title'],
      accountType: json['filedata'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': textValue,
      'filedata': accountType,
    };
  }
}

class CREDIT {
  String? CreditcardNumber;
  String? Name;

  CREDIT({
    this.CreditcardNumber,
    this.Name,
  });

  factory CREDIT.fromJson(Map<String, dynamic> json) {
    return CREDIT(
      CreditcardNumber: json['crdrd_crdno'],
      Name: json['crdr_bnkname'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'CREDITCARDNUMBER': CreditcardNumber,
      'NAME': Name,
    };
  }
}

class Simple {
  final String countryId;
  final String label;
  final String accountNumber;
  final String mobileNumber;

  Simple({
    required this.countryId,
    required this.label,
    required this.accountNumber,
    required this.mobileNumber,
  });
}

class AccountListData {
  static String accListData = "";
}

class ParentChildModel {
  String? accountNo;
  String? acckid;
  String? availbalance;
  String? brancode;
  String? limit;
  String? limittext;
  String? brnEname;
  String? headerTitle;
  String? tittle;
  String? txtroi;
  String? comment;
  String? customerName;
  String? loanslabName;
  String? loanin;
  String? loanslabtype;
  String? roidtfrom;
  String? loanintrestrate;
  String? loanintrestrate1;
  String? loanintrestrate2;
  String? interestRate;
  String? underClgBalance;
  String? clourcode;
  String? checkstateus;
  String? address;
  String? interesttext;
  String? image;

  ParentChildModel({
    this.accountNo,
    this.acckid,
    this.availbalance,
    this.brancode,
    this.limit,
    this.limittext,
    this.brnEname,
    this.headerTitle,
    this.tittle,
    this.txtroi,
    this.comment,
    this.customerName,
    this.loanslabName,
    this.loanin,
    this.loanslabtype,
    this.roidtfrom,
    this.loanintrestrate,
    this.loanintrestrate1,
    this.loanintrestrate2,
    this.interestRate,
    this.underClgBalance,
    this.clourcode,
    this.checkstateus,
    this.address,
    this.interesttext,
    this.image,
  });

  factory ParentChildModel.fromJson(Map<String, dynamic> json) {
    return ParentChildModel(
      accountNo: json['AccountNo'],
      acckid: json['acckid'],
      availbalance: json['availbalance'],
      brancode: json['brancode'],
      limit: json['Limit'],
      limittext: json['Limittext'],
      brnEname: json['brnEname'],
      headerTitle: json['HeaderTitle'],
      tittle: json['tittle'],
      txtroi: json['txtroi'],
      comment: json['Comment'],
      customerName: json['customerName'],
      loanslabName: json['loanslabName'],
      loanin: json['loanin'],
      loanslabtype: json['loanslabtype'],
      roidtfrom: json['roidtfrom'],
      loanintrestrate: json['loanintrestrate'],
      loanintrestrate1: json['loanintrestrate1'],
      loanintrestrate2: json['loanintrestrate2'],
      interestRate: json['InterestRate'],
      underClgBalance: json['underClgBalance'],
      clourcode: json['clourcode'],
      checkstateus: json['checkstateus'],
      address: json['address'],
      interesttext: json['interesttext'],
      image: json['Image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'AccountNo': accountNo,
      'acckid': acckid,
      'availbalance': availbalance,
      'brancode': brancode,
      'Limit': limit,
      'Limittext': limittext,
      'brnEname': brnEname,
      'HeaderTitle': headerTitle,
      'tittle': tittle,
      'txtroi': txtroi,
      'Comment': comment,
      'customerName': customerName,
      'loanslabName': loanslabName,
      'loanin': loanin,
      'loanslabtype': loanslabtype,
      'roidtfrom': roidtfrom,
      'loanintrestrate': loanintrestrate,
      'loanintrestrate1': loanintrestrate1,
      'loanintrestrate2': loanintrestrate2,
      'InterestRate': interestRate,
      'underClgBalance': underClgBalance,
      'clourcode': clourcode,
      'checkstateus': checkstateus,
      'address': address,
      'interesttext': interesttext,
      'Image': image,
    };
  }
}
