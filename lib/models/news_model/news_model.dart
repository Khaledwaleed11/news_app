class NewsModel {
  final String? sourceName;
  final String? author;
  final String? title;
  final String? description;
  final String? url;
  final String? urlToImage;
  final String? publishedAt;
  final String? content;

  const NewsModel({
    this.sourceName,
    this.author,
    this.title,
    this.description,
    this.url,
    this.urlToImage,
    this.publishedAt,
    this.content,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    final source = json['source'];
    return NewsModel(
      sourceName: source is Map ? source['name']?.toString() : null,
      author: json['author']?.toString(),
      title: json['title']?.toString(),
      description: json['description']?.toString(),
      url: json['url']?.toString(),
      urlToImage: json['urlToImage']?.toString(),
      publishedAt: json['publishedAt']?.toString(),
      content: json['content']?.toString(),
    );
  }
}
