
class Rechargmobileee {
  String? biller_name;
  String? biller_id;

  List<Rechargmobileee>? childModelsList;

  Rechargmobileee({
    this.biller_name,
    this.biller_id,
  });

  factory Rechargmobileee.fromJson(Map<String, dynamic> json) {
    return Rechargmobileee(
      biller_name: json['biller_name'],
      biller_id: json['biller_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'biller_name': biller_name,
      'biller_id': biller_id,
    };
  }
}

class Statee {
  String? stat_kid;
  String? stat_ename;
  String? stat_code;

  List<Statee>? childModelsList;

  Statee({
    this.stat_kid,
    this.stat_ename,
    this.stat_code,
  });

  factory Statee.fromJson(Map<String, dynamic> json) {
    return Statee(
      stat_kid: json['stat_kid'],
      stat_ename: json['stat_ename'],
      stat_code: json['stat_code'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'stat_kid': stat_kid,
      'stat_ename': stat_ename,
      'biller_id': stat_code,
    };
  }
}
