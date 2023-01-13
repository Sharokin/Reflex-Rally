import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_fonts/google_fonts.dart';
import 'package:group5_project/game/ui.dart';
import '../classes_and_functions/profile.dart';

class Countdown extends StatefulWidget {
  const Countdown({super.key});

  @override
  State<Countdown> createState() => _CountdownState();
}

class _CountdownState extends State<Countdown>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  Animation<double>? animation;
  Timer? countdownTimer;
  Duration myDuration = const Duration(seconds: 3);

  @override
  void initState() {
    super.initState();
    startTimer();

    animationController = AnimationController(
        duration: const Duration(milliseconds: 480), vsync: this);

    final curvedAnimation = CurvedAnimation(
        parent: animationController, curve: Curves.easeInOutQuint);

    animation = Tween<double>(begin: 0.10, end: 1).animate(curvedAnimation)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          animationController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          animationController.forward();
        }
      });

    animationController.forward();
  }

  void startTimer() {
    countdownTimer =
        Timer.periodic(const Duration(seconds: 1), (_) => setCountDown());
  }

  void stopTimer() {
    setState(() => countdownTimer!.cancel());
  }

  void resetTimer() {
    stopTimer();
    myDuration = const Duration(seconds: 3);
  }

  void setCountDown() {
    const reduceSecondsBy = 1;
    final seconds = myDuration.inSeconds - reduceSecondsBy;
    setState(() {
      if (seconds <= -1) {
        Navigator.pop(context);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const GameUI()));
      } else {
        myDuration = Duration(seconds: seconds);
      }
    });
    if (seconds <= -1) {
      countdownTimer!.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    var color = Colors.red;
    String seconds = myDuration.inSeconds.toString();
    if (seconds == '3') {
      color = Colors.red;
    } else if (seconds == '2') {
      color = Colors.green;
    } else if (seconds == '1') {
      color = Colors.blue;
    }
    if (seconds == '0') {
      seconds = 'Go!';
    }
    Profile.saveSettings();
    return Scaffold(
      body: Container(
        color: color,
        child: Center(
          child: Transform.scale(
            scale: animation!.value,
            child: Text(
              seconds,
              style: GoogleFonts.bangers(
                color: Colors.white,
                fontSize: 100,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}
