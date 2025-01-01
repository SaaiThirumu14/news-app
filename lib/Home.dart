import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'destination.dart';  // Import DescriptionPage here

Future<NewsResponse> fetchNews() async {
  final response = await http.get(
    Uri.parse('https://newsapi.org/v2/everything?q=Tamil%20Nadu&language=en&apiKey=9c57b5c8b7f04eaf991935601a387094'),
  );

  print("Response Status: ${response.statusCode}");
  print("Response Body: ${response.body}");

  if (response.statusCode == 200) {
    return NewsResponse.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    throw Exception('Failed to load News');
  }
}

class NewsArticle {
  final String sourceId;
  final String sourceName;
  final String author;
  final String title;
  final String description;
  final String url;
  final String urlToImage;
  final DateTime publishedAt;
  final String content;

  const NewsArticle({
    required this.sourceId,
    required this.sourceName,
    required this.author,
    required this.title,
    required this.description,
    required this.url,
    required this.urlToImage,
    required this.publishedAt,
    required this.content,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      sourceId: json['source']['id'] ?? '',
      sourceName: json['source']['name'] ?? '',
      author: json['author'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      url: json['url'] ?? '',
      urlToImage: json['urlToImage'] ?? '',
      publishedAt: DateTime.parse(json['publishedAt']),
      content: json['content'] ?? '',
    );
  }
}

class NewsResponse {
  final String status;
  final int totalResults;
  final List<NewsArticle> articles;

  const NewsResponse({
    required this.status,
    required this.totalResults,
    required this.articles,
  });

  factory NewsResponse.fromJson(Map<String, dynamic> json) {
    var articlesFromJson = json['articles'] as List;
    List<NewsArticle> articlesList = articlesFromJson.map((article) => NewsArticle.fromJson(article)).toList();

    return NewsResponse(
      status: json['status'],
      totalResults: json['totalResults'],
      articles: articlesList,
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<NewsResponse> futureNews;

  @override
  void initState() {
    super.initState();
    futureNews = fetchNews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("News-App"),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 146, 222, 169),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<NewsResponse>(
          future: futureNews,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.articles.length,
                itemBuilder: (context, index) {
                  var article = snapshot.data!.articles[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    elevation: 5,
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16.0),
                      title: Text(
                        article.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        article.description,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onTap: () {
                        // Navigating to DescriptionPage with the selected article
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DescriptionPage(article: article),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
