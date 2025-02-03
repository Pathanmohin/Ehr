class travelmodes {
  int? kid;
  String? value;
  String? text;

  List<travelmodes>? childModelsList;

  travelmodes({
    this.kid,
    this.value,
    this.text,
  });

  factory travelmodes.fromJson(Map<String, dynamic> json) {
    return travelmodes(
      kid: json['kid'],
      value: json['value'],
      text: json['text'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'kid': kid,
      'value': value,
      'text': text,
    };
  }
}
