import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home/ai_home.dart';
import 'home_page.dart';
import 'login/login_page.dart';
import 'login/user_home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final bool showHome = prefs.getBool('showHome') ?? false;

  runApp(MyApp(showHome: showHome));
}

class MyApp extends StatelessWidget {
  final bool showHome;

  const MyApp({super.key, required this.showHome});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MIB Qarz Tekshirish',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: AiHome()
    );
  }
}
