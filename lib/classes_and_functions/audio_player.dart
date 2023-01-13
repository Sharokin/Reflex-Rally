import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'mySettingsList.dart';

class AudioManager {
  AudioPlayer _playerMusic = AudioPlayer();
  AudioPlayer _playerSfx = AudioPlayer();
  AudioPlayer _playerPrompt = AudioPlayer();

  int index = 0;

  List<double> volume = [1, 1, 1, 1];

  AudioManager() {
    _playerMusic = AudioPlayer();
    _playerSfx = AudioPlayer();
    _playerPrompt = AudioPlayer();

    _playerMusic.onPlayerComplete
      .listen((event) {
        playMUSIC(Music.startTheme);
      });
  }

  Future<void> playSFX(Sfx type) async {
    if (!onOrOff[1]) return;
    final sfxList = sounds(type);
    final filename = sfxList[index];

    if (_playerSfx.state == PlayerState.playing) await _playerSfx.stop();

    await _playerSfx.play(AssetSource('audio/sfx/$filename'),
        volume: (volume[0] * volume[2]));
  }

  Future<void> playSFX_TEST(String type) async {
    if (!onOrOff[1]) return;

    if (_playerSfx.state == PlayerState.playing) await _playerSfx.stop();

    await _playerSfx.play(AssetSource('audio/sfx/$type'));
  }

  Future<void> playMUSIC(Music type) async {
    final musicList = musicThemes(type);
    final filename = musicList[index];

    await _playerMusic.play(AssetSource('audio/music/$filename'),
        volume: (volume[0] * volume[1]));

    if(!onOrOff[0]) {
      pauseMUSIC();
    }
  }

  Future<void> playPROMPT(String type) async {
    if (!onOrOff[0]) return;

    if (!onOrOff[2]) return;

    await _playerPrompt.play(AssetSource('audio/prompt/$type'),
        volume: (volume[0] * volume[1]));
  }

  Future<void> preloadSFX() async {
    await AudioCache.instance.loadAll(
        Sfx.values.expand(sounds).map((path) => 'audio/sfx/$path').toList());
  }

  Future<void> preloadMUSIC() async {
    await AudioCache.instance.loadAll(Music.values
        .expand(musicThemes)
        .map((path) => 'audio/music/$path')
        .toList());
  }

  Future<void> preloadPROMPT() async {
    await AudioCache.instance.loadAll(AudioPrompt.values
        .expand(audioPrompts)
        .map((path) => 'audio/prompt/$path')
        .toList());
  }

  Future<void> pauseMUSIC() async {
    if (onOrOff[0]) return;
    await _playerMusic.pause();
  }

  Future<void> resumeMUSIC() async {
    if (!onOrOff[0]) return;
    onOrOff[0] = true;
    await _playerMusic.resume();
  }

  void dispose() {
    _playerMusic.dispose();
    _playerSfx.dispose();
  }
}

enum Music {
  startTheme,
}

List<String> musicThemes(Music type) {
  switch (type) {
    case Music.startTheme:
      return const ['reflexrally.mp3'];
  }
}

enum Sfx {
  win,
  success,
  fail,
  combo,
}

List<String> sounds(Sfx type) {
  switch (type) {
    case Sfx.win:
      return const ['win.mp3'];
    case Sfx.success:
      return const ['success.mp3'];
    case Sfx.fail:
      return const ['fail.mp3'];
    case Sfx.combo:
      return const ['combo.mp3'];
  }
}

enum AudioPrompt {
  swipe,

  tap,
  doubleTap,
  shake,
}

List<String> audioPrompts(AudioPrompt type) {
  switch (type) {
    case AudioPrompt.swipe:
      return const ['gestures.onPan.mp3'];
    case AudioPrompt.tap:
      return const ['gestures.onTap.mp3'];
    case AudioPrompt.doubleTap:
      return const ['gestures.onTapDouble.mp3'];
    case AudioPrompt.shake:
      return const ['gestures.onShake.mp3'];
  }
}
