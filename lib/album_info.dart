import 'dart:math';
import 'package:flutter/material.dart';
import 'package:lmplayer/player/play_service.dart';

class AlbumCoverView extends StatefulWidget {
  final String title;
  final String description;
  final AudioPlayerService audioPlayerService;

  AlbumCoverView({
    required this.title,
    required this.description,
    required this.audioPlayerService,
  });

  @override
  _AlbumCoverViewState createState() => _AlbumCoverViewState();
}

class _AlbumCoverViewState extends State<AlbumCoverView>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    );
    if (widget.audioPlayerService.isPlaying.value) {
      controller.repeat();
    }

    widget.audioPlayerService.isPlaying.addListener(() {
      if (widget.audioPlayerService.isPlaying.value) {
        controller.repeat();
      } else {
        controller.stop();
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    widget.audioPlayerService.isPlaying.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final outerWidth = MediaQuery.of(context).size.width * 1.0;
    final width = outerWidth * 0.7;
    final height = width;

    return Container(
      padding: const EdgeInsets.only(bottom: 20), // Adjust the padding here
      child: Column(
        children: <Widget>[
          Container(
            width: outerWidth,
            height: outerWidth,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Positioned(
                  top: 0,
                  child: Container(
                    width: width,
                    height: height,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.black.withAlpha(60),
                        width: 12.0,
                      ),
                    ),
                    child: AnimatedBuilder(
                      animation: controller,
                      builder: (context, child) {
                        return Transform.rotate(
                          angle: controller.value * 2 * pi,
                          child: ClipOval(
                            child: ValueListenableBuilder(
                              valueListenable:
                              widget.audioPlayerService.coverImage,
                              builder: (context, value, child) {
                                return CircleAvatar(
                                  backgroundImage: AssetImage(value),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 0),
          ValueListenableBuilder(valueListenable: widget.audioPlayerService.songTitle, builder: (context, value, child){
            return Text(
              value,
              style: TextStyle(
                color: Colors.white,
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            );
          }),
          const SizedBox(height: 10),
          ValueListenableBuilder(valueListenable: widget.audioPlayerService.description, builder: (context, value, child){
            return Text(
              value,
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            );
          }),
        ],
      ),
    );
  }
}
