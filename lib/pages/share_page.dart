import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:group5_project/pages/countdown.dart';
import '../classes_and_functions/animation_route.dart';
import 'package:share_plus/share_plus.dart';
import '../classes_and_functions/profile.dart';

class SharePage extends StatefulWidget {
  const SharePage({super.key});

  @override
  State<SharePage> createState() => _SharePageState();
}

class _SharePageState extends State<SharePage> {
  share(BuildContext context) async {
    final box = context.findRenderObject() as RenderBox?;

    await Share.share(
        "I got a score of ${profile.scoreLatest} on Reflex Rally!",
        subject: "Link to app!",
        sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [
          Color.fromARGB(255, 91, 70, 195),
          Color.fromARGB(255, 91, 70, 210),
          Color.fromARGB(255, 91, 70, 225),
        ], begin: Alignment.topCenter, end: Alignment.bottomRight),
      ),
      child: Center(
        child: FractionallySizedBox(
          widthFactor: 0.9,
          heightFactor: 0.9,
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Image.asset(
                  'assets/images/logo/reflex_rally_test_logo2.png',
                ),
              ),
              SizedBox(
                height: (screenHeight / 50), //5.0, //10.0
              ),
              Expanded(
                flex: 1,
                child: Column(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: DefaultTextStyle(
                        style: GoogleFonts.amaticSc(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 35,
                        ),
                        child: const Text('You scored'),
                      ),
                    ),
                    Expanded(
                        flex: 1,
                        child: DefaultTextStyle(
                            style: GoogleFonts.bangers(
                              color: Colors.white,
                              fontWeight: FontWeight.normal,
                              fontSize: 40,
                            ),
                            child: Text('${profile.scoreLatest}')
                        ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          DefaultTextStyle(
                            style: GoogleFonts.amaticSc(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 35,
                            ),
                            child: const Text(
                              'Share your score!',
                            ),
                          ),
                          const SizedBox(
                            width: 10.0,
                          ),
                          Material(
                            color: Colors.transparent,
                            child: IconButton(
                              color: Colors.transparent,
                              onPressed: () => share(context),
                              icon: const Icon(
                                Icons.share,
                                size: 35,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: FractionallySizedBox(
                  heightFactor: 0.5,
                  widthFactor: 0.7,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all(12),
                      backgroundColor: MaterialStateProperty.all<Color>(
                          const Color.fromARGB(255, 141, 240, 84)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(180.0)),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                      setState(() {
                        Navigator.push(
                            context,
                            AnimationRoute(
                                widget: const Countdown(),
                                anim: Curves.linear,
                                duration: 400));
                      });
                    },
                    child: const FittedBox(
                        fit: BoxFit.fill,
                        child: Icon(
                          Icons.play_arrow,
                          size: 45,
                        )),
                  ),
                ),
              ),
              Flexible(
                child: FractionallySizedBox(
                  heightFactor: 0.5,
                  widthFactor: 0.7,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all(12),
                      backgroundColor: MaterialStateProperty.all<Color>(
                          const Color.fromARGB(255, 252, 15, 15)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(180.0)),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    child: const FittedBox(
                        fit: BoxFit.fill, child: Icon(Icons.home, size: 45)),
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
