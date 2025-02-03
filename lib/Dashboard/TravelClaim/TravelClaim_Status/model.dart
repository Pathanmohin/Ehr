import 'dart:convert';

class JourneyData {
  final int kid;
  final String depDate;
  final String depTime;
  final String depPlace;
  final String arrDate;
  final String arrPlace;
  final String trvMode;
  final double farePaid;
  final double distance;
  final int days;
  final String hrs;
  final String purVisit;
  final String reqDate;
  final String arrTime;
  final String remarks;

  JourneyData({
    required this.kid,
    required this.depDate,
    required this.depTime,
    required this.depPlace,
    required this.arrDate,
    required this.arrPlace,
    required this.trvMode,
    required this.farePaid,
    required this.distance,
    required this.days,
    required this.hrs,
    required this.purVisit,
    required this.reqDate,
    required this.arrTime,
    required this.remarks,
  });

  factory JourneyData.fromJson(Map<String, dynamic> json) {
    return JourneyData(
      kid: json['Kid'],
      depDate: json['DepDate'],
      depTime: json['DepTime'],
      depPlace: json['DepPlace'],
      arrDate: json['ArrDate'],
      arrPlace: json['Arrplace'],
      trvMode: json['TrvMode'],
      farePaid: json['FarePaid'],
      distance: json['Distance'],
      days: json['Days'],
      hrs: json['Hrs'],
      purVisit: json['PurVisit'],
      reqDate: json['ReqDate'],
      arrTime: json['ArrTime'],
      remarks: json['Remarks'].toString(),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'Kid': kid,
      'DepDate': depDate,
      'DepTime': depPlace,
      'DepPlace': depPlace,
      'ArrDate': arrDate,
      'Arrplace': arrPlace,
      'ArrTime': arrTime,
      'TrvMode': trvMode,
      'FarePaid': farePaid,
      'Distance': distance,
      'Days': days,
      'Hrs': hrs,
      'PurVisit': purVisit,
      'ReqDate': reqDate,
      'Remarks': remarks,
    };
  }
}

class BoardingData {
  int kid;
  String from;
  String to;
  String hotelName;
  String dailyRate;
  String TotAmt;
  String FoodBillAmt;
  String HotelType;

  BoardingData({
    required this.kid,
    required this.from,
    required this.to,
    required this.hotelName,
    required this.dailyRate,
    required this.TotAmt,
    required this.HotelType,
    required this.FoodBillAmt,
  });

  factory BoardingData.fromJson(Map<String, dynamic> json) {
    return BoardingData(
      kid: json['Kid'],
      from: json['From'],
      to: json['To'],
      hotelName: json['HotelName'],
      dailyRate: json['DailyRate'].toString(),
      TotAmt: json['TotAmt'].toString(),
      HotelType: json['HotelType'].toString(),
      FoodBillAmt: json['FoodBillAmt'].toString(),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'Kid': kid,
      'From': from,
      'To': to,
      'HotelName': hotelName,
      'DailyRate': dailyRate,
      'TotAmt': TotAmt,
      'HotelType': HotelType,
      'FoodBillAmt': FoodBillAmt,
    };
  }
}

class otherExpence {
  int kid;
  String FromDate;
  String ToDate;
  String Remark;
  String TotAmt;

  otherExpence({
    required this.kid,
    required this.FromDate,
    required this.ToDate,
    required this.Remark,
    required this.TotAmt,
  });

  factory otherExpence.fromJson(Map<String, dynamic> json) {
    return otherExpence(
      kid: json['Kid'],
      FromDate: json['FromDate'].toString(),
      ToDate: json['ToDate'].toString(),
      Remark: json['Remark'].toString(),
      TotAmt: json['TotAmt'].toString(),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'Kid': kid,
      'FromDate': FromDate,
      'ToDate': ToDate,
      'Remark': Remark,
      'TotAmt': TotAmt,
    };
  }
}

class LocalConveyence {
  int kid;
  String LocalFrom;
  String LocalTo;
  String TrvMode;
  String LocalExp;
  String LocalTotal;

  LocalConveyence({
    required this.kid,
    required this.LocalFrom,
    required this.LocalTo,
    required this.TrvMode,
    required this.LocalExp,
    required this.LocalTotal,
  });

  factory LocalConveyence.fromJson(Map<String, dynamic> json) {
    return LocalConveyence(
      kid: json['Kid'],
      LocalFrom: json['LocalFrom'].toString(),
      LocalTo: json['LocalTo'].toString(),
      TrvMode: json['TrvMode'].toString(),
      LocalExp: json['LocalExp'].toString(),
      LocalTotal: json['LocalTotal'].toString(),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'Kid': kid,
      'LocalFrom': LocalFrom,
      'LocalTo': LocalTo,
      'TrvMode': TrvMode,
      'LocalExp': LocalExp,
      'LocalTotal': LocalTotal,
    };
  }
}

class ACTIONDATA {
  int ApprovalLevelAction_Kid;
  String ID;
  String Flag;
  String Name;

  ACTIONDATA({
    required this.ApprovalLevelAction_Kid,
    required this.ID,
    required this.Flag,
    required this.Name,
  });

  factory ACTIONDATA.fromJson(Map<String, dynamic> json) {
    return ACTIONDATA(
      ApprovalLevelAction_Kid: json['ApprovalLevelAction_Kid'],
      ID: json['ID'].toString(),
      Flag: json['Flag'].toString(),
      Name: json['Name'].toString(),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'ApprovalLevelAction_Kid': ApprovalLevelAction_Kid,
      'Flag': Flag,
      'ID': ID,
      'Name': Name,
    };
  }
}

class Summary {
  String JourneyAmt;
  String BoardAmt;
  String OthAmt;
  String HigherAmt;
  String DaAmt;
  String Remark;
  String TotAmt;
  String AdvAmt;
  String LocalConAmt;
  String TrainConnectDataDeduct;
  String OtherDeduct;
  String ClaimParaID;
  String AdvanceID;
  String Empid;
  String TrvId;
  String Currlvl;
  String ApprovalLevelID;

  Summary({
    required this.JourneyAmt,
    required this.BoardAmt,
    required this.OthAmt,
    required this.HigherAmt,
    required this.DaAmt,
    required this.Remark,
    required this.TotAmt,
    required this.AdvAmt,
    required this.LocalConAmt,
    required this.OtherDeduct,
    required this.TrainConnectDataDeduct,
    required this.ClaimParaID,
    required this.AdvanceID,
    required this.Empid,
    required this.TrvId,
    required this.Currlvl,
    required this.ApprovalLevelID,
  });

  factory Summary.fromJson(Map<String, dynamic> json) {
    return Summary(
      JourneyAmt: json['JourneyAmt'].toString(),
      BoardAmt: json['BoardAmt'].toString(),
      OthAmt: json['OthAmt'].toString(),
      HigherAmt: json['HigherAmt'].toString(),
      DaAmt: json['DaAmt'].toString(),
      Remark: json['Remark'].toString(),
      TotAmt: json['TotAmt'].toString(),
      AdvAmt: json['AdvAmt'].toString(),
      LocalConAmt: json['LocalConAmt'].toString(),
      OtherDeduct: json['OtherDeduct'].toString(),
      TrainConnectDataDeduct: json['TrainConnectDataDeduct'].toString(),
      ClaimParaID: json['ClaimParaID'].toString(),
      AdvanceID: json['AdvanceID'].toString(),
      Empid: json['Empid'].toString(),
      TrvId: json['TrvId'].toString(),
      Currlvl: json['Currlvl'].toString(),
      ApprovalLevelID: json['ApprovalLevelID'].toString(),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'Kid': JourneyAmt,
      'From': BoardAmt,
      'To': OthAmt,
      'HotelName': HigherAmt,
      'DailyRate': DaAmt,
      'HotelType': Remark,
      'TotAmt': TotAmt,
      'AdvAmt': AdvAmt,
      'FoodBillAmt': LocalConAmt,
      'OtherDeduct': OtherDeduct,
      'TrainConnectDataDeduct': TrainConnectDataDeduct,
      'ClaimParaID': ClaimParaID,
      'AdvanceID': AdvanceID,
      'Empid': Empid,
      'TrvId': TrvId,
      'Currlvl': Currlvl,
      'ApprovalLevelID': ApprovalLevelID
    };
  }
}
