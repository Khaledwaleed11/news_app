import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class RemoteDataSource {
  static const String apiKey =
      '02be8aff02dd4e2d92cea4e8039da6d3';


  Future<Map<String, dynamic>> getNewsByCategory(
      String category,
      ) async {
    final uri = Uri.parse(
      'https://newsapi.org/v2/top-headlines'
          '?country=us'
          '&category=$category'
          '&pageSize=50'
          '&apiKey=$apiKey',
    );

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      if (kDebugMode) {
        print('STATUS CODE: ${response.statusCode}');
      }
      if (kDebugMode) {
        print('RESPONSE BODY: ${response.body}');
      }

      throw Exception(
        'Failed to load news: ${response.statusCode}',
      );
    }
  }


  Future<Map<String, dynamic>> searchNews(
      String query,
      ) async {
    final cleanQuery = query.trim();

    if (cleanQuery.isEmpty) {
      throw Exception('Search query cannot be empty');
    }

    final uri = Uri.https(
      'newsapi.org',
      '/v2/everything',
      {
        'q': cleanQuery,
        'sortBy': 'relevancy',
        'pageSize': '50',
        'apiKey': apiKey,
      },
    );

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    throw Exception(
      'Failed to search news: ${response.statusCode}',
    );
  }
}