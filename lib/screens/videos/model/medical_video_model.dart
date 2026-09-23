class MedicalVideo {
  final int id;
  final String title;
  final String description;
  final String videoUrl;
  final String? thumbnailUrl;
  final int duration;
  int viewsCount;
  int likesCount;
  int commentsCount;
  final String shareUrl;
  final int doctorId;
  final String doctorName;
  final String doctorSpeciality;
  final String doctorImage;
  final String createdAt;

  MedicalVideo({
    required this.id,
    required this.title,
    required this.description,
    required this.videoUrl,
    this.thumbnailUrl,
    required this.duration,
    required this.viewsCount,
    required this.likesCount,
    required this.commentsCount,
    required this.shareUrl,
    required this.doctorId,
    required this.doctorName,
    required this.doctorSpeciality,
    required this.doctorImage,
    required this.createdAt,
  });

  factory MedicalVideo.fromJson(Map<String, dynamic> json) {
    return MedicalVideo(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      videoUrl: json['video_url'] ?? '',
      thumbnailUrl: json['thumbnail_url'],
      duration: json['duration'] ?? 0,
      viewsCount: json['views_count'] ?? 0,
      likesCount: json['likes_count'] ?? 0,
      commentsCount: json['comments_count'] ?? 0,
      shareUrl: json['share_url'] ?? '',
      doctorId: json['doctor_id'] ?? 0,
      
      doctorName: (json['doctor_name'] ?? '').toString().replaceAll(RegExp(r'(Dr\.\s*|Dr\s*)'), '').trim(),

      doctorSpeciality: json['doctor_speciality'] ?? '',
      doctorImage: json['doctor_image'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }
}