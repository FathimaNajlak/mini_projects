import 'dart:convert';

import 'package:news_app/article.dart';
import 'package:news_app/const/api_key.dart';
import 'package:http/http.dart' as http;

class NewsService {
  static const _apiKey = NEWS_API;
  static const String _everythingUrl = 'https://newsapi.org/v2/everything';
  Future<List<Article>> fetchTopHeadlines() async {
    final url =
        '$_everythingUrl?q=Kerala&language=en&sortBy=publishedAt&apiKey=$_apiKey';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List articlesJson = data['articles'];

      return articlesJson.map((json) => Article.fromJson(json)).toList();
    } else {
      throw Exception('failed to load news');
    }
  }
}
