import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:homestay_raya/views/login.dart';
import 'package:homestay_raya/model/config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'ownerpage.dart';
import '../model/user.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkAndLogin();
    Timer(
        const Duration(seconds: 3),
        () => Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (content) => const LoginScreen())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Center(
              child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
          ))
        ],
      ),
    ));
  }

  Future<void> checkAndLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = (prefs.getString('email')) ?? '';
    String password = (prefs.getString('passkey')) ?? '';
    late User user;
    if (email.isNotEmpty) {
      http.post(Uri.parse("${Config.server}/homestay_raya/php/login_user.php"),
          body: {"email": email, "password": password}).then((response) {
        var jsonResponse = json.decode(response.body);
        if (response.statusCode == 200 && jsonResponse['status'] == "success") {
          User user = User.fromJson(jsonResponse['data']);
          Timer(
              const Duration(seconds: 3),
              () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (content) => OwnerPage(user: user))));
        } else {
          user = User(
            name: "na",
            email: "na",
            passkey: "na",
          );
          Timer(
              const Duration(seconds: 3),
              () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (content) => const LoginScreen())));
        }
      });
    } else {
      user = User(name: "na", email: "na", passkey: "na");
      Timer(
          const Duration(seconds: 3),
          () => Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (content) => const LoginScreen())));
    }
  }
}
