import 'package:flutter/material.dart';
import 'package:group5_project/game/gamemode.dart';
import 'package:google_fonts/google_fonts.dart';
import '../classes_and_functions/mySettingsList.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  Animation<double>? animation;
  double fontSizeEasy = 0;
  double fontSizeHard = 0;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        duration: const Duration(milliseconds: 445), vsync: this);

    final curvedAnimation = CurvedAnimation(
        parent: animationController, curve: Curves.easeInOutQuint);

    animation = Tween<double>(begin: 0.95, end: 1).animate(curvedAnimation)
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
    fontSizeEasy = 0;
    fontSizeHard = 0;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double imageWidth = 0.5 * screenWidth;

    if (easyOrHard) {
      fontSizeHard = 55;
      fontSizeEasy = 25;
    } else {
      fontSizeHard = 25;
      fontSizeEasy = 55;
    }

    return Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [
            Color.fromARGB(255, 91, 70, 195),
            Color.fromARGB(255, 91, 70, 210),
            Color.fromARGB(255, 91, 70, 225),
          ], begin: Alignment.topCenter, end: Alignment.bottomRight),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Transform.scale(
                scale: animation!.value,
                child: Image.asset(
                  'assets/images/settings_s.png',
                  width: imageWidth, /*height: imageHeight*/
                ),
              ),
              const SizedBox(
                height: 55,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 6,
                    child: Text(
                      "Easy",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.amaticSc(
                        color: const Color.fromARGB(255, 141, 240, 84),
                        height: 1.5,
                        fontWeight: FontWeight.bold,
                        fontSize: fontSizeEasy,
                        letterSpacing: 5,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Transform.scale(
                      scaleX: 2,
                      scaleY: 2,
                      child: Switch(
                        activeColor: const Color.fromARGB(255, 141, 240, 84),
                        activeTrackColor:
                            const Color.fromARGB(255, 141, 240, 84),
                        inactiveThumbColor:
                            const Color.fromARGB(255, 141, 240, 84),
                        inactiveTrackColor:
                            const Color.fromARGB(255, 141, 240, 84),
                        splashRadius: 60.0,
                        value: easyOrHard,
                        onChanged: (value) {
                          setState(() {
                            changes();
                            easyOrHard = value;
                            if (easyOrHard) {
                              gamemode = Gamemode.hard();
                            } else {
                              gamemode = Gamemode.easy();
                            }
                          });
                        },
                        activeThumbImage: const AssetImage(
                            'assets/images/other/arrow_right.png'),
                        inactiveThumbImage: const AssetImage(
                            'assets/images/other/arrow_left.png'),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: Text(
                      "Hard",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.amaticSc(
                        color: const Color.fromARGB(255, 141, 240, 84),
                        height: 1.5,
                        fontWeight: FontWeight.bold,
                        fontSize: fontSizeHard,
                        letterSpacing: 5,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(right: 30),
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    return settings_list(
                      index: index,
                    );
                  }),
            ],
          ),
        ));
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}
