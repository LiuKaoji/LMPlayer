import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lmplayer/utility/duration_utility.dart';
import 'package:lmplayer/player/play_service.dart';

class PlayControl extends StatefulWidget {
  final VoidCallback onLoop;
  final VoidCallback onPlaylist;
  final AudioPlayerService audioPlayerService;

  PlayControl({
    required this.onLoop,
    required this.onPlaylist,
    required this.audioPlayerService,
  });

  @override
  _PlayControlState createState() => _PlayControlState();
}

class _PlayControlState extends State<PlayControl> {
  late double currentValue;
  late Duration currentDuration;
  bool isDragging = false;

  @override
  void initState() {
    super.initState();
    currentValue = widget.audioPlayerService.progress.value;
    currentDuration = DurationFormatter.calculateDuration(
      currentValue,
      widget.audioPlayerService.totalTime.value,
    );
    widget.audioPlayerService.progress.addListener(progressListener);
  }

  void onSliderChanged(double newValue) {
    final newDuration = Duration(
      milliseconds: (widget.audioPlayerService.totalTime.value.inMilliseconds * newValue).round(),
    );
    setState(() {
      currentValue = newValue;
      currentDuration = newDuration;
    });
  }

  void onSliderDragEnd(_) {
    final newDuration = Duration(
      milliseconds: (widget.audioPlayerService.totalTime.value.inMilliseconds * currentValue).round(),
    );
    widget.audioPlayerService.seek(newDuration);
    setState(() {
      isDragging = false;
      widget.audioPlayerService.progress.addListener(progressListener);
    });
  }

  void onSliderDragStart(_) {
    setState(() {
      isDragging = true;
      widget.audioPlayerService.progress.removeListener(progressListener);
    });
  }

  void progressListener() {
    if (!isDragging) {
      setState(() {
        currentValue = widget.audioPlayerService.progress.value;
      });
    }
  }

  @override
  void dispose() {
    widget.audioPlayerService.progress.removeListener(progressListener);
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final iconSize = MediaQuery.of(context).size.width / 10;
    final playSize = iconSize * 2.0;

    return Container(
      padding: const EdgeInsets.fromLTRB(15, 15, 15, 40),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 45,  // 需要你自己设定一个合适的宽度
                child: ValueListenableBuilder<Duration>(
                  valueListenable: widget.audioPlayerService.currentTime,
                  builder: (context, value, child) => Text(
                    isDragging ?DurationFormatter.format(currentDuration):DurationFormatter.format(value),
                    style: TextStyle(color: Colors.white.withOpacity(0.6)),
                    textAlign: TextAlign.right,
                  ),
                ),
              ),
              SizedBox(width: 0),  // 可以根据需要增加或减少这个值，以便在文本和滑块之间增加一些间距
              Expanded(
                child: CupertinoSlider(
                  value: currentValue,
                  min: 0,
                  max: 1.0,
                  onChanged: onSliderChanged,  // 不再检查 isDragging 的值
                  onChangeStart: onSliderDragStart,
                  onChangeEnd: onSliderDragEnd,
                ),
              ),
              SizedBox(width: 8),  // 同上
              Container(
                width: 45,  // 同上
                child: ValueListenableBuilder<Duration>(
                  valueListenable: widget.audioPlayerService.totalTime,
                  builder: (context, value, child) => Text(
                    DurationFormatter.format(value),
                    style: TextStyle(color: Colors.white.withOpacity(0.6)),
                  ),
                ),
              ),
            ],
          ),

          Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
    ValueListenableBuilder<LoopMode>(
    valueListenable: widget.audioPlayerService.loopMode,
    builder: (context, mode, child) {
      return    GestureDetector(
        onTap: widget.onLoop,
        child: Icon(
          (mode == LoopMode.all) ?Icons.repeat:Icons.repeat_one,
          size: iconSize,
          color: Colors.white,
        ),
      );
    },
    ),
      GestureDetector(
        onTap: () async {
          await widget.audioPlayerService.previous();
        },
        child: Icon(
          Icons.skip_previous,
          size: iconSize,
          color: Colors.white,
        ),
      ),
      ValueListenableBuilder<bool>(
        valueListenable: widget.audioPlayerService.isPlaying,
        builder: (context, isPlaying, child) {
          return GestureDetector(
            onTap: () async {
              await widget.audioPlayerService.togglePlay();
            },
            child: Icon(
              isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
              size: playSize,
              color: Colors.white,
            ),
          );
        },
      ),
      GestureDetector(
        onTap: () async {
          await widget.audioPlayerService.next();
        },
        child: Icon(
          Icons.skip_next,
          size: iconSize,
          color: Colors.white,
        ),
      ),
      GestureDetector(
        onTap: widget.onPlaylist,
        child: Icon(
          Icons.list_rounded,
          size: iconSize,
          color: Colors.white,
        ),
      ),
    ],
    ),
        ],
      ),
    );
  }
}
