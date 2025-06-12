import 'package:auth_dexef/features/login/presentation/cubit/login_cubit.dart';
import '../../locator.dart';
import 'data/data_source/login_apple_dataSource.dart';
import 'data/data_source/login_google_dataSource.dart';
import 'data/data_source/login_normal_dataSource.dart';
import 'data/data_source/validate_email_data_source.dart';
import 'data/repo_imp/login_repo_imp.dart';
import 'domain/repo/login_repo.dart';
import 'domain/useCase/login_apple_useCase.dart';
import 'domain/useCase/login_google_useCase.dart';
import 'domain/useCase/login_normal_useCase.dart';
import 'domain/useCase/validate_email_use_case.dart';

loginInjection(){
  locator.registerFactory(() => LoginCubit(locator(), locator(),
      locator(), locator()
  ));
//////////////////////////////////////////////////////////////////////////////// data source
  locator.registerLazySingleton<AppleSignInDataSource>(() => AppleSignInDataSource());
  locator.registerLazySingleton<GoogleSignInDataSource>(() => GoogleSignInDataSource());
  locator.registerLazySingleton<LoginDataSource>(() => LoginDataSource());
  locator.registerLazySingleton<ValidateEmailDataSource>(() => ValidateEmailDataSource());

//////////////////////////////////////////////////////////////////////////////// use case
  locator.registerLazySingleton<AppleSignInUseCase>(() => AppleSignInUseCase(locator()));
  locator.registerLazySingleton<GoogleSignInUseCase>(() => GoogleSignInUseCase(locator()));
  locator.registerLazySingleton<LoginUseCase>(() => LoginUseCase(locator()));
  locator.registerLazySingleton<ValidateEmailUseCase>(() => ValidateEmailUseCase(locator()));

//////////////////////////////////////////////////////////////////////////////// repo
  locator.registerLazySingleton<LoginRepository>(() => LoginRepositoryImpl(locator(), locator(), locator(), locator()));
}