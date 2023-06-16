import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../model/MusicInfo.dart';
import 'dart:convert';
import 'package:audio_session/audio_session.dart';

import 'ios_command_channel.dart';

class MusicInfoLoader {
  static Future<List<MusicInfo>> loadFromJson(String assetPath) async {
    final jsonString = await rootBundle.loadString(assetPath);
    final jsonData = jsonDecode(jsonString) as List;
    List<MusicInfo> musicInfoList = [];
    for (var album in jsonData) {
      var albumMusicInfo = album['musicInfo'] as List;
      musicInfoList.addAll(
          albumMusicInfo.map((item) => MusicInfo.fromJson(item)).toList());
    }
    return musicInfoList;
  }
}

class AudioPlayerService {
  final _player = AudioPlayer();
  List<MusicInfo> _playlist = [];
  List<MusicInfo> get playlist => _playlist;

  ValueNotifier<int> _currentMusicIndex = ValueNotifier<int>(0);
  ValueNotifier<int> get currentMusicIndex => _currentMusicIndex;
  MusicInfo? _currentMusicInfo;
  ValueNotifier<bool> _isPlaying = ValueNotifier<bool>(false);
  ValueNotifier<bool> get isPlaying => _isPlaying;
  ValueNotifier<Duration> currentTime = ValueNotifier<Duration>(Duration.zero);
  ValueNotifier<Duration> totalTime = ValueNotifier<Duration>(Duration.zero);
  ValueNotifier<double> progress = ValueNotifier<double>(0);
  ValueNotifier<String> _songTitle = ValueNotifier<String>("标题");
  ValueNotifier<String> get songTitle => _songTitle;
  ValueNotifier<String> _description = ValueNotifier<String>("描述");
  ValueNotifier<String> get description => _description;
  ValueNotifier<String> _coverImage = ValueNotifier<String>('assets/images/cover.jpeg');
  ValueNotifier<String> get coverImage => _coverImage;
  ValueNotifier<LoopMode> _loopMode = ValueNotifier<LoopMode>(LoopMode.all);
  ValueNotifier<LoopMode> get loopMode => _loopMode;

  AudioPlayerService() {
    _player.positionStream.listen((position) {
      currentTime.value = position;
      final duration = _player.duration;
      if (position != null && duration != null) {
        final progressValue = position.inMilliseconds / duration.inMilliseconds;
        progress.value = progressValue;
      }
    });

    _player.playerStateStream.listen((playerState) {
      _isPlaying.value = playerState.playing;
      _handlePlayerState(playerState);
    });
  }

  get musicList => musicList;

  init() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.music());

    final musicInfoList = await MusicInfoLoader.loadFromJson('assets/music/music_info.json');
    setPlaylist(musicInfoList);
    playAtIndex(0); //加载列表完成 播放第一个
  }

  // 设置播放列表
  void setPlaylist(List<MusicInfo> playlist) {
    _playlist = playlist;
  }

  // 加载指定索引的音乐资源
  Future<void> loadAudioFromAsset(int index) async {
    final basePath = 'assets/music/${_playlist[index].albumName}/';
    final audioPath = '${basePath}${_playlist[index].title}';
    final coverPath = '${basePath}${_playlist[index].cover}';
    await _player.setAsset(audioPath);
    _player.setLoopMode(_loopMode.value);
    _currentMusicInfo = _playlist[index];
    _currentMusicIndex.value = index;

    final title = _playlist[index].title;
    final album = _playlist[index].albumName;
    _songTitle.value = title;
    _description.value = "专辑: RPM $album";
    _coverImage.value = coverPath;

    final duration = _player.duration;
    if (duration != null) {
      totalTime.value = duration;
    }
  }

  Future<void> togglePlay() async {
    if (_player.playing) {
      await pause();
    } else {
      await play();
    }
  }

  Future<void> play() async {
    await _updatePlayerState(_player.play);
  }

  Future<void> pause() async {
    await _updatePlayerState(_player.pause);
  }

  Future<void> stop() async {
    await _updatePlayerState(_player.stop);
  }

  Future<void> next() async {
    if (_currentMusicInfo == null) return;
    final currentIndex = _playlist.indexOf(_currentMusicInfo!);
    final nextIndex = (currentIndex + 1) % _playlist.length;
    await playAtIndex(nextIndex);
  }

  Future<void> previous() async {
    if (_currentMusicInfo == null) return;
    final currentIndex = _playlist.indexOf(_currentMusicInfo!);
    final previousIndex = currentIndex - 1 < 0
        ? _playlist.length - 1
        : currentIndex - 1;
    await playAtIndex(previousIndex);
  }

  // 根据索引播放音乐
  Future<void> playAtIndex(int index) async {
    await loadAudioFromAsset(index);
    await play();
  }

  // 随机播放
  Future<void> playRandom() async {
    final currentIndex = _currentMusicIndex.value;
    final playlistLength = _playlist.length;

    final random = Random();
    int randomIndex;
    do {
      randomIndex = random.nextInt(playlistLength);
    } while (playlistLength > 1 && randomIndex == currentIndex);

    await playAtIndex(randomIndex);
  }


  Future<void> seek(Duration position) async {
    await _player.seek(position);
  }

  Future<void> toggleLoopMode() async {
    if (_loopMode.value == LoopMode.all) {
      await _player.setLoopMode(LoopMode.one);
      _loopMode.value = LoopMode.one;
    } else {
      await _player.setLoopMode(LoopMode.all);
      _loopMode.value = LoopMode.all;
    }
  }

  Future<void> dispose() async {
    await _player.dispose();
    _isPlaying.dispose();
    _currentMusicIndex.dispose();
  }

  Future<void> _updatePlayerState(Future Function() stateChanger) async {
    try {
      await stateChanger();
    } catch (e) {
      print(e);
    }
  }

  void _handlePlayerState(PlayerState playerState) {
    if (playerState.processingState == ProcessingState.completed) {
      switch (_player.loopMode) {
        case LoopMode.one:
          playAtIndex(_currentMusicIndex.value);
          print("complete and repeat one");
          break;
        case LoopMode.all:
          next();
          print("complete and play next");
          break;
        default:
          break;
      }
    }
  }
}
