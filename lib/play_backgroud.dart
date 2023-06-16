import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lmplayer/player/play_service.dart';

class PlayBackground extends StatefulWidget {
  final AudioPlayerService audioPlayerService;

   PlayBackground({Key? key, required this.audioPlayerService})
      : super(key: key);

  @override
  _PlayBackgroundState createState() => _PlayBackgroundState();
}

class _PlayBackgroundState extends State<PlayBackground> {
  String? backgroundImagePath;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ValueListenableBuilder(valueListenable: widget.audioPlayerService.coverImage, builder: (contex, value, child){
          return Image(
            image: AssetImage(value),
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
            alignment: Alignment.center,
          );
        }),
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: Container(
            color: Colors.black.withOpacity(0.2),
          ),
        ),
      ],
    );
  }
}
