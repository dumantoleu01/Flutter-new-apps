import 'package:flutter/material.dart';
import 'package:news_app/features/domain/entities/article.dart';
import 'package:news_app/features/presentation/pages/article_details/article_details.dart';
import 'package:news_app/features/presentation/pages/home/daily_news.dart';
import 'package:news_app/features/presentation/pages/saved_article/saved_articles.dart';

class AppRoutes {
  static Route onGenerateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return _materialRoute(const DailyNews());

      case '/ArticleDetails':
        return _materialRoute(ArticleDetailsView(article: settings.arguments as ArticleEntity));

      case '/SavedArticles':
        return _materialRoute(const SavedArticles());

      default:
        return _materialRoute(const DailyNews());
    }
  }

  static Route<dynamic> _materialRoute(Widget view) {
    return MaterialPageRoute(builder: (_) => view);
  }
}
