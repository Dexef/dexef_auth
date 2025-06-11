import 'package:auth_dexef/auth/register/domain/entity/SignUpEntity.dart';
import 'package:auth_dexef/auth/register/domain/entity/change_mobile_entity.dart';
import 'package:auth_dexef/auth/register/domain/entity/register_apple_entity.dart';
import 'package:auth_dexef/auth/register/domain/entity/register_with_facebook_entity.dart';
import 'package:auth_dexef/auth/register/domain/entity/register_with_google_entity.dart';
import 'package:auth_dexef/auth/register/domain/entity/resend_code_entity.dart';
import 'package:auth_dexef/auth/register/domain/entity/send_sms_entity.dart';
import 'package:auth_dexef/auth/register/domain/entity/verify_code_entity.dart';
import 'package:auth_dexef/auth/register/domain/repo/register_repo.dart';
import 'package:auth_dexef/core/rest/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';

import '../data_source/change_phone_number_data_source.dart';
import '../data_source/registerBy_Google_dataSource.dart';
import '../data_source/registerBy_facebook_datasource.dart';
import '../data_source/register_apple_dataSource.dart';
import '../data_source/resend_code_data_source.dart';
import '../data_source/send_sms_data_source.dart';
import '../data_source/sign_up_data_source.dart';
import '../data_source/verify_code_dataSource.dart';

class RegisterRepoImp implements RegisterRepository {
  RegisterRepoImp(
    this.changePhoneNumberDataSource,
    this.registerAppleDataSource,
    this.registerWithFacebookDataSource,
    this.registerByGoogleDataSource,
    this.resendCodeDataSource,
    this.sendSmsDataSource,
    this.signUpDataSource,
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
  final RegisterWithFacebookDataSource registerWithFacebookDataSource;
  @override
  Future<Either<Failure, RegisterFacebookEntity>> registerByFacebook(
      String token, String email, String mobile, String countryId, int sourceId) async {
    try {
      return Right(await registerWithFacebookDataSource.registerByFacebook(
          token: token,
          email: email,
          mobile: mobile,
          countryId: countryId,
          sourceId: sourceId)
      );
    } catch (e) {
      debugPrint(e.toString());
      return Left(Failure(e.toString()));
    }
  }
////////////////////////////////////////////////////////////////////////////////
  final RegisterByGoogleDataSource registerByGoogleDataSource;
  @override
  Future<Either<Failure, RegisterByGoogleEntity>> registerByGoogle(String token,
      String email, String mobile, String countryId, int sourceId) async {
    try {
      return Right(await registerByGoogleDataSource.registerByGoogle(
          token: token,
          email: email,
          countryId: countryId,
          mobile: mobile,
          sourceId: sourceId));
    } catch (e) {
      // print('Alaa ' + e.toString());
      // print('left = ${e.toString()}');
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
  final SignUpDataSource signUpDataSource;
  @override
  Future<Either<Failure, SignUpEntity>> signUp(
      String email,
      String name,
      String phoneNumber,
      String password,
      String countryCode,
      String companyName) async {
    try {
      return Right(await signUpDataSource.signUp(email, name, phoneNumber, password, countryCode, companyName));
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