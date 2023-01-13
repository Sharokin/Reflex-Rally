import 'package:flutter/material.dart';
import 'package:group5_project/classes_and_functions/file.dart';
import 'package:group5_project/classes_and_functions/mySettingsList.dart';
import '../classes_and_functions/profile.dart';

bool devPageIsActive = false;
int devPageAccessorI = 5;
int devPageAccessorC = 0;

class DevPage extends StatefulWidget {
  const DevPage({super.key});

  @override
  State<DevPage> createState() => _DevPageState();
}

class _DevPageState extends State<DevPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: FractionallySizedBox(
                heightFactor: 0.9,
                widthFactor: 0.9,
                child: Column(
                  children: <Widget>[
                    Flexible(
                      child: FractionallySizedBox(
                        heightFactor: 0.3,
                        widthFactor: 1.0,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            side: const BorderSide(
                                color: Colors.black26, width: 2.0),
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () {
                            setState(() {
                              debugPrint(
                                  '==== Settings ===='
                                  + '\n' + 'Profile.musicSetting: ${profile.musicSetting}'
                                  + '\n' + 'Profile.sfxSetting: ${profile.sfxSetting}'
                                  + '\n' + 'Profile.voiceSetting: ${profile.voiceSetting}'
                                  + '\n' + 'Profile.difficultySetting: ${profile.difficultySetting}'
                                  + '\n' + 'Settings.musicSetting: ${onOrOff[0]}'
                                  + '\n' + 'Settings.sfxSetting: ${onOrOff[1]}'
                                  + '\n' + 'Settings.voiceSetting: ${onOrOff[2]}'
                                  + '\n' + 'Settings.difficultySetting: $easyOrHard'
                                  + '\n' + 'Applicablechanges: $applicableChanges'
                                  + '==== End of settings ===='
                              );
                            });
                          },
                          child: const Text(
                            'Print variables to console.',
                            textDirection: TextDirection.ltr,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Flexible(
                      child: FractionallySizedBox(
                        heightFactor: 0.3,
                        widthFactor: 1.0,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            side: const BorderSide(
                                color: Colors.black26, width: 2.0),
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () {
                            setState(() {
                              deleteFile();
                            });
                          },
                          child: const Text(
                            'Reset save file (Will exit app)',
                            textDirection: TextDirection.ltr,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
