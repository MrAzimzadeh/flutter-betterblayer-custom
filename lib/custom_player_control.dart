import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:testvideo/video_scrubber.dart';

class CustomPlayerControl extends StatelessWidget {
  const CustomPlayerControl(
      {required this.controller, super.key, required this.videoKey});

  final BetterPlayerController controller;
  final GlobalKey videoKey;

  void _onTap() {
    controller.setControlsVisibility(true);
    if (controller.isPlaying()!) {
      controller.pause();
    } else {
      controller.play();
    }
  }

  void _controlVisibility() {
    controller.setControlsVisibility(true);
    Future.delayed(const Duration(seconds: 3))
        .then((value) => controller.setControlsVisibility(false));
  }

  String _formatDuration(Duration? duration) {
    if (duration != null) {
      String minutes = duration.inMinutes.toString().padLeft(2, '0');
      String seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
      return '$minutes:$seconds';
    } else {
      return '00:00';
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _controlVisibility,
      child: StreamBuilder(
        initialData: false,
        stream: controller.controlsVisibilityStream,
        builder: (context, snapshot) {
          return Stack(
            children: [
              Visibility(
                visible: snapshot.data!,
                child: Positioned(
                  child: Center(
                    child: FloatingActionButton(
                      onPressed: _onTap,
                      backgroundColor: Colors.black.withOpacity(0.7),
                      child: controller.isPlaying()!
                          ? const Icon(
                        Icons.pause,
                        color: Colors.white,
                        size: 40,
                      )
                          : const Icon(
                        Icons.play_arrow_rounded,
                        color: Colors.white,
                        size: 50,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 10,
                right: 10,
                bottom: 40,
                child: ValueListenableBuilder(
                  valueListenable: controller.videoPlayerController!,
                  builder: (context, value, child) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.black.withOpacity(0.5),
                              ),
                              child: Text(
                                '${_formatDuration(value.position)}/${_formatDuration(value.duration)}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () async {
                                controller.toggleFullScreen();
                              },
                              icon: const Icon(
                                Icons.fullscreen_rounded,
                                size: 24,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        VideoScrubber(
                          controller: controller,
                          playerValue: value,
                        ),
                      ],
                    );
                  },
                ),
              ),

              Positioned(
                right: 20,
                bottom: 90,
                child: IconButton(
                  onPressed: () {
                    controller.enablePictureInPicture(videoKey);
                  },
                  icon: const Icon(
                    Icons.picture_in_picture_alt_rounded,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
