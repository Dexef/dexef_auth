import 'package:auth_dexef/core/rest/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import '../../domain/entity/change_mobile_entity.dart';
import '../../domain/entity/register_apple_entity.dart';
import '../../domain/entity/register_google_entity.dart';
import '../../domain/entity/register_normal_entity.dart';
import '../../domain/entity/resend_code_entity.dart';
import '../../domain/entity/send_sms_entity.dart';
import '../../domain/entity/verify_code_entity.dart';
import '../../domain/repo/register_repo.dart';
import '../data_source/change_phone_number_data_source.dart';
import '../data_source/register_Google_dataSource.dart';
import '../data_source/register_apple_dataSource.dart';
import '../data_source/resend_code_data_source.dart';
import '../data_source/send_sms_data_source.dart';
import '../data_source/register_normal_dataSource.dart';
import '../data_source/verify_code_dataSource.dart';

class RegisterRepoImp implements RegisterRepository {
  RegisterRepoImp(
    this.changePhoneNumberDataSource,
    this.registerAppleDataSource,
    this.registerByGoogleDataSource,
    this.resendCodeDataSource,
    this.sendSmsDataSource,
    this.registerNormalDataSource,
    this.verifyCodeDataSource
  );
////////////////////////////////////////////////////////////////////////////////
  final ChangePhoneNumberDataSource changePhoneNumberDataSource;
  @override
  Future<Either<Failure, ChangeMobileEntity>> changePhoneNumber(String phoneNumber,String countryCode,int mobileID,bool isWhatsapp) async {
    try {
      return Right(await changePhoneNumberDataSource.changePhoneNumber(phoneNumber, countryCode, mobileID,isWhatsapp));
    } catch (e) {
      debugPrint(e.toString());
      return Left(Failure(e.toString()));
    }
  }
////////////////////////////////////////////////////////////////////////////////
  final RegisterAppleDataSource registerAppleDataSource;
  @override
  Future<Either<Failure, RegisterAppleEntity>> registerByApple(String token, String email, String mobile, String countryId, int sourceId) async {
    try {
      return Right(await registerAppleDataSource.registerByApple(token, email, mobile, countryId, sourceId));
    } catch (e) {
      debugPrint(e.toString());
      return Left(Failure(e.toString()));
    }
  }
////////////////////////////////////////////////////////////////////////////////
  final RegisterByGoogleDataSource registerByGoogleDataSource;
  @override
  Future<Either<Failure, RegisterGoogleEntity>> registerByGoogle(String token,
      String email, String mobile, String countryId, int sourceId) async {
    try {
      return Right(await registerByGoogleDataSource.registerByGoogle(
          token: token,
          email: email,
          countryId: countryId,
          mobile: mobile,
          sourceId: sourceId));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
////////////////////////////////////////////////////////////////////////////////
  final ResendCodeDataSource resendCodeDataSource;
  @override
  Future<Either<Failure, ResendCodeEntity>> resendSmsCode(int mobileId,bool isWhatsApp) async {
    try {
      return Right(await resendCodeDataSource.resendCode(mobileId,isWhatsApp));
    } catch (e) {
      debugPrint(e.toString());
      return Left(Failure(e.toString()));
    }
  }
////////////////////////////////////////////////////////////////////////////////
  final SendSmsDataSource sendSmsDataSource;
  @override
  Future<Either<Failure, SendSmsEntity>> sendSmsVerification(int mobileId, bool isWhatsApp)async {
    try {
      return Right(await sendSmsDataSource.sendSmsVerification(mobileId , isWhatsApp));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
////////////////////////////////////////////////////////////////////////////////
  final RegisterNormalDataSource registerNormalDataSource;
  @override
  Future<Either<Failure, RegisterNormalEntity>> registerNormal(
      String email,
      String name,
      String phoneNumber,
      String password,
      String countryCode,
      String companyName) async {
    try {
      return Right(await registerNormalDataSource.signUp(email, name, phoneNumber, password, countryCode, companyName));
    } catch (e) {
      debugPrint(e.toString());
      return Left(Failure(e.toString()));
    }
  }
////////////////////////////////////////////////////////////////////////////////
  final VerifyCodeDataSource verifyCodeDataSource;
  @override
  Future<Either<Failure, VerifyCodeEntity>> verifySmsCode(int mobileId, String code) async {
    try {
      return Right(await verifyCodeDataSource.verifyCode(mobileId: mobileId, code: code));
    } catch (e) {
      debugPrint(e.toString());
      return Left(Failure(e.toString()));
    }
  }
}