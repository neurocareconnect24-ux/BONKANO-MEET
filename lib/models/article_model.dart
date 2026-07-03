class ArticleModel {
  final int id;
  final String title;
  final String summary;
  final String content;
  final String imageUrl;
  final String date;
  final String author;

  ArticleModel({
    required this.id,
    required this.title,
    required this.summary,
    required this.content,
    required this.imageUrl,
    required this.date,
    required this.author,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      summary: json['summary'] ?? '',
      content: json['content'] ?? '',
      imageUrl: json['image_url'] ?? '',
      date: json['date'] ?? '',
      author: json['author'] ?? '',
    );
  }
}
