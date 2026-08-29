import 'package:hive_flutter/hive_flutter.dart';

import '../models/news_model/news_model.dart';

class FavoritesBox {
  static const String boxName = 'favorites';

  static Box get box => Hive.box(boxName);

  static Future<void> toggleFavorite(NewsModel article) async {
    final key = article.url?.trim();

    if (key == null || key.isEmpty) {
      return;
    }

    if (box.containsKey(key)) {
      await box.delete(key);
    } else {
      await box.put(key, {
        'sourceName': article.sourceName,
        'author': article.author,
        'title': article.title,
        'description': article.description,
        'url': article.url,
        'urlToImage': article.urlToImage,
        'publishedAt': article.publishedAt,
        'content': article.content,
      });
    }
  }

  static bool isFavorite(NewsModel article) {
    final key = article.url?.trim();

    if (key == null || key.isEmpty) {
      return false;
    }

    return box.containsKey(key);
  }

  static List<NewsModel> getFavorites() {
    return box.values.whereType<Map>().map((data) {
      final article = Map<String, dynamic>.from(data);

      return NewsModel(
        sourceName: article['sourceName'],
        author: article['author'],
        title: article['title'],
        description: article['description'],
        url: article['url'],
        urlToImage: article['urlToImage'],
        publishedAt: article['publishedAt'],
        content: article['content'],
      );
    }).toList();
  }

  static Future<void> removeFavorite(NewsModel article) async {
    final key = article.url?.trim();

    if (key == null || key.isEmpty) {
      return;
    }

    await box.delete(key);
  }

  static Future<void> clearFavorites() async {
    await box.clear();
  }
}
