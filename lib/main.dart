import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lmplayer/album_info.dart';
import 'package:lmplayer/play_backgroud.dart';
import 'package:lmplayer/play_control.dart';
import 'package:lmplayer/player/play_service.dart';
import 'package:lmplayer/playing_list.dart';
import 'package:lmplayer/top_bar.dart';
//widget Element renderObject
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '音乐播放器',
      home: const MusicPlayer(),
    );
  }
}

class MusicPlayer extends StatefulWidget {
  const MusicPlayer({Key? key}) : super(key: key);

  @override
  _MusicPlayerState createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  final ValueNotifier<Duration> currentTime = ValueNotifier(Duration.zero);
  final ValueNotifier<Duration> totalTime = ValueNotifier(Duration.zero);
  final ValueNotifier<bool> isPlaying = ValueNotifier(false);
  final ValueNotifier<bool> _isPlaylistVisible = ValueNotifier(false);

  late AudioPlayerService _audioPlayerService;

  @override
  void initState() {
    super.initState();
    _audioPlayerService = AudioPlayerService();
    _audioPlayerService.init();
    _audioPlayerService.coverImage.addListener(() {
      String path = _audioPlayerService.coverImage.value;
      // 根据封面图片路径执行所需的逻辑
    });
  }

  void onSeek(Duration value) {
    _audioPlayerService.seek(value);
  }

  void onPlayPause() {
    // 根据播放状态执行播放/暂停操作
  }

  void onNext() {
    _audioPlayerService.next();
  }

  void onPrevious() {
    _audioPlayerService.previous();
  }

  void onLoop() {
    _audioPlayerService.toggleLoopMode();
  }

  void onPlaylist() {
    setState(() {
      _isPlaylistVisible.value = !_isPlaylistVisible.value;
    });
  }

  @override
  void dispose() {
    _audioPlayerService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PlayBackground(audioPlayerService: _audioPlayerService),
          Column(
            children: [
              TopBar(
                onBackButtonPressed: () {
                  // 在按下返回按钮时执行的代码
                },
                onShareButtonPressed: () {
                  // 在按下分享按钮时执行的代码
                },
              ),
              Expanded(
                child: AlbumCoverView(
                  title: "曲名",
                  description: "描述",
                  audioPlayerService: _audioPlayerService,
                ),
              ),
              PlayControl(
                onPlaylist: onPlaylist,
                audioPlayerService: _audioPlayerService,
                onLoop: onLoop,
              ),
            ],
          ),
          if (_isPlaylistVisible.value)
            Positioned.fill(
              child: _buildPlaylistPage(),
            ),
        ],
      ),
    );
  }

  Widget _buildPlaylistPage() {
    return PlaylistPage(
      audioPlayerService: _audioPlayerService,
    );
  }
}
