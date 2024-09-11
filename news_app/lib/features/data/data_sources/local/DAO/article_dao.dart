import 'package:floor/floor.dart';
import 'package:news_app/features/data/models/article.dart';

@dao
abstract class ArticleDAO {
  @Insert()
  Future<void> insertArticle(ArticleModel articleModel);

  @delete
  Future<void> deleteArticle(ArticleModel articleModel);

  @Query('SELECT * FROM article')
  Future<List<ArticleModel>> getArticles();
}
