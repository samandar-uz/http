import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Userlist extends StatefulWidget {
  const Userlist({super.key});

  @override
  State<Userlist> createState() => _UserlistState();
}

class _UserlistState extends State<Userlist> {
  @override
  void initState() {
    getUsers();
    super.initState();
  }

  final TextEditingController controller = TextEditingController();
  final TextEditingController image_controller = TextEditingController();
  List users = [];
  Future<void> getUsers() async {
    final url = Uri.parse("https://6aca02073115bcc958205031.mockapi.io/users");
    final response = await http.get(url);
    final data = jsonDecode(response.body);
    setState(() {
      controller.clear();
      image_controller.clear();
      users = data;
    });
  }

  Future<void> addUsers(String name, String logo) async {
    final url = Uri.parse("https://6aca02073115bcc958205031.mockapi.io/users");
    if (name.isNotEmpty) {
      await http.post(
        url,
        headers: {'Content-type': 'application/json'},
        body: jsonEncode({'name': name, 'logo': logo}),
      );
    }

    await getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Column(
              children: [
                TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: "Ism kiriting",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: image_controller,
                  decoration: InputDecoration(
                    hintText: "Rasm havollasini kiriting",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Container(
              height: 50,
              width: double.infinity,

              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                onPressed: () {
                  addUsers(
                    controller.text.trim(),
                    image_controller.text.trim(),
                  );
                },

                child: Text(
                  "Qo'shish",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Container(
                        height: 50,
                        width: double.infinity,

                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            SizedBox(width: 10),
                            Container(
                              height: 40,
                              width: 40,
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Image.network(
                                users[index]['logo'],
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(width: 20),
                            Text(
                              users[index]['name'],
                              style: TextStyle(fontSize: 25),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
