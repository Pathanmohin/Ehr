class UserInput {
  String user;
  String password;
  String DeviceId;
  String VERSION;

  UserInput({
    required this.user,
    required this.password,
    required this.DeviceId,
    required this.VERSION,
  });

  Map<String, dynamic> toJson() {
    return {
      'user': user,
      'password': password,
      'DeviceId': DeviceId,
      'VERSION': VERSION,
    };
  }
}
