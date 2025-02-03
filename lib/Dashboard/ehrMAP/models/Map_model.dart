

class LocationData {
  final String userKid;
  final int locKid;
  final double locLatitude;
  final double locLongitude;
  final String locDateTime;

  LocationData({
    required this.userKid,
    required this.locKid,
    required this.locLatitude,
    required this.locLongitude,
    required this.locDateTime,
  });

  factory LocationData.fromJson(Map<String, dynamic> json) {
    return LocationData(
      userKid: json['userKid'],
      locKid: json['Loc_kid'],
      locLatitude: double.parse(json['Loc_latitude']),
      locLongitude: double.parse(json['loc_longitude']),
      locDateTime: json['Loc_dateandtime'],
    );
  }
}
