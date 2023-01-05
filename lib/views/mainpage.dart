import 'package:flutter/material.dart';

import 'login.dart';
import '../model/user.dart';

class MainPage extends StatelessWidget {
  final User user;
  const MainPage({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Main Page'),
          centerTitle: true,
        ),
        body: Center(
            child: Container(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
              const Text("Main Page"),
              MaterialButton(
                color: Colors.blue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
                minWidth: 115,
                height: 40,
                elevation: 10,
                onPressed: (() => {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  const LoginScreen()))
                    }),
                child: const Text('Logout'),
              )
            ]))));
  }
}
