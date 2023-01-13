import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:group5_project/classes_and_functions/audio_player.dart';
import 'package:group5_project/classes_and_functions/profile.dart';
import '../main.dart';

List<String> title = [
  'Music',
  'Sound FX',
  'Voice',
];

List<bool> onOrOff = [
  true, //music
  true, //sfx
  true, //voice
];

changes() {
  if(onOrOff[0] != profile.musicSetting || onOrOff[1] != profile.sfxSetting || onOrOff[2] != profile.voiceSetting) {
    applicableChanges = true;
  }
  else {
    applicableChanges = false;
  }
}

bool easyOrHard = false;
bool applicableChanges = false;

class settings_list extends StatefulWidget {
  //String sliderText = 'temp';
  int index = 0;

  settings_list({super.key, required this.index});

  @override
  _settings_listState createState() => _settings_listState();
}

class _settings_listState extends State<settings_list> {
  iconChange() {
    if (onOrOff[widget.index]) {
      return FontAwesomeIcons.volumeHigh;
    } else {
      return FontAwesomeIcons.volumeXmark;
    }
  }

  volumeControl() {
    setState(() {
      if (widget.index == 0) {
        if (!onOrOff[0]) {
          onOrOff[0] = true;
          preLoad.resumeMUSIC();
        }
        else {
          onOrOff[0] = false;
          preLoad.pauseMUSIC();
        }

      }
      else if (widget.index == 1) {
        if (!onOrOff[1]) {
          onOrOff[1] = true;
          preLoad.playSFX(Sfx.success);
        }
        else {
          onOrOff[1] = false;
        }
      }
      else if (widget.index == 2) {
        if (!onOrOff[2]) {
          onOrOff[2] = true;
          preLoad.playPROMPT('tap.mp3');
        }
        else {
          onOrOff[2] = false;
        }
      }
      changes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            const Expanded(
              flex: 6,
              child: SizedBox(width: 1),
            ),
            Text(
              title[widget.index],
              textAlign: TextAlign.center,
              style: GoogleFonts.amaticSc(
                color: const Color.fromARGB(255, 141, 240, 84),
                height: 1.5,
                fontWeight: FontWeight.bold,
                fontSize: 25,
                letterSpacing: 5,
              ),
            ),
            const Expanded(
              flex: 5,
              child: SizedBox(width: 1),
            ),
          ],
        ),
        Row(
          children: [
            const Expanded(
              flex: 1,
              child: SizedBox(width: 1),
            ),
            Expanded(
              flex: 6,
              child: FaIcon(
                iconChange(),
                color: const Color.fromARGB(255, 202, 20, 20),
                size: 50,
              ),
            ),
            Expanded(
              flex: 2,
              child: Transform.scale(
                scale: 1.5,
                child: Switch(
                  activeColor: const Color.fromARGB(255, 141, 240, 84),
                  activeTrackColor: const Color.fromARGB(255, 141, 240, 84),
                  inactiveThumbColor: Colors.blueGrey.shade600,
                  inactiveTrackColor: Colors.grey.shade400,
                  splashRadius: 60.0,
                  value: onOrOff[widget.index],
                  onChanged: (value) {
                    setState(() {
                      volumeControl();
                    });
                  },
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 25),
      ],
    );
  }
}
