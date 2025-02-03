import 'dart:core';

class ServerDetails {
  // Future<String> getVersion() async {
  //   String versionName = "13";
  //   
  // }

  // static String serverIP = "dev.nscspl.in";
  //String serverIP="111.118.176.79";
  // String serverIP = "ohrms.odishamining.in";
  static String serverIP = "192.168.1.113";
  // static String serverIP = "103.54.13.163";
  //static String serverIP = "ehr-mch.assam.gov.in";

  // static String protocol = "https://";
  static String protocol = "http://";

  static String port = "";
  // static String port = ":8443";

    String getPortBBPS() {
    String BBPSPort = ":7086";
   // String port = ":7086";

    return BBPSPort;
  }

  static String BBPS = ":7086";
}

class AppCongifP {
  static final String _baseUrl =
      "${ServerDetails.protocol}${ServerDetails.serverIP}${ServerDetails.port}";

  //static String get applicationName => "ehrnatural";
  static String get applicationName => "Mobile";
  //static String get applicationName => "SQUARE_LIVE";
  //static String get applicationName => "HRMS";
  // static String get applicationName => "SKUASTK_UAT";
  // static String get applicationName => "SKUASTK";
  static String get apiurllink => _baseUrl;

  static final String _baseUrlBBPS = "${ServerDetails.protocol}${ServerDetails.serverIP}${ServerDetails.BBPS}";

  static String  get apiurllinkBBPS => _baseUrlBBPS;
}
