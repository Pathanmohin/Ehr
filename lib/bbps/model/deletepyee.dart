class Pending {
  final String nickName;
  final String accNo;
  final String kid;

  Pending({required this.nickName, required this.accNo, required this.kid});

  factory Pending.fromJson(Map<String, dynamic> json) {
    return Pending(
      nickName: json['payeeName'],
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
