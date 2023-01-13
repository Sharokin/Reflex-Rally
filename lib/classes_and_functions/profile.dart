import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:group5_project/classes_and_functions/mySettingsList.dart';
import 'package:group5_project/pages/home_page.dart';
import 'file.dart';

Profile profile = Profile();

class ScoreBuilder extends StatelessWidget {
  final Score score;
  final int index;

  ScoreBuilder({required this.score, required this.index});

  @override
  Widget build(BuildContext context) {
    return Text(
      '${index+1}. ${score.toString()}',
      textAlign: TextAlign.left,
      style: GoogleFonts.bangers(
        color: Colors.white,
        fontSize: 30,
        letterSpacing: 5,
      ),
    );
  }
}

class Profile {
  Profile() {}

  List<Score> easy_scores = [];
  List<Score> hard_scores = [];

  int scoreLatest = 0;

  bool musicSetting = true;
  bool sfxSetting = true;
  bool voiceSetting = true;
  bool difficultySetting = false;

  static Future<Profile> init() async {
    profile = await readData();

    onOrOff[0] = profile.musicSetting;
    onOrOff[1] = profile.sfxSetting;
    onOrOff[2] = profile.voiceSetting;

    easyOrHard = profile.difficultySetting;

    return profile;
  }

  isEasyTopScore() {
    return profile.easy_scores.isEmpty && profile.hard_scores.isEmpty ? null
        : profile.easy_scores.isEmpty ? false
        : profile.hard_scores.isEmpty ? true
        : profile.hard_scores.first.score < profile.easy_scores.first.score;
  }

  tryInsertScore(Score score, bool isHard) {

    if(!isHard) {
      if(easy_scores.isEmpty) {
        easy_scores.add(score);
        writeData();
      }
      else {
        if(easy_scores.last.score < score.score) {
          easy_scores.insert(easy_scores.indexOf(easy_scores.firstWhere((element) => element.score < score.score)), score);
        }
        else {
          easy_scores.add(score);
        }
        if(easy_scores.length > 10) {
          easy_scores.remove(easy_scores.last);
        }
        writeData();
      }
    }
    else {
      if(hard_scores.isEmpty) {
        hard_scores.add(score);
        writeData();
      }
      else {
        if(hard_scores.last.score < score.score) {
          hard_scores.insert(hard_scores.indexOf(hard_scores.firstWhere((element) => element.score < score.score)), score);
        }
        else {
          hard_scores.add(score);
        }
        if(hard_scores.length > 10) {
          hard_scores.remove(hard_scores.last);
        }
        writeData();
      }
    }
    scoreLatest = score.score;
    easyToggle = profile.isEasyTopScore() ?? true;
  }

  static saveSettings() {
    if(applicableChanges) {
      profile.musicSetting = onOrOff[0];
      profile.sfxSetting = onOrOff[1];
      profile.voiceSetting = onOrOff[2];
      profile.difficultySetting = easyOrHard;
      applicableChanges = false;
      writeData();
    }
  }

  Profile.fromJson(Map<String, dynamic> json)
    : difficultySetting = json['difficultySetting'],
      musicSetting = json['musicSetting'],
      sfxSetting = json['sfxSetting'],
      voiceSetting = json['voiceSetting'],
      easy_scores = List<dynamic>.from(json['easyScores']).map((i) => Score.fromJson(i)).toList(),
      hard_scores = List<dynamic>.from(json['hardScores']).map((i) => Score.fromJson(i)).toList();

  Map<String, dynamic> toJson() => {
    'difficultySetting': easyOrHard,
    'musicSetting': onOrOff[0],
    'sfxSetting': onOrOff[1],
    'voiceSetting': onOrOff[2],
    'easyScores': easy_scores.map((item) => item.toJson()).toList(),
    'hardScores': hard_scores.map((item) => item.toJson()).toList(),
  };
}

class Score {
  final int score;
  final String dateTime;

  Score(this.score, this.dateTime);

  @override
  String toString() {
    return '$score';
  }

  getDate() {
    return DateTime.parse(dateTime);
  }

  Score.fromJson(Map<String, dynamic> json) : score = json['score'], dateTime = json['date'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['score'] = score;
    data['date'] = dateTime.toString();
    return data;
  }
}
