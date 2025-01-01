import 'package:flutter/material.dart';
import 'Home.dart';  // Import NewsArticle from Home.dart

class DescriptionPage extends StatelessWidget {
  final NewsArticle article;

  const DescriptionPage({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          article.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 146, 222, 169),
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              article.urlToImage.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        article.urlToImage,
                        width: double.infinity,
                        height: 250,
                        fit: BoxFit.cover,
                      ),
                    )
                  : const SizedBox.shrink(),
              const SizedBox(height: 20),
              Text(
                'By ${article.author.isEmpty ? "Unknown" : article.author}',
                style: const TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                article.title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 15),
              Text(
                article.description,
                style: const TextStyle(
                  fontSize: 18,
                  height: 1.4,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 25),
              Text(
                'Published At: ${article.publishedAt.toLocal()}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 15),
              Text(
                article.content.isEmpty
                    ? 'Content not available.'
                    : article.content,
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.6,
                ),
                textAlign: TextAlign.justify,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
