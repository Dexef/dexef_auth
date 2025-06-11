import 'package:auth_dexef/auth/resetPassword/presentation/cubit/reset_password_cubit.dart';
import '../../locator.dart';
import 'data/data_source/create_new_password_data_source.dart';
import 'data/data_source/resend_forget_pass_verify_code_data_source.dart';
import 'data/data_source/reset_password_data_source.dart';
import 'data/data_source/verify_forget_password_data_source.dart';
import 'data/repo/resetPassword_repo_imp.dart';
import 'domain/repo/resetPassword_repo.dart';
import 'domain/useCase/create_new_password_use_case.dart';
import 'domain/useCase/resend_forget_pass_code_use_case.dart';
import 'domain/useCase/reset_password_use_case.dart';
import 'domain/useCase/verify_forget_pass_use_case.dart';

resetPasswordInjection(){
  locator.registerFactory(() => ResetPasswordCubit(locator(), locator()));

//////////////////////////////////////////////////////////////////////////////// data source
  locator.registerLazySingleton<CreateNewPasswordDataSource>(() => CreateNewPasswordDataSource());
  locator.registerLazySingleton<ResendForgetPasswordCodeDataSource>(() => ResendForgetPasswordCodeDataSource());
  locator.registerLazySingleton<ResetPasswordDataSource>(() => ResetPasswordDataSource());
  locator.registerLazySingleton<VerifyForgetPasswordDataSource>(() => VerifyForgetPasswordDataSource());

//////////////////////////////////////////////////////////////////////////////// useCase
  locator.registerLazySingleton<CreateNewPasswordUseCase>(() => CreateNewPasswordUseCase(locator()));
  locator.registerLazySingleton<ResendForgetPasswordCodeUseCase>(() => ResendForgetPasswordCodeUseCase(locator()));
  locator.registerLazySingleton<ResetPasswordUseCase>(() => ResetPasswordUseCase(locator()));
  locator.registerLazySingleton<VerifyForgetPasswordUseCase>(() => VerifyForgetPasswordUseCase(locator()));

//////////////////////////////////////////////////////////////////////////////// repo
  locator.registerLazySingleton<ResetPasswordRepository>(() => ResetPasswordRepoImp(locator(), locator(), locator(), locator()));
}