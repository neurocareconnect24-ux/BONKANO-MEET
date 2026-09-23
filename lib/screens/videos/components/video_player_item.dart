import 'package:share_plus/share_plus.dart';
import 'comments_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../model/medical_video_model.dart';
import '../videos_controller.dart';
import 'package:get/get.dart';

class VideoPlayerItem extends StatefulWidget {
  final MedicalVideo video;
  final VideosController controller;

  const VideoPlayerItem({Key? key, required this.video, required this.controller}) : super(key: key);

  @override
  State<VideoPlayerItem> createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  late VideoPlayerController _videoController;
  bool _isInitialized = false;
  bool _hasViewed = false;

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.networkUrl(Uri.parse(widget.video.videoUrl))
      ..initialize().then((_) {
        setState(() {
          _isInitialized = true;
        });
        _videoController.setLooping(true);
      });
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    if (info.visibleFraction > 0.7) {
      if (_isInitialized) {
        _videoController.play();
        if (!_hasViewed) {
          _hasViewed = true;
          widget.controller.incrementView(widget.video);
        }
      }
    } else {
      if (_isInitialized) {
        _videoController.pause();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key(widget.video.id.toString()),
      onVisibilityChanged: _onVisibilityChanged,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Video layer
          GestureDetector(
            onTap: () {
              if (_videoController.value.isPlaying) {
                _videoController.pause();
              } else {
                _videoController.play();
              }
            },
            child: _isInitialized
                ? FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: _videoController.value.size.width,
                      height: _videoController.value.size.height,
                      child: VideoPlayer(_videoController),
                    ),
                  )
                : const Center(child: CircularProgressIndicator(color: Colors.white)),
          ),
          
          // Gradient Overlay
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 250,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black.withOpacity(0.8), Colors.transparent],
                ),
              ),
            ),
          ),

          // Content Layer (Doctor Info & Actions)
          Positioned(
            bottom: 100, // Above bottom nav
            left: 16,
            right: 80,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(widget.video.doctorImage.isNotEmpty ? widget.video.doctorImage : 'https://via.placeholder.com/150'),
                    ),
                    10.width,
                    Text(
                      'Dr. ',
                      style: boldTextStyle(color: Colors.white, size: 16),
                    ).expand(),
                  ],
                ),
                4.height,
                Text(
                  widget.video.doctorSpeciality,
                  style: secondaryTextStyle(color: Colors.white70),
                ),
                10.height,
                Text(
                  widget.video.title,
                  style: boldTextStyle(color: Colors.white, size: 14),
                ),
                4.height,
                Text(
                  widget.video.description,
                  style: primaryTextStyle(color: Colors.white, size: 13),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // Actions Layer (Right side)
          Positioned(
            bottom: 100,
            right: 16,
            child: Column(
              children: [
                GestureDetector(
                  onTap: () => widget.controller.toggleLike(widget.video),
                  child: Column(
                    children: [
                      const Icon(Icons.favorite, color: Colors.redAccent, size: 35),
                      Text(widget.video.likesCount.toString(), style: boldTextStyle(color: Colors.white)),
                    ],
                  ),
                ),
                20.height,
                Column(
                  children: [
                    const Icon(Icons.remove_red_eye, color: Colors.white, size: 30),
                      Text(widget.video.viewsCount.toString(), style: boldTextStyle(color: Colors.white)),
                    ],
                  ),
                  20.height,
                  Column(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.comment, color: Colors.white, size: 30),
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (context) => CommentsBottomSheet(video: widget.video),
                          );
                        },
                      ),
                      Text(widget.video.commentsCount.toString(), style: boldTextStyle(color: Colors.white)),
                    ],
                  ),
                  10.height,
                Column(
                  children: [
                    IconButton(
                        icon: const Icon(Icons.share, color: Colors.white, size: 30),
                        onPressed: () {
                          Share.share('D\u00e9couvrez ce conseil sant\u00e9 de ${widget.video.doctorName} sur Bonkano :\n${widget.video.shareUrl}', subject: widget.video.title);
                        },
                      ),
                      Text('Partager', style: boldTextStyle(color: Colors.white, size: 12)),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}