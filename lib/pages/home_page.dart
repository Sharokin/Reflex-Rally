import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:group5_project/classes_and_functions/profile.dart';
import 'package:group5_project/classes_and_functions/text_border_color.dart';
import 'package:marquee/marquee.dart';

bool easyToggle = profile.isEasyTopScore() ?? true;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  Animation<double>? animation;
  Animation<double>? animation2;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        duration: const Duration(milliseconds: 430), vsync: this);

    final curvedAnimation = CurvedAnimation(
        parent: animationController, curve: Curves.easeInOutQuint);

    animation = Tween<double>(begin: 0.95, end: 1).animate(curvedAnimation);
    animation2 = Tween<double>(begin: 1, end: 0.95).animate(curvedAnimation)
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

  @override
  Widget build(BuildContext context) {
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
            children: [
              Expanded(
                flex: 1,
                child: Transform.scale(
                  scale: animation2!.value,
                  child: Image.asset(
                    'assets/images/logo/reflex_rally_test_logo2.png',
                    height: 400.0,
                    width: 400.0,
                  ),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Expanded(
                child: Column(
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: Transform.scale(
                        scale: animation!.value,
                        child: Image.asset('assets/images/Highscore_s.png',
                            scale: 1.7),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextBorderColor(
                                text: '${profile.isEasyTopScore() == null ? 'No score' : profile.isEasyTopScore() == true ? profile.easy_scores.first : profile.hard_scores.first}',
                                size: 45,
                                color: const Color.fromARGB(
                                    255,181,207,90),
                                outlineColor: Colors.black,
                            ),
                            SizedBox(
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width/20,
                            ),
                            if (!profile.easy_scores.isEmpty || !profile.hard_scores.isEmpty) ...[
                              IconButton(
                                icon: Icon(
                                  FontAwesomeIcons.trophy,
                                  shadows: <Shadow>[Shadow(color: Colors.black45, blurRadius: 20.0, offset: Offset(0, 2.0))],
                                  color: const Color.fromARGB(
                                      255,181,207,90),
                                  size: 35,
                                ),
                                padding: EdgeInsets.fromLTRB(0, 0, 0, 4),
                                onPressed: () {
                                  if (!profile.easy_scores.isEmpty || !profile.hard_scores.isEmpty) {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return StatefulBuilder(
                                            builder: (context, setState) {
                                              return AlertDialog(
                                                actionsAlignment: MainAxisAlignment.center,
                                                actions: [
                                                  SizedBox(
                                                    width: 60,
                                                    height: 60,
                                                    child: MaterialButton(
                                                      splashColor: Colors.transparent,
                                                      highlightColor: Colors.transparent,
                                                      enableFeedback: false,
                                                      onPressed: () =>
                                                          Navigator.pop(context, false),
                                                      child: Icon(
                                                        Icons.close,
                                                        size: 40,
                                                        color: const Color.fromARGB(
                                                            255, 141, 240, 84),
                                                      ),
                                                    ),
                                                  ),
                                                  if (!profile.easy_scores.isEmpty && !profile.hard_scores.isEmpty) ...[
                                                    SizedBox(
                                                      width: 60,
                                                      height: 60,
                                                      child: MaterialButton(
                                                        splashColor: Colors.transparent,
                                                        highlightColor: Colors.transparent,
                                                        enableFeedback: false,
                                                        onPressed: () => setState(() {
                                                          easyToggle = !easyToggle;
                                                        }),
                                                        child: Icon(
                                                          Icons.refresh,
                                                          size: 40,
                                                          color: const Color.fromARGB(
                                                              255, 141, 240, 84),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ],
                                                scrollable: true,
                                                backgroundColor: const Color.fromARGB(
                                                    255, 91, 70, 225),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(8),
                                                  side: BorderSide(
                                                    color: const Color.fromARGB(
                                                        255, 141, 240, 84),
                                                    width: 8,
                                                  ),
                                                ),
                                                title: Align(
                                                  alignment: Alignment.topCenter,
                                                  child: TextBorderColor(
                                                    text: easyToggle == true ? 'Top easy\nscores' : 'Top hard\nscores',
                                                    textAlign: TextAlign.center,
                                                    size: 40,
                                                    color: const Color.fromARGB(
                                                        255,181,207,90),
                                                    outlineColor: Colors.black,
                                                  ),
                                                ),
                                                content: Padding(
                                                  padding: const EdgeInsets.all(5.0),
                                                  child: SizedBox(
                                                    height: (MediaQuery
                                                        .of(context)
                                                        .size
                                                        .width / 12) *
                                                        (easyToggle == true ? profile.easy_scores.length.toDouble() : profile.hard_scores.length.toDouble()),
                                                    width: MediaQuery
                                                        .of(context)
                                                        .size
                                                        .width * 3 / 4,
                                                    child: Padding(
                                                      padding: EdgeInsets.fromLTRB(
                                                          MediaQuery
                                                              .of(context)
                                                              .size
                                                              .width / 6, 0, 0, 0),
                                                      child: ListView.builder(
                                                        physics: const NeverScrollableScrollPhysics(),
                                                        shrinkWrap: true,
                                                        itemCount: easyToggle == true ? profile.easy_scores.length : profile.hard_scores.length,
                                                        itemBuilder: (context, index) {
                                                          return ScoreBuilder(
                                                              score: (easyToggle == true ? profile.easy_scores : profile.hard_scores)[index],
                                                              index: index);
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                        );
                                      },
                                    );
                                  };
                                },
                              ),
                            ],
                          ],
                        ),
                      )
                    ),
                    Expanded(
                      child: Marquee(
                        text:
                            'Be careful not to drop your phone when playing Reflex Rally!'
                            '                           '
                            'You can exit a game session by holding the back arrow in the top left corner!'
                            '                           '
                            'The faster you complete an action the more points you score!'
                            '                           '
                            'You get punished by making errors, you lose time, score and your combo!'
                            '                           '
                            'Pausing is not an option in Reflex Rally!'
                            '                           '
                            'You can mute music, sound effects and more in the settings page!'
                            '                           '
                            'You can share you score with friends by clicking the share button after you finish a round!'
                            '       ',
                        style: GoogleFonts.amaticSc(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                        scrollAxis: Axis.horizontal,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        blankSpace: 100.0,
                        velocity: 75.0,
                      ),
                    )
                  ],
                ),
              ),
            ],
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
