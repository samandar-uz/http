class Categorys {
  final String slug;
  final String name;
  final String url;

  Categorys({required this.slug, required this.name, required this.url});

  factory Categorys.fromJson(Map<String, dynamic> json) {
    return Categorys(
      slug: json['slug'] ?? '',
      name: json['name'] ?? '',
      url: json['url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'slug': slug, 'name': name, 'url': url};
  }
}
