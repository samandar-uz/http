import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:https_project/login/user_home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController controller_1 = TextEditingController();
  TextEditingController controller_2 = TextEditingController();

  Future<void> userLogin(String login, String password) async {
    final url = Uri.parse("https://dummyjson.com/auth/login");
    if (password.isNotEmpty && login.isNotEmpty) {
      final response = await http.post(
        url,
        headers: {'Content-type': 'application/json'},
        body: jsonEncode({'username': login, 'password': password}),
      );

      print(response.body);
      final data = jsonDecode(response.body);
      if (data['accessToken'] == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Login yoki parol xato kirtildi"),
            backgroundColor: Colors.redAccent,
          ),
        );
      } else {
        final prefs = await SharedPreferences.getInstance();
        prefs.setString("token", data['accessToken']);
        prefs.setBool("showHome", true);

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => UserHome()),
          (router) => (false),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Column(
                children: [
                  TextField(
                    controller: controller_1,
                    decoration: InputDecoration(
                      hintText: "Login",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: controller_2,
                    decoration: InputDecoration(
                      hintText: "Parol",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              SizedBox(
                height: 50,
                width: double.infinity,

                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  onPressed: () {
                    userLogin(
                      controller_1.text.trim(),
                      controller_2.text.trim(),
                    );
                  },

                  child: Text(
                    "Kirish",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
