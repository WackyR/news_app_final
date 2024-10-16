import 'package:news_app_final/models/categories_model.dart';
import 'package:news_app_final/models/headlines.dart';
import 'package:news_app_final/repository/news_repository.dart';
class NewsViewModel {
  final _repo = NewsRepository();

  Future<NewsChannelHeadlinesModel> getNewsChannelHeadlines(String channelName) async {
    final response = await _repo.getNewsChannelHeadlines(channelName);
    return response;
  }
  Future<CategoriesModel> getCategoriesAPI(String category) async {
    final response = await _repo.getCategoriesAPI(category);
    return response;
  }
}