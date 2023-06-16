// NativeCommandController.dart
import 'package:flutter/services.dart';
import 'package:lmplayer/player/play_service.dart';

class NativeCommandController {
  static const _channel = MethodChannel('com.example.app/audio');

  final AudioPlayerService _playerService;

  NativeCommandController(this._playerService) {
    _channel.setMethodCallHandler(_handleMethodCall);
  }

  Future<dynamic> _handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case "play":
        await _playerService.play();
        break;
      case "pause":
        await _playerService.pause();
        break;
      case "next":
        await _playerService.next();
        break;
      case "previous":
        await _playerService.previous();
        break;
      case "seekTo":
        int positionMillis = call.arguments;
        await _playerService.seek(Duration(milliseconds: positionMillis));
        break;
      default:
        throw MissingPluginException('没有实现的方法: ${call.method}');
    }
  }

  Future<void> updateNowPlayingInfo() async {
    try {
      await _channel.invokeMethod('updateNowPlayingInfo', {
        "title": _playerService.songTitle.value,
        "artist": _playerService.description.value,
        "coverImage": _playerService.coverImage.value,
        "duration": _playerService.totalTime.value.inMilliseconds,
        "position": _playerService.currentTime.value.inMilliseconds,
      });
    } on PlatformException catch (e) {
      print("Failed to update now playing info: '${e.message}'.");
    }
  }

  Future<void> updateNowPlayingInfoTime() async {
    try {
      await _channel.invokeMethod('updateNowPlayingInfoTime', {
        "position": _playerService.currentTime.value.inMilliseconds,
      });
    } on PlatformException catch (e) {
      print("Failed to update now playing info: '${e.message}'.");
    }
  }
}
