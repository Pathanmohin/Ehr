class PendingMessage {
final String NotifiMobile_Msg;
final int NotifiMobile_kid;

PendingMessage({required this.NotifiMobile_Msg, required this.NotifiMobile_kid});

factory PendingMessage.fromJson(Map<String, dynamic> json) {
return PendingMessage(
NotifiMobile_Msg: json['NotifiMobile_Msg'],
NotifiMobile_kid: json['NotifiMobile_kid'],
);
}

Map<String, dynamic> toJson() {
return {
'NotifiMobile_Msg': NotifiMobile_Msg,
'NotifiMobile_kid': NotifiMobile_kid,
};
}
}