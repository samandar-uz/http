import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AiHome extends StatefulWidget {
  const AiHome({super.key});

  @override
  State<AiHome> createState() => _AiHomeState();
}

class _AiHomeState extends State<AiHome> {
  TextEditingController editingController = TextEditingController();
  String result = "";
  bool isLoading = false;
  //
  // Future<void> createImage(String text) async {
  //   setState(() {
  //     isLoading = true;
  //   });
  //   final url = Uri.parse("https://prexzyapis.com/ai/genimage?prompt=$text");
  //
  //   final response = await http.get(url);
  //   final data = jsonDecode(response.body);
  //
  //   setState(() {
  //     isLoading = false;
  //     result = data['image_url'];
  //   });
  // }

  Future<void> ai(String text) async {
    setState(() {
      isLoading = true;
    });

    final url = Uri.parse("https://prexzyapis.com/ai/charart?prompt=$text");
    final response = await http.get(url);
    final data = jsonDecode(response.body);

    setState(() {
      result = data['response'];
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SafeArea(
          child: Column(
            children: [
              TextField(
                controller: editingController,
                decoration: InputDecoration(
                  hint: Text("Matn kirting"),

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 20),

              SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),

                  onPressed: () {
                    ai(editingController.text.trim());
                  },
                  child: Text(
                    isLoading ? "Yartilmoqda..." : "Yaratish",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 40),
              Text(
                result,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
