import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:news_app/features/data/data_sources/local/app_database.dart';
import 'package:news_app/features/data/data_sources/remote/news_api_service.dart';
import 'package:news_app/features/data/repository/article_repository_impl.dart';
import 'package:news_app/features/domain/repository/article_repository.dart';
import 'package:news_app/features/domain/usecases/get_article.dart';
import 'package:news_app/features/domain/usecases/get_saved_article.dart';
import 'package:news_app/features/domain/usecases/remove_article.dart';
import 'package:news_app/features/domain/usecases/save_article.dart';
import 'package:news_app/features/presentation/bloc/article/local/local_article_bloc.dart';
import 'package:news_app/features/presentation/bloc/article/remote/remote_article_bloc.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  final database = await $FloorAppDataBase.databaseBuilder('app_database.db').build();
  sl.registerSingleton<AppDataBase>(database);

  sl.registerSingleton<Dio>(Dio());

  sl.registerSingleton<NewsApiService>(NewsApiService(sl()));

  sl.registerSingleton<ArticleRepository>(ArticleRepositoryImpl(sl(), sl()));

  sl.registerSingleton<GetSavedArticleUseCase>(GetSavedArticleUseCase(sl()));

  sl.registerSingleton<RemoveArticleUseCase>(RemoveArticleUseCase(sl()));

  sl.registerSingleton<SaveArticleUseCase>(SaveArticleUseCase(sl()));

  sl.registerSingleton<GetArticleUseCase>(GetArticleUseCase(sl()));

  sl.registerFactory<RemoteArticlesBloc>(() => RemoteArticlesBloc(sl()));

  sl.registerFactory<LocalArticleBloc>(() => LocalArticleBloc(sl(), sl(), sl()));
}
