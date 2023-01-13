import 'package:flutter/material.dart';
import 'package:group5_project/classes_and_functions/sceen.dart';
import '../libraries/shake.dart';

// ignore: camel_case_types
enum gestures {
  inactive,
  onTap,
  onTapUp,
  onTapDown,
  onTapLeft,
  onTapTopple,
  onTapRight,
  onTapDouble,
  onTapDoubleUp,
  onTapDoubleDown,
  onTapDoubleLeft,
  onTapDoubleRight,
  onPan,
  onPanUp,
  onPanDown,
  onPanLeft,
  onPanRight,
  onShake,
  onTurn,
}

class Gesture {
  static gestures type = gestures.inactive;
  gestures get iType => Gesture.type;

  void loadSensor() {}
  void unloadSensor() {}

  void reset() {}

  void setState(List<dynamic> args) {}

  bool locked = false;
  void lock() {
    locked = true;
  }

  void unlock() {
    locked = false;
  }

  bool complete() {
    if (locked) return false;
    return true;
  }

  @override
  String toString() {
    return "<Gesture>";
  }

  String pIf = "assets/images/game/gestures/";
  Image promptImage() {
    return Image.asset('${pIf}pointing_hand_tap_an1.png');
  }

  String promptAudioSrc() {
    return "tap.mp3";
  }

  String promptText() {
    return "Gesture!";
  }
}

class OnTap extends Gesture {
  static gestures type = gestures.onTap;
  @override
  gestures get iType => OnTap.type;

  bool stateDown = false;
  bool stateUp = false;

  double x = 0;
  double y = 0;

  @override
  void setState(List args) {
    int arg = 0;
    if (args[arg] != null) {
      stateDown = args[arg];
    }
    arg++;
    if (args[arg] != null) {
      stateUp = args[arg];
    }
    arg++;
    if (args[arg] != null) {
      x = args[arg][0];
      y = args[arg][1];
    }
  }

  @override
  void reset() {
    stateDown = false;
    stateUp = false;
  }

  @override
  bool complete() {
    if (locked) return false;
    return (stateDown && stateUp);
  }

  @override
  String toString() {
    return "<down:'${stateDown.toString()[0]}'><up:'${stateUp.toString()[0]}'><x:y:'${x.toInt()}':'${y.toInt()}'>";
  }

  @override
  Image promptImage() {
    return Image.asset('${pIf}tap.gif');
  }

  @override
  String promptAudioSrc() {
    return "tap.mp3";
  }

  @override
  String promptText() {
    return "Tap!";
  }
}

class OnTapUp extends OnTap {
  static gestures type = gestures.onTapUp;
  @override
  gestures get iType => OnTapUp.type;
  @override
  bool complete() {
    if (locked) return false;
    return super.complete() && y < SM.height / 2;
  }

  @override
  String promptText() {
    return "Tap Up!";
  }
}

class OnTapDown extends OnTap {
  static gestures type = gestures.onTapDown;
  @override
  gestures get iType => OnTapDown.type;
  @override
  bool complete() {
    if (locked) return false;
    return super.complete() && y > SM.height / 2;
  }

  @override
  String promptText() {
    return "Tap Down!";
  }
}

class OnTapLeft extends OnTap {
  static gestures type = gestures.onTapLeft;
  @override
  gestures get iType => OnTapLeft.type;
  @override
  bool complete() {
    if (locked) return false;
    return super.complete() && x < SM.width / 2;
  }

  @override
  String promptText() {
    return "Tap Left!";
  }
}

class OnTapRight extends OnTap {
  static gestures type = gestures.onTapRight;
  @override
  gestures get iType => OnTapRight.type;
  @override
  bool complete() {
    if (locked) return false;
    return super.complete() && x > SM.width / 2;
  }

  @override
  String promptText() {
    return "Tap Right!";
  }
}

class OnTapDouble extends Gesture {
  static gestures type = gestures.onTapDouble;
  @override
  gestures get iType => OnTapDouble.type;

  bool stateDown = false;
  bool stateUp = false;

  double x = 0;
  double y = 0;

  @override
  void setState(List args) {
    int arg = 0;
    if (args[arg] != null) {
      stateDown = args[arg];
    }
    arg++;
    if (args[arg] != null) {
      stateUp = args[arg];
    }
    arg++;
    if (args[arg] != null) {
      x = args[arg][0];
      y = args[arg][1];
    }
  }

  @override
  void reset() {
    stateDown = false;
    stateUp = false;
  }

  @override
  bool complete() {
    if (locked) return false;
    return (stateDown && stateUp);
  }

  @override
  String toString() {
    return "<down:'${stateDown.toString()[0]}'><up:'${stateUp.toString()[0]}'><x:'${x.toInt()}',y:'${y.toInt()}'>";
  }

  @override
  Image promptImage() {
    return Image.asset('${pIf}double_tap.gif');
  }

  @override
  String promptAudioSrc() {
    return "doubleTap.mp3";
  }

  @override
  String promptText() {
    return "2x Tap!";
  }
}

class OnTapDoubleUp extends OnTap {
  static gestures type = gestures.onTapDoubleUp;
  @override
  gestures get iType => OnTapDoubleUp.type;
  @override
  bool complete() {
    if (locked) return false;
    return super.complete() && y < SM.height / 2;
  }

  @override
  String promptText() {
    return "2x Tap Up!";
  }
}

class OnTapDoubleDown extends OnTap {
  static gestures type = gestures.onTapDoubleDown;
  @override
  gestures get iType => OnTapDoubleDown.type;
  @override
  bool complete() {
    if (locked) return false;
    return super.complete() && y > SM.height / 2;
  }

  @override
  String promptText() {
    return "2x Tap Down!";
  }
}

class OnTapDoubleLeft extends OnTap {
  static gestures type = gestures.onTapDoubleLeft;
  @override
  gestures get iType => OnTapDoubleLeft.type;
  @override
  bool complete() {
    if (locked) return false;
    return super.complete() && x < SM.width / 2;
  }

  @override
  String promptText() {
    return "2x Tap Left!";
  }
}

class OnTapDoubleRight extends OnTap {
  static gestures type = gestures.onTapDoubleRight;
  @override
  gestures get iType => OnTapDoubleRight.type;
  @override
  bool complete() {
    if (locked) return false;
    return super.complete() && x > SM.width / 2;
  }

  @override
  String promptText() {
    return "2x Tap Right!";
  }
}

class OnPan extends Gesture {
  static gestures type = gestures.onPan;
  @override
  gestures get iType => OnPan.type;

  bool stateDown = false;
  bool stateUp = false;
  double x = 0;
  double y = 0;
  double dx = 0;
  double dy = 0;

  @override
  void setState(List args) {
    int arg = 0;
    if (args[arg] != null) {
      stateDown = args[arg];
    }
    arg++;
    if (args[arg] != null) {
      stateUp = args[arg];
    }
    arg++;
    if (args[arg] != null) {
      x = args[arg][0];
      y = args[arg][1];
    }
    arg++;
    if (args[arg] != null) {
      dx = args[arg][0];
      dy = args[arg][1];
    }
  }

  @override
  void reset() {
    stateDown = false;
    stateUp = false;
    x = 0;
    y = 0;
    dx = 0;
    dy = 0;
  }

  @override
  bool complete() {
    if (locked) return false;
    return ((stateDown && stateUp) && (dx != 0 && dy != 0));
  }

  @override
  String toString() {
    return "<down:'${stateDown.toString()[0]}'><up:'${stateUp.toString()[0]}'><x:'${x.toInt()}',y:'${y.toInt()}'><dx:'${dx.toInt()}',dy:'${dy.toInt()}'>";
  }

  @override
  Image promptImage() {
    return Image.asset('${pIf}swipe.gif');
  }

  @override
  String promptAudioSrc() {
    return "swipe.mp3";
  }

  @override
  String promptText() {
    return "Swipe!";
  }
}

class OnPanUp extends OnPan {
  static gestures type = gestures.onPanUp;
  @override
  gestures get iType => OnPanUp.type;
  @override
  bool complete() {
    if (locked) return false;
    return super.complete() && (dy < 0) && (dx.abs() < dy.abs());
  }

  @override
  String promptText() {
    return "Swipe Up!";
  }
}

class OnPanDown extends OnPan {
  static gestures type = gestures.onPanDown;
  @override
  gestures get iType => OnPanDown.type;
  @override
  bool complete() {
    if (locked) return false;
    return super.complete() && (dy > 0) && (dx.abs() < dy.abs());
  }

  @override
  String promptText() {
    return "Swipe Down!";
  }
}

class OnPanLeft extends OnPan {
  static gestures type = gestures.onPanLeft;
  @override
  gestures get iType => OnPanLeft.type;
  @override
  bool complete() {
    if (locked) return false;
    return super.complete() && (dx < 0) && (dx.abs() > dy.abs());
  }

  @override
  String promptText() {
    return "Swipe Left!";
  }
}

class OnPanRight extends OnPan {
  static gestures type = gestures.onPanRight;
  @override
  gestures get iType => OnPanRight.type;
  @override
  bool complete() {
    if (locked) return false;
    return super.complete() && (dx > 0) && (dx.abs() > dy.abs());
  }

  @override
  String promptText() {
    return "Swipe Right";
  }
}

class Shakable extends ShakeDetector {
  Shakable.autoStart({required super.onPhoneShake}) : super.autoStart();
  Shakable.waitForStart({required super.onPhoneShake}) : super.waitForStart();

  @override
  double get shakeThresholdGravity => super.shakeThresholdGravity;
}

class OnShake extends Gesture {
  static gestures type = gestures.onShake;
  @override
  gestures get iType => OnShake.type;

  late ShakeDetector sd;

  double mx = 0;
  double nx = 0;
  double my = 0;
  double ny = 0;
  double mz = 0;
  double nz = 0;

  @override
  void loadSensor() {
    sd = ShakeDetector.waitForStart(onPhoneShake: () {
      mx = 1;
    });
    sd.startListening();
    /*
    userAccelerometerEvents.listen((UserAccelerometerEvent event) {
      double threshhold = 1;
      double x = 0, y = 0, z = 0;
      //print("${event.x}");
      if (event.x.abs() > threshhold) x = event.x;
      if (event.y.abs() > threshhold) x = event.y;
      if (event.z.abs() > threshhold) x = event.z;
      if (x.abs() > threshhold ||
          y.abs() > threshhold ||
          z.abs() > threshhold) {
        //gesturelist![gestures.onShake]?.setState(x, y, z);
      }
    });
    */
  }

  @override
  void unloadSensor() {
    sd.stopListening();
  }

  @override
  void reset() {
    mx = 0;
    nx = 0;
    my = 0;
    ny = 0;
    mz = 0;
    nz = 0;
  }

  @override
  bool complete() {
    if (locked) return false;
    return mx == 1;
  }

  @override
  Image promptImage() {
    return Image.asset('${pIf}shake.gif');
  }

  @override
  String promptAudioSrc() {
    return "shake.mp3";
  }

  @override
  String promptText() {
    return "Shake!";
  }
}
