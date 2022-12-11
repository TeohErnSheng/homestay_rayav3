class User {
  String? name;
  String? email;
  String? passkey;
  User({required this.name, required this.email, required this.passkey});
  User.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    passkey = json['passkey'];
  }
}
