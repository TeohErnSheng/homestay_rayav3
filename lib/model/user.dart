// ignore_for_file: public_member_api_docs, sort_constructors_first
class User {
  String? name;
  String? email;
  String? passkey;
  String? userId;
  User({
    this.name,
    this.email,
    this.passkey,
    this.userId,
  });
  User.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    name = json['name'];
    email = json['email'];
    passkey = json['passkey'];
  }
}
