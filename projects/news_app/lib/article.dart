class Article {
  final String title;
  final String description;
  final String url;
  final String? imageUrl;
  Article(
      {required this.title,
      required this.description,
      this.imageUrl,
      required this.url});
  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
        title: json['title'] ?? 'No title',
        description: json['description'] ?? '',
        url: json['url'],
        imageUrl: json['urlToImage']);
  }
}
