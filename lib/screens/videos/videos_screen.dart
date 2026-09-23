import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../utils/colors.dart';
import 'videos_controller.dart';
import 'components/video_player_item.dart';

class VideosScreen extends StatelessWidget {
  VideosScreen({super.key});

  final VideosController videosController = Get.put(VideosController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Conseils Santé', style: boldTextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Obx(() {
        if (videosController.isLoading.value && videosController.videos.isEmpty) {
          return const Center(child: CircularProgressIndicator(color: appColorPrimary));
        }

        if (videosController.videos.isEmpty) {
          return Center(
            child: Text(
              'Aucune vidéo pour le moment',
              style: boldTextStyle(color: Colors.white),
            ),
          );
        }

        return PageView.builder(
          scrollDirection: Axis.vertical,
          itemCount: videosController.videos.length,
          onPageChanged: (index) {
            if (index == videosController.videos.length - 2) {
              videosController.fetchVideos(); // Fetch next page when reaching the end
            }
          },
          itemBuilder: (context, index) {
            final video = videosController.videos[index];
            return VideoPlayerItem(
              video: video,
              controller: videosController,
            );
          },
        );
      }),
    );
  }
}