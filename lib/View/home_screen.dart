import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../custom-widget/category_selector.dart';
import '../custom-widget/news_card.dart';
import '../providers/news_provider.dart';

import 'article_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedCategory = 'business';

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<NewsProvider>(context, listen: false)
          .fetchNews(selectedCategory);
    });
  }

  @override
  Widget build(BuildContext context) {
    final newsProvider = Provider.of<NewsProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Top News")),
      body: RefreshIndicator(
        onRefresh: () => newsProvider.fetchNews(selectedCategory),
        child: Column(
          children: [
            CategorySelector(
              selectedCategory: selectedCategory,
              onCategorySelected: (categoryKey) {
                setState(() => selectedCategory = categoryKey);
                newsProvider.fetchNews(categoryKey);
              },
            ),
            Expanded(
              child: newsProvider.isLoading && newsProvider.articles.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : newsProvider.errorMessage.isNotEmpty
                  ? Center(child: Text(newsProvider.errorMessage))
                  : ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: newsProvider.articles.length,
                itemBuilder: (context, index) {
                  final article = newsProvider.articles[index];
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
          ],
        ),
      ),
    );
  }
}
