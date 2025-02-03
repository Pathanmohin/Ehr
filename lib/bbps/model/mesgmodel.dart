class PendingMessage {
  final String nickName;
  final String accNo;
  final String kid;

  PendingMessage(
      {required this.nickName, required this.accNo, required this.kid});

  factory PendingMessage.fromJson(Map<String, dynamic> json) {
    return PendingMessage(
      nickName: json['nickName'],
      accNo: json['accNo'],
      kid: json['kid'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nickName': nickName,
      'accNo': accNo,
      'kid': kid,
    };
  }
}
