class Article {
  final String title;
  final String url;
  final String section;
  final String byline;
  final String publishedDate;

  Article(
      {required this.title,
      required this.url,
      required this.section,
      required this.byline,
      required this.publishedDate});

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'],
      url: json['url'],
      section: json['section'],
      byline: json['byline'],
      publishedDate: json['published_date'],
    );
  }
}
