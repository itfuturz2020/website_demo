import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:website_demo/classList.dart';

class services {
  final String base_url = "api.nytimes.com";
  static const String API_KEY = "7PJzUh5lZGjvih4ClLeJvz5sH1yRn04x";

  Future<List<Article>> fetchArticlesBySection(String section) async {
    Map<String, String> parameters = {
      'api-key': API_KEY,
    };
    Uri uri = Uri.https(
      base_url,
      '/svc/topstories/v2/$section.json',
      parameters,
    );
    try {
      var response = await http.get(uri);
      Map<String, dynamic> data = json.decode(response.body);
      List<Article> articles = [];
      data['results'].forEach(
        (articleMap) => articles.add(Article.fromMap(articleMap)),
      );
      return articles;
    } catch (err) {
      throw err.toString();
    }
  }
}
