// import 'package:flutter/material.dart';
// import 'package:news_app/article.dart';
// import 'package:news_app/news_service.dart';
// import 'package:url_launcher/url_launcher.dart';

// class NewsHomePage extends StatelessWidget {
//   final NewsService newsService = NewsService();

//   NewsHomePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Top Headlines'),
//       ),
//       body: FutureBuilder<List<Article>>(
//         future: newsService.fetchTopHeadlines(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(
//               child: CircularProgressIndicator(),
//             );
//           } else if (snapshot.hasError) {
//             return Center(
//               child: Text('Error:${snapshot.error}'),
//             );
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return Center(
//               child: Text('No news found . '),
//             );
//           }

//           final articles = snapshot.data!;
//           return ListView.builder(
//             itemCount: articles.length,
//             itemBuilder: (context, index) {
//               final article = articles[index];
//               return Card(
//                 margin: EdgeInsets.all(8),
//                 child: ListTile(
//                   leading: article.imageUrl != null
//                       ? Image.network(article.imageUrl!,
//                           width: 100, fit: BoxFit.cover)
//                       : null,
//                   title: Text(article.title),
//                   subtitle: Text(article.description,
//                       maxLines: 2, overflow: TextOverflow.ellipsis),
//                   onTap: () => _launchURL(article.url),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }

//   void _launchURL(String url) async {
//     final uri = Uri.parse(url);
//     if (await canLaunchUrl(uri)) {
//       await launchUrl(uri);
//     } else {
//       throw 'Could not launch $url';
//     }
//   }
// }

import 'package:flutter/material.dart';
import 'package:news_app/article.dart';
import 'package:news_app/news_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

class NewsHomePage extends StatefulWidget {
  const NewsHomePage({super.key});

  @override
  State<NewsHomePage> createState() => _NewsHomePageState();
}

class _NewsHomePageState extends State<NewsHomePage> {
  final NewsService newsService = NewsService();
  late Future<List<Article>> _newsFuture;

  @override
  void initState() {
    super.initState();
    _newsFuture = newsService.fetchTopHeadlines();
  }

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Headlines'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: FutureBuilder<List<Article>>(
        future: _newsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No news found.'));
          }

          final articles = snapshot.data!;
          return ListView.builder(
            itemCount: articles.length,
            itemBuilder: (context, index) {
              final article = articles[index];
              // Alternate between different news card styles
              switch (index % 3) {
                case 0:
                  return GestureDetector(
                    onTap: () => _launchURL(article.url),
                    child: NewsCard(article: article),
                  );
                case 1:
                  return GestureDetector(
                    onTap: () => _launchURL(article.url),
                    child: NewsCardtwo(article: article),
                  );
                default:
                  return GestureDetector(
                    onTap: () => _launchURL(article.url),
                    child: NYStyleNewsCard(article: article),
                  );
              }
            },
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
          BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: 'Saved'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class NewsCard extends StatelessWidget {
  final Article article;

  const NewsCard({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Main content area
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  article.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                // Author row with verified badge
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 12,
                      backgroundImage: AssetImage('assets/images/avatar.jpg'),
                    ),
                    const SizedBox(width: 8),
                    Text('CNN'),
                    const SizedBox(width: 4),
                    const Icon(Icons.verified, color: Colors.blue, size: 14),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  article.description,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                // Bottom interaction row
                Row(
                  children: [
                    _buildInteractionButton(Icons.comment_outlined, '34'),
                    const SizedBox(width: 16),
                    _buildInteractionButton(Icons.repeat, '12'),
                    const SizedBox(width: 16),
                    _buildInteractionButton(Icons.favorite_border, '142'),
                    const Spacer(),
                    Text(
                      '4h ago',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInteractionButton(IconData icon, String count) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Text(count, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
      ],
    );
  }
}

class NewsCardtwo extends StatelessWidget {
  final Article article;

  const NewsCardtwo({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Video thumbnail with play button overlay
          Stack(
            alignment: Alignment.center,
            children: [
              if (article.imageUrl != null)
                Image.network(
                  article.imageUrl!,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                )
              else
                Container(
                  height: 200,
                  width: double.infinity,
                  color: Colors.blue[900],
                ),

              // Breaking news banner
              Positioned(
                left: 12,
                bottom: 12,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  color: Colors.red,
                  child: const Text(
                    'BREAKING NEWS',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),

              Positioned(
                bottom: 40,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    article.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Text content similar to CNN style
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  article.description,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 12,
                      backgroundImage: AssetImage('assets/images/avatar.jpg'),
                    ),
                    const SizedBox(width: 8),
                    Text('News Channel'),
                    const SizedBox(width: 4),
                    const Icon(Icons.verified, color: Colors.blue, size: 14),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  article.description,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                // Interaction buttons
                Row(
                  children: [
                    _buildInteractionButton(Icons.comment_outlined, '16'),
                    const SizedBox(width: 16),
                    _buildInteractionButton(Icons.repeat, '8'),
                    const SizedBox(width: 16),
                    _buildInteractionButton(Icons.favorite_border, '78'),
                    const Spacer(),
                    Text(
                      '2h ago',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInteractionButton(IconData icon, String count) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Text(count, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
      ],
    );
  }
}

class NYStyleNewsCard extends StatelessWidget {
  final Article article;

  const NYStyleNewsCard({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with "LIVE" tag
          Container(
            color: Colors.red[800],
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
            child: const Row(
              children: [
                Text(
                  'LIVE',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          // Split layout with reporter and city view
          Row(
            children: [
              // Reporter section (left)
              Expanded(
                flex: 2,
                child: Container(
                  height: 140,
                  color: Colors.grey[900],
                  child: const Center(
                    child: CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage('assets/images/Reporter.png'),
                    ),
                  ),
                ),
              ),
              // City view section (right)
              Expanded(
                flex: 3,
                child: Container(
                  height: 140,
                  color: Colors.grey[800],
                  child: article.imageUrl != null
                      ? Image.network(
                          article.imageUrl!,
                          fit: BoxFit.cover,
                          height: 140,
                          width: double.infinity,
                        )
                      : const Center(
                          child: Text(
                            'NEW YORK',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                ),
              ),
            ],
          ),
          // "24h" label
          Positioned(
            left: 8,
            bottom: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                '24h',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          // Article content
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  article.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 12,
                      backgroundImage: AssetImage('assets/images/avatar.jpg'),
                    ),
                    const SizedBox(width: 8),
                    Text('24h News'),
                    const SizedBox(width: 4),
                    const Icon(Icons.verified, color: Colors.blue, size: 14),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  article.description,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                // Interaction buttons
                Row(
                  children: [
                    _buildInteractionButton(Icons.comment_outlined, '28'),
                    const SizedBox(width: 16),
                    _buildInteractionButton(Icons.repeat, '19'),
                    const SizedBox(width: 16),
                    _buildInteractionButton(Icons.favorite_border, '95'),
                    const Spacer(),
                    Text(
                      '8h ago',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInteractionButton(IconData icon, String count) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Text(count, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
      ],
    );
  }
}
