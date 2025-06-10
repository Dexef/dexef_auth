import 'package:auth_dexef/dexef_auth/login/data/repo_imp/login_repo.dart';
import 'package:auth_dexef/dexef_auth/login/domain/repo/repo.dart';
import '../../locator.dart';
import 'login/data/data_source/apple_signIn_dataSource.dart';
import 'login/data/data_source/google_signIn_data_source.dart';
import 'login/data/data_source/login_data_source.dart';
import 'login/data/data_source/validate_email_data_source.dart';
import 'login/domain/useCase/apple_signIn_useCase.dart';
import 'login/domain/useCase/google_signIn_use_case.dart';
import 'login/domain/useCase/login_use_case.dart';
import 'login/domain/useCase/validate_email_use_case.dart';
import 'login/presentation/cubit/login_cubit.dart';

authInjection(){
  locator.registerFactory(() => LoginCubit(locator(), locator(), locator(), locator()));
//////////////////////////////////////////////////////////////////////////////// data sources
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