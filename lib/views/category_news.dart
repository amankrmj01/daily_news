import 'package:flutter/material.dart';

import '../components/news_tile.dart';
import '../components/news_category.dart';
import '../models/article_model.dart';

class CategoryNews extends StatefulWidget {
  final String newsCategory;

  const CategoryNews({super.key, required this.newsCategory});

  @override
  State<CategoryNews> createState() => _CategoryNewsState();
}

class _CategoryNewsState extends State<CategoryNews> {
  List<Article> newslist = [];

  bool _loading = true;

  @override
  void initState() {
    getNews();

    super.initState();
  }

  void getNews() async {
    NewsForCategory news = NewsForCategory();

    await news.getNewsForCategory(widget.newsCategory);

    newslist = news.news;

    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,

        title: Text(widget.newsCategory.toUpperCase()),

        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,

              end: Alignment.bottomRight,

              colors: <Color>[Colors.red, Colors.orange],
            ),
          ),
        ),
      ),

      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.only(top: 10),
              child: ListView.builder(
                itemCount: newslist.length,
                itemBuilder: (context, index) {
                  return NewsTile(
                    imgUrl: newslist[index].urlToImage ?? "",
                    title: newslist[index].title ?? "",
                    desc: newslist[index].description ?? "",
                    content: newslist[index].content ?? "",
                    posturl: newslist[index].articleUrl ?? "",
                    publshedAt: newslist[index].publshedAt ?? DateTime.now(),
                  );
                },
              ),
            ),
    );
  }
}
