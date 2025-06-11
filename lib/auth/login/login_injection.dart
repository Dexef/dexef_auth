import 'package:auth_dexef/auth/login/presentation/cubit/login_cubit.dart';

import '../../locator.dart';
import 'data/data_source/apple_signIn_dataSource.dart';
import 'data/data_source/confirm_email_data_source.dart';
import 'data/data_source/google_signIn_data_source.dart';
import 'data/data_source/login_data_source.dart';
import 'data/data_source/sign_in_with_face_book_data_source.dart';
import 'data/data_source/validate_email_data_source.dart';
import 'data/repo_imp/login_repo_imp.dart';
import 'domain/repo/login_repo.dart';
import 'domain/useCase/apple_signIn_useCase.dart';
import 'domain/useCase/confirm_email_use_case.dart';
import 'domain/useCase/google_signIn_use_case.dart';
import 'domain/useCase/login_use_case.dart';
import 'domain/useCase/sign_in_with_facebook_use_case.dart';
import 'domain/useCase/validate_email_use_case.dart';

loginInjection(){
  locator.registerFactory(() => LoginCubit(locator(), locator(),
      locator(), locator(),locator()
  ));
//////////////////////////////////////////////////////////////////////////////// data source
  locator.registerLazySingleton<AppleSignInDataSource>(() => AppleSignInDataSource());
  locator.registerLazySingleton<ConfirmEmailDataSource>(() => ConfirmEmailDataSource());
  locator.registerLazySingleton<GoogleSignInDataSource>(() => GoogleSignInDataSource());
  locator.registerLazySingleton<LoginDataSource>(() => LoginDataSource());
  locator.registerLazySingleton<SignInFacebookDataSource>(() => SignInFacebookDataSource());
  locator.registerLazySingleton<ValidateEmailDataSource>(() => ValidateEmailDataSource());

//////////////////////////////////////////////////////////////////////////////// use case
  locator.registerLazySingleton<AppleSignInUseCase>(() => AppleSignInUseCase(locator()));
  locator.registerLazySingleton<ConfirmEmailUseCase>(() => ConfirmEmailUseCase(locator()));
  locator.registerLazySingleton<GoogleSignInUseCase>(() => GoogleSignInUseCase(locator()));
  locator.registerLazySingleton<LoginUseCase>(() => LoginUseCase(locator()));
  locator.registerLazySingleton<SignInWithFaceBookUseCase>(() => SignInWithFaceBookUseCase(locator()));
  locator.registerLazySingleton<ValidateEmailUseCase>(() => ValidateEmailUseCase(locator()));

//////////////////////////////////////////////////////////////////////////////// repo
  locator.registerLazySingleton<LoginRepository>(() => LoginRepositoryImpl(locator(), locator(), locator(), locator(), locator(), locator()));
}