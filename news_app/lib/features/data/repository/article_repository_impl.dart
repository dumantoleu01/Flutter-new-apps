import 'dart:io';

import 'package:dio/dio.dart';
import 'package:news_app/core/constants/constants.dart';
import 'package:news_app/features/data/data_sources/local/app_database.dart';
import 'package:news_app/features/data/data_sources/remote/news_api_service.dart';
import 'package:news_app/features/data/models/article.dart';
import 'package:news_app/core/resources/data_state.dart';
import 'package:news_app/features/domain/entities/article.dart';
import 'package:news_app/features/domain/repository/article_repository.dart';

class ArticleRepositoryImpl extends ArticleRepository {
  final NewsApiService _newsApiService;
  final AppDataBase _appDataBase;

  ArticleRepositoryImpl(this._newsApiService, this._appDataBase);
  @override
  Future<DataState<List<ArticleModel>>> getNewsArticle() async {
    try {
      final httpResponse = await _newsApiService.getNewsArticles(
        apiKey: newsApiKey,
        country: countryQuery,
        category: categoryQuery,
      );

      if (httpResponse.response.statusCode == HttpStatus.ok) {
        // log("${httpResponse.data}");
        List<ArticleModel> articles = (httpResponse.data['articles'] as List<dynamic>).map((e) => ArticleModel.fromJson(e)).toList();
        return DataSuccess(articles);
      } else {
        return DataFailed(DioException(
            error: httpResponse.response.statusMessage,
            response: httpResponse.response,
            type: DioExceptionType.badResponse,
            requestOptions: httpResponse.response.requestOptions));
      }
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<List<ArticleModel>> getSavedArticles() async {
    return _appDataBase.articleDAO.getArticles();
  }

  @override
  Future<void> removeArticle(ArticleEntity article) {
    return _appDataBase.articleDAO.deleteArticle(ArticleModel.fromEntity(article));
  }

  @override
  Future<void> saveArticle(ArticleEntity article) {
    return _appDataBase.articleDAO.insertArticle(ArticleModel.fromEntity(article));
  }
}
