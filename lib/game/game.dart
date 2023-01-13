import 'dart:async';
import 'package:flutter/material.dart';
import 'package:group5_project/classes_and_functions/audio_player.dart';
import 'package:group5_project/classes_and_functions/profile.dart';
import 'dart:math' as math;
import '../classes_and_functions/mySettingsList.dart';
import 'gesture.dart';
import 'gamemode.dart';

AudioManager sfxPlayer = AudioManager();

class Game {
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

  Color colorPromptForeground = Colors.black;
  Color colorPromptBackground = Colors.white;
  Color colorPromptStatus = Colors.green;

  gestures gestureActive = gestures.inactive;
  Map<gestures, Gesture> gestureList = {};

  // ignore: non_constant_identifier_names
  void loadGame() {
    gestureList = gamemode.gestureList!;
    gameRun = true;
    if (gamemode.skipToShare == true) {
      gameRun = false;
      gamemode.time = 0;
      time = 0;
    }
    Timer.periodic(const Duration(milliseconds: 10), (Timer timer) {
      if (!gameRun) {
        timer.cancel();
      }
      onTimer();
    });
    generatePrompt();
    generateColor();
  }

  void unloadGame() {
    onGesture(gestures.onShake).unloadSensor();
    profile.tryInsertScore(Score(score, DateTime.now().toString()), easyOrHard);
  }

  Gesture onGesture(gestures type) {
    if (gestureList[type] != null) {
      return gestureList[type]!;
    } else {
      return Gesture();
    }
  }

  void onTimer() {
    time += timeStep;
    if (!gamemode.endless && time >= gamemode.time) {
      win();
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

    if (gamemode.distraction && (time % (gamemode.promptTimeout / 4) == 0)) {
      generateColor();
    }

    if (gameRun) {
      displayUpdate();
    }
  }

  void displayUpdate() {
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
    sfxPlayer.playSFX(Sfx.win);
    profile.tryInsertScore(Score(score, DateTime.now().toString()), easyOrHard);
  }

  void scoreFunction() {
    comboCounter++;
    if (comboCounter == 2) {
      combo++;
      comboCounter = 0;
    }
    // ignore: division_optimization
    addedScore = (combo * (gamemode.promptTimeout - promptTime) / 1000).toInt();
    if (addedScore < 1) {
      addedScore = 1;
    }
    score += addedScore;
  }

  void penaltyFunction() {
    if (combo > 1) {
      combo = 1;
    }
    if (score >= gamemode.scorePenalty) {
      score -= gamemode.scorePenalty;
    } else {
      score = 0;
    }
    if (time < 2 * (gamemode.time - timeStep ~/ 2)) time += timeStep ~/ 2;

    comboCounter = 0;
  }

  void onCorrect() {
    for (Gesture g in gestureList.values) {
      g.unlock();
      g.reset();
    }

    statusIndicator(true);
    scoreFunction();

    if (!gamemode.distraction) {
      generateColor();
    }
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

  void generateColor() {
    int max = 255;

    int parts = 3;
    int fill = max ~/ 3;

    int rpart = 0;
    int gpart = 0;
    int bpart = 0;
    int r = 0;
    int g = 0;
    int b = 0;
    while ((rpart + gpart + bpart <= parts) ||
        (rpart + gpart + bpart >= 3 * parts - 2) ||
        ((rpart == colorPromptForeground.red / fill) &&
            (gpart == colorPromptForeground.green / fill) &&
            (bpart == colorPromptForeground.blue / fill))) {
      rpart = rng.nextInt(parts + 1);
      gpart = rng.nextInt(parts + 1);
      bpart = rng.nextInt(parts + 1);
    }
    r = fill * rpart;
    g = fill * gpart;
    b = fill * bpart;

    colorPromptForeground = Color.fromARGB(max, r, g, b);
    colorPromptBackground = Color.fromARGB(max, max - r, max - g, max - b);
  }
}
