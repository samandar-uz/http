import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_page.dart';

class Onbarding extends StatefulWidget {
  const Onbarding({super.key});

  @override
  State<Onbarding> createState() => _OnbardingState();
}

class _OnbardingState extends State<Onbarding> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 5,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
                alignment: Alignment.center,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Image.asset(
                    'assets/image_2026-09-26_21-05-41.png',
                    fit: BoxFit.cover,
                    width: MediaQuery.of(context).size.width * 0.75,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 10.0,
                ),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32),
                    image: const DecorationImage(
                      image: AssetImage('assets/mesh-698.png'),
                      fit: BoxFit.cover,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Text(
                                "Yana qarz\nbo'ldimi?",
                                style: GoogleFonts.anton(
                                  fontSize: 34,
                                  height: 1.1,
                                  color: Colors.white,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                shape: BoxShape.circle,
                              ),
                              child: Image.asset(
                                "assets/pngegg.png",
                                height: 45,
                                width: 45,
                              ),
                            ),
                          ],
                        ),

                        Text(
                          "Qarzlaringizni osongina boshqaring, kuzating va nazorat qiling.",
                          style: GoogleFonts.interTight(
                            fontSize: 15,
                            color: Colors.white.withValues(alpha: 0.9),
                            fontWeight: FontWeight.w500,
                            height: 1.4,
                          ),
                        ),

                        const SizedBox(height: 10),

                        SizedBox(
                          width: double.infinity,
                          child: CupertinoButton(
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            onPressed: () async {
                              final prefs =
                                  await SharedPreferences.getInstance();
                              await prefs.setBool('showHome', true);

                              if (context.mounted) {
                                Navigator.pushReplacement(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (context) => const HomePage(),
                                  ),
                                );
                              }
                            },
                            child: Text(
                              "Kirish",
                              style: GoogleFonts.interTight(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Colors.blueAccent.shade700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
