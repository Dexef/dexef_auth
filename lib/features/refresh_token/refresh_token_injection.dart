import '../../locator.dart';
import 'data/data_source/refresh_token_data_source.dart';
import 'data/repository/refresh_token_repository_impl.dart';
import 'domain/repository/refresh_token_repository.dart';
import 'domain/use_cases/refresh_token_use_case.dart';

refreshTokenInjection(){
  locator.registerLazySingleton<RefreshTokenDataSource>(() => RefreshTokenDataSource());
////////////////////////////////////////////////////////////////////////////////
  locator.registerLazySingleton<RefreshTokenUseCase>(() => RefreshTokenUseCase(repository: locator(),));
////////////////////////////////////////////////////////////////////////////////
  locator.registerLazySingleton<RefreshTokenRepository>(() => RefreshTokenRepositoryImpl(refreshTokenDataSource: locator()));
}