import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:homestay_raya/views/buyerscreen.dart';
import 'package:homestay_raya/views/login.dart';
import 'package:homestay_raya/model/serverconfig.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Homestay Raya",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue)),
          Image.asset(
            "assets/images/homestay.gif",
            fit: BoxFit.fill,
          ),
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
      http.post(
          Uri.parse("${ServerConfig.server}/homestay_raya/php/login_user.php"),
          body: {"email": email, "password": password}).then((response) {
        var jsonResponse = json.decode(response.body);
        if (response.statusCode == 200 && jsonResponse['status'] == "success") {
          User user = User.fromJson(jsonResponse['data']);
          Timer(
              const Duration(seconds: 3),
              () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (content) => BuyerPage(user: user))));
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
                      builder: (content) => BuyerPage(
                            user: user,
                          ))));
        }
      });
    } else {
      user = User(name: "na", email: "na", passkey: "na");
      Timer(
          const Duration(seconds: 3),
          () => Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (content) => BuyerPage(user: user))));
    }
  }
}
