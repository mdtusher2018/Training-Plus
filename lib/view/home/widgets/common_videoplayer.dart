// ignore_for_file: must_be_immutable

import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:training_plus/core/utils/colors.dart';
import 'package:training_plus/core/utils/helper.dart';
import 'package:video_player/video_player.dart';

/// Stateful widget to fetch and then display video content.
class commonVideoPlayer extends StatefulWidget {
  String videoUrl;
  bool isLocal;
  commonVideoPlayer({super.key, required this.videoUrl, this.isLocal = false});

  @override
  _commonVideoPlayerState createState() => _commonVideoPlayerState();
}

class _commonVideoPlayerState extends State<commonVideoPlayer> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();

    final uri = Uri.parse(getFullImagePath(widget.videoUrl));
    log(uri.toString() + ".......................");

    if (widget.videoUrl.isEmpty || uri.scheme == 'http') {
      widget.videoUrl =
          "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4";
    }

    if (widget.isLocal) {
      // If the video is local, use the file path
      _controller = VideoPlayerController.file(File(widget.videoUrl))
        ..setLooping(true)
        ..initialize().then((_) {
          setState(() {});
          _controller.pause(); // Automatically play the video once initialized
        });
    } else {
      _controller = VideoPlayerController.networkUrl(
          Uri.parse(getFullImagePath(widget.videoUrl)))
        ..setLooping(true)
        ..initialize().then((_) {
          setState(() {});
          _controller.pause(); // Automatically play the video once initialized
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: Stack(
              children: [
                VideoPlayer(_controller),
                Center(
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _controller.value.isPlaying
                            ? _controller.pause()
                            : _controller.play();
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color:   _controller.value.isPlaying?Colors.transparent: AppColors.textPrimary.withOpacity(0.7),
                        shape: BoxShape.circle
                      ),
                      child: Icon(
                        _controller.value.isPlaying
                            ? Icons.pause
                            : Icons.play_arrow,
                            color:_controller.value.isPlaying?AppColors.white.withOpacity(0.1): AppColors.white,
                            size: 48,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        : Center(child: CircularProgressIndicator());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}




