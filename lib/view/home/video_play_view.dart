import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:training_plus/widgets/common_widgets.dart';
import 'package:training_plus/core/utils/colors.dart';

class VideoPlayerView extends StatefulWidget {
  const VideoPlayerView({super.key});

  @override
  State<VideoPlayerView> createState() => _VideoPlayerViewState();
}

class _VideoPlayerViewState extends State<VideoPlayerView> {
  late VideoPlayerController _controller;
  bool _isTheater = false;
  bool _hasCompleted = false; // track if already returned

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
      "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4",
    )
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      })
      ..addListener(_videoListener);
  }

  void _videoListener() {
    final isInitialized = _controller.value.isInitialized;
    if (!isInitialized) return;

    final position = _controller.value.position;
    final duration = _controller.value.duration;

    // Detect video completion
    if (duration != Duration.zero &&
        position >= duration &&
        !_hasCompleted) {
      _hasCompleted = true;
      Navigator.pop(context, true); // return true to ChaptersPage
    }
    setState(() {}); // update UI
  }

  @override
  void dispose() {
    _controller.removeListener(_videoListener);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isInitialized = _controller.value.isInitialized;
    final duration =
        isInitialized ? _controller.value.duration : Duration.zero;
    final position =
        isInitialized ? _controller.value.position : Duration.zero;
    final aspect = isInitialized
        ? _controller.value.aspectRatio
        : 16 / 9;

    return Scaffold(
      backgroundColor: AppColors.mainBG,
      appBar: AppBar(),
      body: Column(
        children: [
          // Video area
          if (isInitialized)
            AspectRatio(
              aspectRatio: aspect,
              child: Stack(
                children: [
                  VideoPlayer(_controller),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        _controller.value.isPlaying
                            ? _controller.pause()
                            : _controller.play();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: _controller.value.isPlaying
                              ? Colors.transparent
                              : AppColors.textPrimary.withOpacity(0.7),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _controller.value.isPlaying
                              ? Icons.pause
                              : Icons.play_arrow,
                          size: 48,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          else
            AspectRatio(
              aspectRatio: aspect,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),

          // Controls
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              children: [
                // Timeline slider
                Slider(
                  value: position.inMilliseconds
                      .toDouble()
                      .clamp(0.0, duration.inMilliseconds.toDouble()),
                  max: duration.inMilliseconds.toDouble(),
                  onChanged: isInitialized
                      ? (ms) {
                          _controller.seekTo(
                              Duration(milliseconds: ms.round()));
                        }
                      : null,
                  activeColor: AppColors.primary,
                  inactiveColor: Colors.grey.shade300,
                ),

                // Time stamps
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CommonText(formatDuration(position), size: 12),
                    CommonText(
                        "-" + formatDuration(duration - position),
                        size: 12),
                  ],
                ),
                CommonSizedBox(height: 8),

                // Buttons row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: isInitialized
                          ? () {
                              _controller.value.isPlaying
                                  ? _controller.pause()
                                  : _controller.play();
                            }
                          : null,
                      child: Icon(
                        _controller.value.isPlaying
                            ? Icons.pause_circle_filled
                            : Icons.play_circle_filled,
                        size: 32,
                        color: AppColors.primary,
                      ),
                    ),
                    GestureDetector(
                      onTap: isInitialized
                          ? () {
                              _controller.setVolume(
                                  _controller.value.volume > 0 ? 0 : 1);
                            }
                          : null,
                      child: Icon(
                        _controller.value.volume > 0
                            ? Icons.volume_up
                            : Icons.volume_off,
                        size: 28,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // TODO: implement fullscreen
                      },
                      child: const Icon(
                        Icons.fullscreen,
                        size: 28,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    GestureDetector(
                      onTap: () =>
                          setState(() => _isTheater = !_isTheater),
                      child: Icon(
                        _isTheater
                            ? Icons.theaters
                            : Icons.slideshow,
                        size: 28,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String formatDuration(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$m:$s";
  }
}
