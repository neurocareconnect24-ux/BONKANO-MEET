class CommentModel {
  final int id;
  final int userId;
  final String userName;
  final String userImage;
  final String userType;
  final String comment;
  final String createdAt;

  CommentModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userImage,
    required this.userType,
    required this.comment,
    required this.createdAt,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      userName: json['user_name'] ?? '',
      userImage: json['user_image'] ?? '',
      userType: json['user_type'] ?? '',
      comment: json['comment'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }
}
