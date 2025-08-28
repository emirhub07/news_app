import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../custom-widget/news_card.dart';
import '../custom-widget/search_bar.dart';
import '../providers/news_provider.dart';

import 'article_screen.dart';

class TopHeadlineScreen extends StatefulWidget {
  const TopHeadlineScreen({super.key});

  @override
  State<TopHeadlineScreen> createState() => _TopHeadlineScreenState();
}

class _TopHeadlineScreenState extends State<TopHeadlineScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    Future.microtask(
            () => Provider.of<NewsProvider>(context, listen: false).fetchNews(""));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Called when search should be applied (controller or clear triggers it).
  void _applySearch(String q) {
    setState(() {
      _searchQuery = q.toLowerCase();
    });
  }

  @override
  Widget build(BuildContext context) {
    final newsProvider = Provider.of<NewsProvider>(context);
    final articles = newsProvider.articles;

    // local filtering (case-insensitive)
    final filteredArticles = (_searchQuery.isEmpty)
        ? articles
        : articles.where((a) {
      final title = a.title.toLowerCase();
      final desc = a.description.toLowerCase();
      final content = a.content.toLowerCase();
      return title.contains(_searchQuery) ||
          desc.contains(_searchQuery) ||
          content.contains(_searchQuery);
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Top Headlines')),
      body: Column(
        children: [
          CustomSearchBar(
            controller: _searchController,
            onSearch: (q) {
              // CustomSearchBar already enforces >=3 chars logic and calls onSearch('')
              _applySearch(q);
            },
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                await Provider.of<NewsProvider>(context, listen: false)
                    .fetchNews("");
              },
              child: newsProvider.isLoading && articles.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : newsProvider.errorMessage.isNotEmpty
                  ? Center(child: Text(newsProvider.errorMessage))
                  : filteredArticles.isEmpty
                  ? const Center(child: Text('No results found'))
                  : ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: filteredArticles.length,
                itemBuilder: (context, index) {
                  final article = filteredArticles[index];
                  return NewsCard(
                    article: article,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              ArticleScreen(article: article),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
