import 'package:flutter/material.dart';
import 'package:lmplayer/model/MusicInfo.dart';
import 'package:lmplayer/player/play_service.dart';

class PlaylistPage extends StatefulWidget {
  final AudioPlayerService audioPlayerService;

  PlaylistPage({
    Key? key,
    required this.audioPlayerService,
  }) : super(key: key);

  @override
  _PlaylistPageState createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.audioPlayerService.currentMusicIndex.value;
    widget.audioPlayerService.currentMusicIndex.addListener(() {
      setState(() {
        _currentIndex = widget.audioPlayerService.currentMusicIndex.value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('播放列表'),
      ),
      body: ListView.builder(
        itemCount: widget.audioPlayerService.musicList.length,
        itemBuilder: (context, index) {
          final music = widget.audioPlayerService.musicList[index];
          return ListTile(
            title: Text(music.title),
            selected: index == _currentIndex,
            onTap: () {
              widget.audioPlayerService.playAtIndex(index);
            },
          );
        },
      ),
    );
  }
}
