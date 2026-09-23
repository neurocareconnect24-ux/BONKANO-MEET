import 'package:get/get.dart';
import 'model/medical_video_model.dart';
import 'services/video_apis.dart';

class VideosController extends GetxController {
  RxList<MedicalVideo> videos = <MedicalVideo>[].obs;
  RxBool isLoading = false.obs;
  RxInt currentPage = 1.obs;
  RxBool hasMoreData = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchVideos(isRefresh: true);
  }

  Future<void> fetchVideos({bool isRefresh = false}) async {
    if (isLoading.value) return;
    
    if (isRefresh) {
      currentPage(1);
      hasMoreData(true);
    } else {
      if (!hasMoreData.value) return;
      currentPage(currentPage.value + 1);
    }

    isLoading(true);
    try {
      final res = await VideoServiceApis.getHealthVideos(page: currentPage.value);
      if (isRefresh) {
        videos.assignAll(res);
      } else {
        videos.addAll(res);
      }
      if (res.isEmpty || res.length < 10) {
        hasMoreData(false); // assuming per_page is 10
      }
    } catch (e) {
      if (!isRefresh) {
        currentPage(currentPage.value - 1);
      }
    } finally {
      isLoading(false);
    }
  }

  void toggleLike(MedicalVideo video) {
    video.likesCount += 1; // Basic optimistic update (can implement unlike later if backend supports it)
    videos.refresh();
    VideoServiceApis.likeVideo(video.id);
  }

  void incrementView(MedicalVideo video) {
    video.viewsCount += 1;
    videos.refresh();
    VideoServiceApis.viewVideo(video.id);
  }
}