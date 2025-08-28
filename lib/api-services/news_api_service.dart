import 'package:dio/dio.dart';

import '../models/newsListModel.dart';

class NewsApiService {
  final Dio _dio = Dio();
  final String apiKey = "2cb65261b4824c5ea12f327d313f46f8"; // your key
  final String baseUrl = "https://newsapi.org/v2";

  Future<List<Article>> fetchArticles(String category, {int page = 1}) async {
    try {
      final response = await _dio.get(
        "$baseUrl/top-headlines",
        queryParameters: {
          "country": "us",
          "category": category,
          "page": page,
          "pageSize": 30,
          "apiKey": apiKey,
        },
      );

      if (response.statusCode == 200) {
        final List articles = response.data['articles'];
        return articles.map((e) => Article.fromJson(e)).toList();
      } else {
        throw Exception("Failed with status: ${response.statusCode}");
      }
    } on DioException catch (e) {
      throw Exception("Dio error: ${e.message}");
    }
  }
}
