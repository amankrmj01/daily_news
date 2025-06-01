import 'dart:developer';

import 'package:http/http.dart' as http;

import 'dart:convert';

import '../env/env.dart';
import '../models/article_model.dart';

class News {
  List<Article> news = [];

  Future<void> getNews() async {
    String url =
        "http://newsapi.org/v2/top-headlines?country=us&excludeDomains=stackoverflow.com&sortBy=publishedAt&language=en&apiKey=${Env.apiKey}";

    http.Response response = await http.get(Uri.parse(url));

    var jsonData = jsonDecode(response.body);

    if (jsonData['status'] == "ok") {
      jsonData["articles"].forEach((element) {
        if (element['urlToImage'] != null && element['description'] != null) {
          Article article = Article(
            title: element['title'],

            author: element['author'],

            description: element['description'],

            urlToImage: element['urlToImage'],

            publshedAt: DateTime.parse(element['publishedAt']),

            content: element["content"],

            articleUrl: element["url"],
          );

          news.add(article);
        }
      });
    } else {
      log("Error fetching news: ${jsonData['message']}");
    }
  }
}
