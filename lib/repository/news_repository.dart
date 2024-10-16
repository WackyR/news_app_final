import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:news_app_final/models/categories_model.dart';
import 'package:news_app_final/models/headlines.dart';
class NewsRepository {
  Future<NewsChannelHeadlinesModel> getNewsChannelHeadlines(String channelName) async{
    
    String url = "https://newsapi.org/v2/top-headlines?sources=$channelName&apiKey=4553b5185b99485686c7b23e3d7d6a3b";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return NewsChannelHeadlinesModel.fromJson(body);
    } else {
      throw Exception('Failed to load news');
    }

  }
  Future<CategoriesModel> getCategoriesAPI(String category) async{
    
    String url = "https://newsapi.org/v2/everything?q=$category&apiKey=4553b5185b99485686c7b23e3d7d6a3b";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return CategoriesModel.fromJson(body);
    } else {
      throw Exception('Failed to load news');
    }

  }
}
