import 'package:equatable/equatable.dart';
import 'package:news_app/features/domain/entities/article.dart';

abstract class LocalArticlesState extends Equatable {
  final List<ArticleEntity>? article;

  const LocalArticlesState({this.article});

  @override
  List<Object> get props => [article!];
}

class LocalArticleLoading extends LocalArticlesState {
  const LocalArticleLoading();
}

class LocalArticlesDone extends LocalArticlesState {
  const LocalArticlesDone(List<ArticleEntity> articles) : super(article: articles);
}
