import 'package:news_app/core/resources/data_state.dart';
import 'package:news_app/core/usecases/usecase.dart';
import 'package:news_app/features/domain/entities/article.dart';
import 'package:news_app/features/domain/repository/article_repository.dart';

class GetSavedArticleUseCase implements UseCase<List<ArticleEntity>, void> {
  final ArticleRepository _articleRepository;

  GetSavedArticleUseCase(this._articleRepository);
  @override
  Future<List<ArticleEntity>> call({params}) {
    return _articleRepository.getSavedArticles();
  }
}
