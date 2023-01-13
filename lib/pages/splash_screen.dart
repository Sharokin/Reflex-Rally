import 'dart:async';
import 'package:flutter/material.dart';
import 'package:group5_project/main.dart';
import '../classes_and_functions/profile.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool done = false;

  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 3),
      () {
        if (done) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const RootPage()));
        } else {
          throw Exception('Connection state fail');
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          done = true;
        }
        return Container(
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 91, 70, 210),
          ),
          child: Center(
            child: Column(
              children: [
                const SizedBox(
                  height: 40,
                ),
                Image.asset(
                  'assets/images/logo/reflex_rally_test_logo2.png',
                  height: 300.0,
                  width: 300.0,
                  alignment: Alignment.center,
                ),
                const SizedBox(
                  height: 100,
                ),
                const DefaultTextStyle(
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 18),
                  child: Text(
                    'EPILEPSY WARNING! THIS GAME CONTAINS FLASHING COLORS. PHOTOSENSITIVE PEOPLE MAY EXPERIENCE DISCOMFORT AND SEIZURES.',
                  ),
                ),
                const SizedBox(
                  height: 70,
                ),
                const CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 5,
                ),
              ],
            ),
          ),
        );
      },
      future: Profile.init(),
    );
  }
}
