import 'package:flutter/material.dart';
import '../api-services/news_api_service.dart';
import '../models/newsListModel.dart';

class NewsProvider with ChangeNotifier {
  final NewsApiService _newsApi = NewsApiService();

  List<Article> _articles = [];
  bool _isLoading = false;
  String _errorMessage = '';
  int _page = 1;

  List<Article> get articles => _articles;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> fetchNews(String category, {bool loadMore = false}) async {
    if (_isLoading) return;

    try {
      _isLoading = true;
      _errorMessage = '';
      notifyListeners();

      if (!loadMore) {
        _articles = [];
        _page = 1;
      } else {
        _page++;
      }

      final newArticles = await _newsApi.fetchArticles(category, page: _page);
      _articles.addAll(newArticles);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
