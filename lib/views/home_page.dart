import 'package:flutter/material.dart';

import '../components/category_card.dart';
import '../components/data.dart';
import '../components/news_tile.dart';
import '../components/news.dart';
import '../models/article_model.dart';
import '../models/category_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late bool _loading;

  List<Article> newslist = [];

  List<CategoryModel> categories = [];

  //Function to fetch the news from the API and store in a list of Article

  Future<void> getNews() async {
    setState(() {
      _loading = true;
    });
    News news = News();

    await news.getNews();

    newslist = news.news;

    setState(() {
      _loading = false;
    });
  }

  @override
  void initState() {
    _loading = true;

    super.initState();

    categories = getCategories();

    getNews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Creating a beautiful AppBar
      appBar: AppBar(
        centerTitle: true,

        title: const Text('Daily News'),

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

      body: SafeArea(
        child: _loading
            ? const Center(
                //Till the loading is set to true, i.e. The data is being fetched
                child: CircularProgressIndicator(),
              )
            : RefreshIndicator(
                onRefresh: getNews,
                child: CustomScrollView(
                  slivers: <Widget>[
                    SliverToBoxAdapter(
                      child: Column(
                        children: <Widget>[
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            height: 70,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: categories.length,
                              itemBuilder: (context, index) {
                                return CategoryCard(
                                  imageAssetUrl:
                                      categories[index].imageAssetUrl,
                                  categoryName: categories[index].categoryName,
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        return NewsTile(
                          imgUrl: newslist[index].urlToImage ?? "",
                          title: newslist[index].title ?? "",
                          desc: newslist[index].description ?? "",
                          content: newslist[index].content ?? "",
                          posturl: newslist[index].articleUrl ?? "",
                          publshedAt:
                              newslist[index].publshedAt ?? DateTime.now(),
                        );
                      }, childCount: newslist.length),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
