import '../model/comment_model.dart';
import '../../../utils/app_common.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../network/network_utils.dart';
import '../model/medical_video_model.dart';

class VideoServiceApis {
  static const String getVideosEndPoint = 'patient/health-videos';

  static Future<List<MedicalVideo>> getHealthVideos({int page = 1}) async {
    try {
      final res = await handleResponse(
        await buildHttpResponse('$getVideosEndPoint?page=$page', method: HttpMethodType.GET)
      );
      if (res['data'] is List) {
        return (res['data'] as List).map((v) => MedicalVideo.fromJson(v)).toList();
      }
      return [];
    } catch (e) {
      log('getHealthVideos error: $e');
      throw e;
    }
  }

  static Future<void> likeVideo(int id) async {
    try {
      await handleResponse(
        await buildHttpResponse('$getVideosEndPoint/$id/like', method: HttpMethodType.POST)
      );
    } catch (e) {
      log('likeVideo error: $e');
    }
  }

  static Future<void> viewVideo(int id) async {
    try {
      await handleResponse(
        await buildHttpResponse('$getVideosEndPoint/$id/view', method: HttpMethodType.POST)
      );
    } catch (e) {
      log('viewVideo error: $e');
    }
  }

  static Future<List<CommentModel>> getVideoComments(int videoId) async {
    try {
      final res = await handleResponse(
        await buildHttpResponse('$getVideosEndPoint/$videoId/comments', method: HttpMethodType.GET)
      );
      if (res['data'] is List) {
        return (res['data'] as List).map((v) => CommentModel.fromJson(v)).toList();
      }
      return [];
    } catch (e) {
      log('getVideoComments error: $e');
      return [];
    }
  }

  static Future<void> postVideoComment(int videoId, String comment) async {
    try {
      final Map<String, dynamic> request = {
        'comment': comment,
        'user_id': loginUserData.value.id,
      };
      await handleResponse(
        await buildHttpResponse('$getVideosEndPoint/$videoId/comments', method: HttpMethodType.POST, request: request)
      );
    } catch (e) {
      log('postVideoComment error: $e');
      throw e;
    }
  }
}