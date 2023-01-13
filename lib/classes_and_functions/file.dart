import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:group5_project/classes_and_functions/profile.dart';
import 'package:path_provider/path_provider.dart';

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

Future<File> get _localFile async {
  final path = await _localPath;
  return File('$path/gamedata.json');
}

void deleteFile() async {
  final file = await _localFile;
  file.delete(recursive: false);
  SystemNavigator.pop();
}

Future<File> writeData() async {
  final file = await _localFile;
  return file.writeAsString(json.encode(profile.toJson()));
}

Future<Profile> readData() async {
  File file = await _localFile;
  String fileContent;
  Profile save = profile;

  if(await file.exists()) {
    try {
      fileContent = await file.readAsString();
      final Map<String, dynamic> rawJson = jsonDecode(fileContent);
      save = Profile.fromJson(rawJson);
    }
    catch (e) {}
  }
  return save;
}

