import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:group5_project/classes_and_functions/animation_route.dart';
import 'package:group5_project/classes_and_functions/audio_player.dart';
import 'package:group5_project/classes_and_functions/mySettingsList.dart';
import 'package:group5_project/pages/countdown.dart';
import 'package:group5_project/pages/splash_screen.dart';
import 'classes_and_functions/profile.dart';
import 'pages/home_page.dart';
import 'pages/settings.dart';
import 'pages/dev_page.dart';
import 'classes_and_functions/sceen.dart';

AudioManager preLoad = AudioManager();

class _Handler extends WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      onOrOff[0] = true;
      preLoad.resumeMUSIC();
    } else {
      onOrOff[0] = false;
      preLoad.pauseMUSIC();
    }
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  runApp(const MyApp());

  WidgetsBinding.instance.addObserver(_Handler());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  @override
  void initState() {
    super.initState();
    preLoad.preloadMUSIC();
    preLoad.preloadSFX();
    preLoad.preloadPROMPT();
    preLoad.playMUSIC(Music.startTheme);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  int currentPage = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const Settings(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 91, 70, 225),
      body: _pages[currentPage],
      floatingActionButton: SizedBox(
        height: 75,
        width: 75,
        child: FittedBox(
          child: FloatingActionButton(
            backgroundColor: const Color.fromARGB(255, 141, 240, 84),
            onPressed: () {
              HapticFeedback.vibrate();
              SM = ScreenManager([
                MediaQuery.of(context).size.width,
                MediaQuery.of(context).size.height
              ]);
              setState(() {
                Navigator.push(
                    context,
                    AnimationRoute(
                        widget: const Countdown(),
                        anim: Curves.linear,
                        duration: 400));
              });
            },
            child: const Icon(Icons.play_arrow_rounded, size: 50),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: SizedBox(
        height: 66,
        child: AnimatedBottomNavigationBar(
          icons: const [Icons.home, Icons.settings],
          activeColor: const Color.fromARGB(255, 141, 240, 84),
          backgroundGradient: const LinearGradient(colors: [
            Color.fromARGB(255, 252, 15, 15),
            Color.fromARGB(255, 170, 1, 1),
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
          inactiveColor: const Color.fromARGB(255, 226, 167, 167),
          iconSize: 40,
          gapWidth: 125,
          splashColor: const Color.fromARGB(255, 141, 240, 84),
          splashRadius: 40,
          splashSpeedInMilliseconds: 200,
          activeIndex: currentPage,
          gapLocation: GapLocation.center,
          notchSmoothness: NotchSmoothness.verySmoothEdge,
          onTap: (index) {
            HapticFeedback.vibrate();
            if (devPageIsActive) {
              if (currentPage == index) {
                if (devPageAccessorC == devPageAccessorI) {
                  setState(() {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const DevPage()));
                  });
                } else {
                  devPageAccessorC++;
                }
              }
            }
            setState(() {
              Profile.saveSettings();
              currentPage = index;
            });
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    preLoad.dispose();
    super.dispose();
  }
}
