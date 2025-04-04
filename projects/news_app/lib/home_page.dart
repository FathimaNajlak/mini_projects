import 'package:flutter/material.dart';
import 'package:news_app/article.dart';
import 'package:news_app/news_service.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsHomePage extends StatelessWidget {
  final NewsService newsService = NewsService();

  NewsHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Top Headlines'),
      ),
      body: FutureBuilder<List<Article>>(
        future: newsService.fetchTopHeadlines(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error:${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text('No news found . '),
            );
          }

          final articles = snapshot.data!;
          return ListView.builder(
            itemCount: articles.length,
            itemBuilder: (context, index) {
              final article = articles[index];
              return Card(
                margin: EdgeInsets.all(8),
                child: ListTile(
                  leading: article.imageUrl != null
                      ? Image.network(article.imageUrl!,
                          width: 100, fit: BoxFit.cover)
                      : null,
                  title: Text(article.title),
                  subtitle: Text(article.description,
                      maxLines: 2, overflow: TextOverflow.ellipsis),
                  onTap: () => _launchURL(article.url),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }
}
