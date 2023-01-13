import 'package:group5_project/classes_and_functions/mySettingsList.dart';
import 'gesture.dart';

bool experimentalGamemode = false;

class Gamemode {
  static Gamemode easy() {
    Gamemode g = Gamemode();
    g.endless = false;
    g.promptSkip = false;
    g.promptTimeout = 4 * 1000;
    g.time = 30 * 1000;
    g.scorePenalty = 1;
    g.timePenalty = 1;
    g.scoreMultiplier = 1;
    g.distraction = false;
    g.gestureList = {
      OnTap.type: OnTap(),
      OnTapDouble.type: OnTapDouble(),
      OnPan.type: OnPan(),
    };
    return g;
  }

  static Gamemode hard() {
    Gamemode g = Gamemode();
    g.endless = false;
    g.promptSkip = false;
    g.promptTimeout = 3 * 1000;
    g.time = 30 * 1000;
    g.scorePenalty = 3;
    g.timePenalty = 3;
    g.scoreMultiplier = 2;
    g.distraction = true;
    g.gestureList = {
      OnTapUp.type: OnTapUp(),
      OnTapDown.type: OnTapDown(),
      gestures.onTapLeft: OnTapLeft(),
      gestures.onTapRight: OnTapRight(),
      OnTapDoubleUp.type: OnTapDoubleUp(),
      OnTapDoubleDown.type: OnTapDoubleDown(),
      gestures.onTapDoubleLeft: OnTapDoubleLeft(),
      gestures.onTapDoubleRight: OnTapDoubleRight(),
      OnPanUp.type: OnPanUp(),
      OnPanDown.type: OnPanDown(),
      OnPanLeft.type: OnPanLeft(),
      OnPanRight.type: OnPanRight(),
      OnShake.type: OnShake(),
    };
    return g;
  }

  static Gamemode experimental() {
    Gamemode g = Gamemode.hard();
    g.endless = true;
    g.promptSkip = true;
    g.promptTimeout = 0 * 1000;
    g.time = 0 * 1000;
    g.distraction = false;
    g.gestureList = {
      OnTapDoubleUp.type: OnTapDoubleUp(),
      OnTapDoubleDown.type: OnTapDoubleDown(),
      OnTapDoubleLeft.type: OnTapDoubleLeft(),
      OnTapDoubleRight.type: OnTapDoubleRight(),
    };
    return g;
  }

  int promptTimeout = 2 * 1000;
  bool endless = false;
  int time = 30 * 1000;
  bool promptSkip = false;
  Map<gestures, Gesture>? gestureList;
  bool distraction = false;
  bool skipToShare = false;
  int scorePenalty = 0;
  int timePenalty = 1;
  double scoreMultiplier = 1;
}

Gamemode easyOrHardFunc() {
  if (experimentalGamemode) return Gamemode.experimental();

  if (easyOrHard) {
    return Gamemode.hard();
  } else {
    return Gamemode.easy();
  }
}

Gamemode gamemode = easyOrHardFunc();
