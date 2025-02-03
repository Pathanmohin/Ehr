

import 'package:ehr/bbps/model/dashboardmodel.dart';

class AppInfoLogin {
  static String lastLogin = "";
  static String cusName = "";
  static String accountNo = "";
  static String BranchCode = "";
  static String authorise = "";
  static String userType = "";
  static String validUser = "";
  static String customerId = "";
  static String sessionId = "";
  static String mobileNo = "";
  static String custRoll = "";
  static String branchName = "";
  static String sibusrFor = "";
  static String ifsc = "";
  static String tokenNo = "";
  static String ibUsrKid = "";
  static String brnemail = "";
  static String custemail = "";
  static String errorMsg = "";
  static String Otp = "";
  static String responseCode = "";
  static String Userid = "";
  static String secondusermob = "";
  static String branchIFSC = "";
}

class AppListData {
  static List<SimpleObject> FromAccounts = <SimpleObject>[];
  static List<SimpleObject> ToAccounts = <SimpleObject>[];
  static List<SimpleObject> AllAccounts = <SimpleObject>[];
  static List<SimpleObject> Allacc = <SimpleObject>[];

  static List<SimpleObject> Accloan = <SimpleObject>[];
  static List<SimpleObject> Sav = <SimpleObject>[];

  static List<SimpleObject> fd = <SimpleObject>[];
  static List<SimpleObject> rd = <SimpleObject>[];
  static List<SimpleObject> SavCA = <SimpleObject>[];
  static List<SimpleObject> SACACC = <SimpleObject>[];
  static List<SimpleObject> FDR = <SimpleObject>[];
  static List<SimpleObject> fdclose = <SimpleObject>[];
  static List<SimpleObject> Fundtransfertransfer = <SimpleObject>[];
  static List<SimpleObject> fromAccountList = <SimpleObject>[];
  static List<SimpleObject> fromAccount = <SimpleObject>[];
  static List<SimpleObject> listevnert = <SimpleObject>[];
}

class MyAccountList {
  static List<ParentChildModel> childModelsSavingListData =
      <ParentChildModel>[];
  static List<ParentChildModel> childModelsCurrentList = <ParentChildModel>[];
  static List<ParentChildModel> childModelsCCODList = <ParentChildModel>[];
  static List<ParentChildModel> childModelsFDList = <ParentChildModel>[];
  static List<ParentChildModel> childModelsRDList = <ParentChildModel>[];
  static List<ParentChildModel> childModelsLoanList = <ParentChildModel>[];
}

class LISTEVENT {
  static List<EVENTLIST> childModel = <EVENTLIST>[];
}

class CREDITCARD {
  static List<CREDIT> childModell = <CREDIT>[];
}


