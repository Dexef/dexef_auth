import 'package:auth_dexef/features/register/presentation/cubit/register_cubit.dart';

import '../../locator.dart';
import 'data/data_source/change_phone_number_data_source.dart';
import 'data/data_source/register_Google_dataSource.dart';
import 'data/data_source/register_apple_dataSource.dart';
import 'data/data_source/register_normal_dataSource.dart';
import 'data/data_source/resend_code_data_source.dart';
import 'data/data_source/send_sms_data_source.dart';
import 'data/data_source/verify_code_dataSource.dart';
import 'data/repo_imp/register_repo_imp.dart';
import 'domain/repo/register_repo.dart';
import 'domain/useCase/change_phone_number.dart';
import 'domain/useCase/register_apple_useCase.dart';
import 'domain/useCase/register_google_useCase.dart';
import 'domain/useCase/register_normal_useCase.dart';
import 'domain/useCase/resend_code_use_case.dart';
import 'domain/useCase/send_sms_use_case.dart';
import 'domain/useCase/verify_code_use_case.dart';

registerInjection(){
  locator.registerFactory(() => RegisterCubit(
      locator(), locator(), locator(), locator(), locator(), locator(), locator(), locator()));

//////////////////////////////////////////////////////////////////////////////// data source
  locator.registerLazySingleton<ChangePhoneNumberDataSource>(() => ChangePhoneNumberDataSource());
  locator.registerLazySingleton<RegisterAppleDataSource>(() => RegisterAppleDataSource());
  locator.registerLazySingleton<RegisterByGoogleDataSource>(() => RegisterByGoogleDataSource());
  locator.registerLazySingleton<RegisterNormalDataSource>(() => RegisterNormalDataSource());
  locator.registerLazySingleton<ResendCodeDataSource>(() => ResendCodeDataSource());
  locator.registerLazySingleton<SendSmsDataSource>(() => SendSmsDataSource());
  locator.registerLazySingleton<VerifyCodeDataSource>(() => VerifyCodeDataSource());

//////////////////////////////////////////////////////////////////////////////// useCase
  locator.registerLazySingleton<ChangePhoneNumberUseCase>(() => ChangePhoneNumberUseCase(locator()));
  locator.registerLazySingleton<RegisterAppleUseCase>(() => RegisterAppleUseCase(locator()));
  locator.registerLazySingleton<RegisterByGoogleUseCase>(() => RegisterByGoogleUseCase(locator()));
  locator.registerLazySingleton<RegisterNormalUseCase>(() => RegisterNormalUseCase(locator()));
  locator.registerLazySingleton<ResendCodeUseCase>(() => ResendCodeUseCase(locator()));
  locator.registerLazySingleton<SendSmsUseCase>(() => SendSmsUseCase(locator()));
  locator.registerLazySingleton<VerifyCodeUseCase>(() => VerifyCodeUseCase(locator()));

//////////////////////////////////////////////////////////////////////////////// repo
  locator.registerLazySingleton<RegisterRepository>(() => RegisterRepoImp(locator(), locator(),
      locator(), locator(), locator(), locator(), locator())
  );
}