import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:group5_project/classes_and_functions/animation_route.dart';
import 'package:group5_project/classes_and_functions/mySettingsList.dart';
import 'package:group5_project/classes_and_functions/profile.dart';
import 'package:group5_project/pages/share_page.dart';
import 'package:group5_project/classes_and_functions/audio_player.dart';
import 'package:flutter/services.dart';
import 'gesture.dart';
import 'gamemode.dart';

AudioManager sfxPlayer = AudioManager();

class GameUI extends StatefulWidget {
  const GameUI({super.key});

  @override
  State<GameUI> createState() => _GameUIState();
}

final Map<Color, Color> colorpair = {
  const Color(0xFFFFFF00): const Color(0xFF0000FF),
  const Color(0xFFFF0000): const Color(0xFF00FFFF),
  const Color(0xFF0000FF): const Color(0xFFFFFF00),
  const Color(0xFF00FFFF): const Color(0xFFFF0000),
  const Color(0xFFFF00FF): const Color(0xFF00FF00),
  const Color(0xFF00FF00): const Color(0xFFFF00FF),
};

class _GameUIState extends State<GameUI> with TickerProviderStateMixin {
  late AnimationController comboAnimation;
  late AnimationController scoreAnimation;
  late AnimationController timeAnimation;
  late Animation<double> _fadeInFadeOutCombo;
  late Animation<double> _fadeInFadeOutScore;
  late Animation<double> _fadeInFadeOutTime;

  @override
  void initState() {
    super.initState();
    loadGame();
    loadSensors();

    comboAnimation = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeInFadeOutCombo =
        Tween<double>(begin: 0.0, end: 1.0).animate(comboAnimation);

    comboAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        comboAnimation.reverse();
      } else if (status == AnimationStatus.dismissed) {
        comboAnimation.stop();
      }
    });

    scoreAnimation = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeInFadeOutScore =
        Tween<double>(begin: 0.0, end: 1.0).animate(scoreAnimation);

    scoreAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        scoreAnimation.reverse();
      } else if (status == AnimationStatus.dismissed) {
        scoreAnimation.stop();
      }
    });

    timeAnimation = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeInFadeOutTime =
        Tween<double>(begin: 0.0, end: 1.0).animate(timeAnimation);

    timeAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        timeAnimation.reverse();
      } else if (status == AnimationStatus.dismissed) {
        timeAnimation.stop();
      }
    });
  }

  //!!!
  // ignore: non_constant_identifier_names
  void loadGame() {
    gestureList = gamemode.gestureList!;
    gameRun = true;
    Timer.periodic(const Duration(milliseconds: 10), (Timer timer) {
      if (!gameRun) {
        timer.cancel();
      }
      onTimer();
    });
    generatePrompt();
    generateColor();
  }

  // ignore: non_constant_identifier_names
  void loadSensors() {
    onGesture(gestures.onShake).loadSensor();
  }

  //!!!
  // ignore: non_constant_identifier_names
  void unloadGame() {
    onGesture(gestures.onShake).unloadSensor();
    Navigator.of(context).popUntil((route) => route.isFirst);
    setState(() {
      if ((time > gamemode.time)) {
        Navigator.push(
            context,
            AnimationRoute(
                widget: const SharePage(),
                anim: Curves.easeOutExpo,
                duration: 1000));
      }
    });
  }

  //!!!
  math.Random rng = math.Random();
  bool gameRun = false;
  int timeStep = 10;
  int statusTime = 0;

  int score = 0;
  int combo = 1;
  int time = 0;
  int comboCounter = 0;
  int promptTime = 0;
  int addedScore = 0;

  gestures gestureActive = gestures.inactive;
  Map<gestures, Gesture> gestureList = {};
  Gesture onGesture(gestures type) {
    if (gestureList[type] != null) {
      return gestureList[type]!;
    } else {
      return Gesture();
    }
  }

  String displayPrompt() {
    return onGesture(gestureActive).promptText();
  }

  String displayScore() {
    String dscore = score.toString();
    if (dscore.length >= 4) {
      dscore = dscore[0] + '.' + dscore.substring(1, 3) + 'k';
    }

    // ignore: unnecessary_brace_in_string_interps
    return "Score:${dscore}";
  }

  String displayCombo() {
    // ignore: unnecessary_brace_in_string_interps
    return "Combo:x${combo}";
  }

  String displayTime() {
    int t = (gamemode.time - time) ~/ 1000;
    return "Time:${t < 0 ? 0 : t}";
  }

  Color colorPromptForeground = Colors.black;
  Color colorPromptBackground = Colors.white;
  Color colorPromptStatus = Colors.green;

  //!!!
  void onTimer() {
    time += timeStep;
    if (!gamemode.endless && time >= gamemode.time) {
      if (gameRun) {
        win();
      }
      unloadGame();
      return;
    }

    statusTime += timeStep;
    if (statusTime > (1000 / 2)) {
      colorPromptStatus = colorPromptBackground;
    }
    gestureCheck();

    promptTime += timeStep;
    if (gamemode.promptTimeout > 0) {
      if (promptTimeoutCheck()) {
        onPromptTimeout();
      }
    }

    if (gamemode.distraction && (time % (gamemode.promptTimeout / 4) < 1)) {
      generateColor();
    }

    if (gameRun) {
      displayUpdate();
      setState(() {});
    }
  }

  void gestureCheck() {
    bool c = false;
    bool f = false;

    for (Gesture g in gestureList.values) {
      if (g.complete()) {
        if (g.iType == gestureActive) {
          c = true;
        } else {
          f = true;
        }
        g.reset();
      }
    }
    if (c) {
      onCorrect();
    }

    if (f) {
      onIncorrect();
    }
  }

  bool winCheck() {
    return time >= gamemode.time;
  }

  void win() {
    gameRun = false;
    profile.tryInsertScore(Score(score, DateTime.now().toString()), easyOrHard);
    sfxPlayer.playSFX(Sfx.win);
  }

  void scoreFunction() {
    comboCounter++;
    if (comboCounter == 2) {
      combo++;
      comboAnimation.forward();
      comboCounter = 0;
    }
    // ignore: division_optimization
    addedScore = ((combo * (gamemode.promptTimeout - promptTime) / 1000) *
            gamemode.scoreMultiplier)
        .toInt();
    score += addedScore;
    scoreAnimation.forward();
  }

  void penaltyFunction() {
    if (combo > 1) {
      combo = 1;
      comboAnimation.forward();
    }
    if (score >= gamemode.scorePenalty) {
      score -= gamemode.scorePenalty;
    } else {
      score = 0;
    }
    //TODO: Quick fix
    if (time > 4000) {
      time += gamemode.timePenalty * 1000;
    }
    if(time < 0) {
      time = 0;
    }
    comboCounter = 0;
  }

  void onCorrect() {
    for (Gesture g in gestureList.values) {
      g.unlock();
      g.reset();
    }

    statusIndicator(true);
    scoreFunction();

    generateColor();
    generatePrompt();
  }

  void onIncorrect() {
    statusIndicator(false);
    penaltyFunction();
  }

  void statusIndicator(bool correct) {
    statusTime = 0;
    if (correct) {
      sfxPlayer.playSFX(Sfx.success);
      colorPromptStatus = Colors.green;
    } else {
      HapticFeedback.vibrate();
      sfxPlayer.playSFX(Sfx.fail);
      colorPromptStatus = Colors.red;
    }
  }

  bool promptTimeoutCheck() {
    return promptTime >= gamemode.promptTimeout;
  }

  void onPromptTimeout() {
    onIncorrect();
    generatePrompt();
    generateColor();
  }

  void generatePrompt() {
    int breakLoop = 0;
    int rngGesture = 0;

    //onGesture(gestureActive).lock();
    if (gestureActive == OnShake.type) {
      onGesture(gestureActive).lock();
    }

    do {
      rngGesture = rng.nextInt(gestureList.length);
      breakLoop++;
    } while ((gestureActive == gestureList.values.toList()[rngGesture].iType) &&
        breakLoop < 7);
    gestureActive = gestureList.values.toList()[rngGesture].iType;

    if (gestureActive == OnTapUp.type || gestureActive == OnTapDown.type) {
      onGesture(OnTapLeft.type).lock();
      onGesture(OnTapRight.type).lock();
    }

    if (gestureActive == OnTapLeft.type || gestureActive == OnTapRight.type) {
      onGesture(OnTapUp.type).lock();
      onGesture(OnTapDown.type).lock();
    }

    if (gestureActive == OnTapDoubleUp.type ||
        gestureActive == OnTapDoubleDown.type) {
      onGesture(OnTapDoubleLeft.type).lock();
      onGesture(OnTapDoubleRight.type).lock();
    }

    if (gestureActive == OnTapDoubleLeft.type ||
        gestureActive == OnTapDoubleRight.type) {
      onGesture(OnTapDoubleUp.type).lock();
      onGesture(OnTapDoubleDown.type).lock();
    }

    promptTime = 0;
    displayUpdate();
    sfxPlayer.playPROMPT(onGesture(gestureActive).promptAudioSrc());
  }

  void displayUpdate() {
    setState(() {
      displayPrompt(); // = "${prompts[gestureActive]}";
      displayScore(); // = "Score: $score";
      displayCombo(); // = "Combo: x$combo";
      displayTime(); // = "Time: $time";
    });
  }

  void generateColor() {
    int max = 255;

    int parts = 3;
    int fill = max ~/ 3;

    int r_part = 0;
    int g_part = 0;
    int b_part = 0;
    int r = 0;
    int g = 0;
    int b = 0;
    while ((r_part + g_part + b_part <= parts) ||
        (r_part + g_part + b_part >= 3 * parts - 2) ||
        ((r_part == colorPromptForeground.red / fill) &&
            (g_part == colorPromptForeground.green / fill) &&
            (b_part == colorPromptForeground.blue / fill))) {
      r_part = rng.nextInt(parts + 1);
      g_part = rng.nextInt(parts + 1);
      b_part = rng.nextInt(parts + 1);
    }
    r = fill * r_part;
    g = fill * g_part;
    b = fill * b_part;

    colorPromptForeground = Color.fromARGB(max, r, g, b);
    colorPromptBackground = Color.fromARGB(max, max - r, max - g, max - b);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        //TAP SINGLE
        onTap: () {},
        onTapDown: (details) {
          onGesture(gestures.onTap).setState([
            true,
            null,
            [details.globalPosition.dx, details.globalPosition.dy]
          ]);
          onGesture(gestures.onTapUp).setState([
            true,
            null,
            [details.globalPosition.dx, details.globalPosition.dy]
          ]);
          onGesture(gestures.onTapDown).setState([
            true,
            null,
            [details.globalPosition.dx, details.globalPosition.dy]
          ]);
          onGesture(gestures.onTapLeft).setState([
            true,
            null,
            [details.globalPosition.dx, details.globalPosition.dy]
          ]);
          onGesture(gestures.onTapRight).setState([
            true,
            null,
            [details.globalPosition.dx, details.globalPosition.dy]
          ]);
        },
        onTapUp: (details) {
          onGesture(gestures.onTap).setState([null, true, null]);
          onGesture(gestures.onTapUp).setState([null, true, null]);
          onGesture(gestures.onTapDown).setState([null, true, null]);
          onGesture(gestures.onTapLeft).setState([null, true, null]);
          onGesture(gestures.onTapRight).setState([null, true, null]);
        },
        onTapCancel: () {
          onGesture(gestures.onTap).reset();
          onGesture(gestures.onTapUp).reset();
          onGesture(gestures.onTapDown).reset();
          onGesture(gestures.onTapLeft).reset();
          onGesture(gestures.onTapRight).reset();
        },
        //TAP DOUBLE
        onDoubleTap: () {
          onGesture(gestures.onTapDouble).setState([null, true, null]);
          onGesture(gestures.onTapDoubleUp).setState([null, true, null]);
          onGesture(gestures.onTapDoubleDown).setState([null, true, null]);
          onGesture(gestures.onTapDoubleLeft).setState([null, true, null]);
          onGesture(gestures.onTapDoubleRight).setState([null, true, null]);
        },
        onDoubleTapDown: (details) {
          onGesture(gestures.onTapDouble).setState([
            true,
            null,
            [details.globalPosition.dx, details.globalPosition.dy]
          ]);
          onGesture(gestures.onTapDoubleUp).setState([
            true,
            null,
            [details.globalPosition.dx, details.globalPosition.dy]
          ]);
          onGesture(gestures.onTapDoubleDown).setState([
            true,
            null,
            [details.globalPosition.dx, details.globalPosition.dy]
          ]);
          onGesture(gestures.onTapDoubleLeft).setState([
            true,
            null,
            [details.globalPosition.dx, details.globalPosition.dy]
          ]);
          onGesture(gestures.onTapDoubleRight).setState([
            true,
            null,
            [details.globalPosition.dx, details.globalPosition.dy]
          ]);
        },
        onDoubleTapCancel: () {
          //print("onDoubleTapCancel");
          onGesture(gestures.onTapDouble).reset();
          onGesture(gestures.onTapDoubleUp).reset();
          onGesture(gestures.onTapDoubleDown).reset();
          onGesture(gestures.onTapDoubleLeft).reset();
          onGesture(gestures.onTapDoubleRight).reset();
        },
        //PAN
        onPanStart: (details) {
          onGesture(gestures.onPan).setState([
            null,
            null,
            [details.globalPosition.dx, details.globalPosition.dy],
            null
          ]);
          onGesture(gestures.onPanUp).setState([
            null,
            null,
            [details.globalPosition.dx, details.globalPosition.dy],
            null
          ]);
          onGesture(gestures.onPanDown).setState([
            null,
            null,
            [details.globalPosition.dx, details.globalPosition.dy],
            null
          ]);
          onGesture(gestures.onPanLeft).setState([
            null,
            null,
            [details.globalPosition.dx, details.globalPosition.dy],
            null
          ]);
          onGesture(gestures.onPanRight).setState([
            null,
            null,
            [details.globalPosition.dx, details.globalPosition.dy],
            null
          ]);
        },
        onPanDown: (details) {
          onGesture(gestures.onPan).setState([true, null, null, null]);
          onGesture(gestures.onPanUp).setState([true, null, null, null]);
          onGesture(gestures.onPanDown).setState([true, null, null, null]);
          onGesture(gestures.onPanLeft).setState([true, null, null, null]);
          onGesture(gestures.onPanRight).setState([true, null, null, null]);
        },
        onPanEnd: (details) {
          onGesture(gestures.onPan).setState([
            null,
            true,
            null,
            [
              details.velocity.pixelsPerSecond.dx,
              details.velocity.pixelsPerSecond.dy
            ]
          ]);
          onGesture(gestures.onPanUp).setState([
            null,
            true,
            null,
            [
              details.velocity.pixelsPerSecond.dx,
              details.velocity.pixelsPerSecond.dy
            ]
          ]);
          onGesture(gestures.onPanDown).setState([
            null,
            true,
            null,
            [
              details.velocity.pixelsPerSecond.dx,
              details.velocity.pixelsPerSecond.dy
            ]
          ]);
          onGesture(gestures.onPanLeft).setState([
            null,
            true,
            null,
            [
              details.velocity.pixelsPerSecond.dx,
              details.velocity.pixelsPerSecond.dy
            ]
          ]);
          onGesture(gestures.onPanRight).setState([
            null,
            true,
            null,
            [
              details.velocity.pixelsPerSecond.dx,
              details.velocity.pixelsPerSecond.dy
            ]
          ]);
        },
        onPanCancel: () {
          onGesture(gestures.onPan).reset;
          onGesture(gestures.onPanUp).reset;
          onGesture(gestures.onPanDown).reset;
          onGesture(gestures.onPanLeft).reset;
          onGesture(gestures.onPanRight).reset;
        },
        onPanUpdate: (details) {
          onGesture(gestures.onPan).setState([
            null,
            null,
            null,
            null,
          ]);
          onGesture(gestures.onPanUp).setState([
            null,
            null,
            null,
            null,
          ]);
          onGesture(gestures.onPanDown).setState([
            null,
            null,
            null,
            null,
          ]);
          onGesture(gestures.onPanLeft).setState([
            null,
            null,
            null,
            null,
          ]);
          onGesture(gestures.onPanRight).setState([
            null,
            null,
            null,
            null,
          ]);
        },
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.center,
                  end: Alignment.bottomCenter,
                  colors: [colorPromptBackground, colorPromptStatus])),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              toolbarHeight: 80,
              leading: TextButton(
                child: Column(
                  children: [
                    const Icon(Icons.subdirectory_arrow_left_rounded,
                        textDirection: TextDirection.ltr,
                        size: 40,
                        color: Color.fromARGB(255, 64, 32, 32)),
                    Text(
                      'hold',
                      style: GoogleFonts.bangers(
                        color: Colors.black,
                        shadows: [
                          const Shadow(
                            color: Color.fromARGB(111, 0, 0, 0),
                            offset: Offset(-1.0, 2.0),
                            blurRadius: 5.0,
                          ),
                        ],
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
                onLongPress: () {
                  gameRun = false;
                  unloadGame();
                },
                onPressed: () {},
              ),
              automaticallyImplyLeading: false,
              centerTitle: true,
              title: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        displayTime(),
                        style: GoogleFonts.bangers(
                          color: colorPromptForeground,
                          shadows: [
                            const Shadow(
                              color: Color.fromARGB(111, 0, 0, 0),
                              offset: Offset(-1.0, 2.0),
                              blurRadius: 5.0,
                            ),
                          ],
                          height: 1,
                          fontSize: 30,
                          letterSpacing: 1,
                        ),
                      ),
                      Text(
                        displayScore(),
                        style: GoogleFonts.bangers(
                          color: colorPromptForeground,
                          shadows: [
                            const Shadow(
                              color: Color.fromARGB(111, 0, 0, 0),
                              offset: Offset(-1.0, 2.0),
                              blurRadius: 5.0,
                            ),
                          ],
                          height: 1,
                          fontSize: 30,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FadeTransition(
                        opacity: _fadeInFadeOutTime,
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 250),
                          transitionBuilder:
                              (Widget child, Animation<double> animation) {
                            return ScaleTransition(
                                scale: animation, child: child);
                          },
                          child: Text(
                            gamemode.timePenalty.toString(),
                            style: GoogleFonts.bangers(
                              color: colorPromptForeground,
                              shadows: [
                                const Shadow(
                                  color: Color.fromARGB(111, 0, 0, 0),
                                  offset: Offset(-1.0, 2.0),
                                  blurRadius: 5.0,
                                ),
                              ],
                              height: 1,
                              fontSize: 30,
                              letterSpacing: 1,
                            ),
                            overflow: TextOverflow.fade,
                            textAlign: TextAlign.center,
                            key: ValueKey(gamemode.timePenalty),
                          ),
                        ),
                      ),
                      FadeTransition(
                        opacity: _fadeInFadeOutScore,
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 250),
                          transitionBuilder:
                              (Widget child, Animation<double> animation) {
                            return ScaleTransition(
                                scale: animation, child: child);
                          },
                          child: Text(
                            '+$addedScore',
                            style: GoogleFonts.bangers(
                              color: colorPromptForeground,
                              shadows: [
                                const Shadow(
                                  color: Color.fromARGB(111, 0, 0, 0),
                                  offset: Offset(-1.0, 2.0),
                                  blurRadius: 5.0,
                                ),
                              ],
                              height: 1,
                              fontSize: 35,
                              letterSpacing: 2,
                            ),
                            overflow: TextOverflow.fade,
                            textAlign: TextAlign.center,
                            key: ValueKey(addedScore),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 60,
                        height: 25,
                      ),
                    ],
                  ),
                ],
              ),
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 1,
                        child: FadeTransition(
                          opacity: _fadeInFadeOutCombo,
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 360),
                            transitionBuilder:
                                (Widget child, Animation<double> animation) {
                              return ScaleTransition(
                                  scale: animation, child: child);
                            },
                            child: Text(
                              displayCombo(),
                              style: GoogleFonts.bangers(
                                  color: colorPromptForeground,
                                  shadows: [
                                    const Shadow(
                                      color: Color.fromARGB(111, 0, 0, 0),
                                      offset: Offset(-1.0, 2.0),
                                      blurRadius: 5.0,
                                    ),
                                  ],
                                  fontSize: 45,
                                  letterSpacing: 1),
                              overflow: TextOverflow.fade,
                              textAlign: TextAlign.center,
                              key: ValueKey(combo),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayPrompt(),
                      style: GoogleFonts.bangers(
                        color: colorPromptForeground,
                        shadows: [
                          const Shadow(
                            color: Color.fromARGB(111, 0, 0, 0),
                            offset: Offset(-5.0, 5.0),
                            blurRadius: 3.0,
                          ),
                        ],
                        fontSize: 60,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [onGesture(gestureActive).promptImage()],
                ),
              ],
            ),
          ),
        ));
  }

  @override
  void dispose() {
    scoreAnimation.dispose();
    timeAnimation.dispose();
    comboAnimation.dispose();
    super.dispose();
  }
}
