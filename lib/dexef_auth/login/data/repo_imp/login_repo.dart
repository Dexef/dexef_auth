import 'package:auth_dexef/core/rest/failure.dart';
import 'package:auth_dexef/dexef_auth/login/domain/entity/google_signIn_entity.dart';
import 'package:auth_dexef/dexef_auth/login/domain/entity/login_entity.dart';
import 'package:auth_dexef/dexef_auth/login/domain/entity/social_entity.dart';
import 'package:auth_dexef/dexef_auth/login/domain/entity/validate_email_entity.dart';
import 'package:auth_dexef/dexef_auth/login/domain/repo/repo.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import '../data_source/apple_signIn_dataSource.dart';
import '../data_source/google_signIn_data_source.dart';
import '../data_source/login_data_source.dart';
import '../data_source/validate_email_data_source.dart';

class LoginRepositoryImpl implements LoginRepository {
  LoginRepositoryImpl(
    this.loginDataSource,
    this.appleSignInDataSource,
    this.validateEmailDataSource,
    this.googleSignInDataSource
  );
////////////////////////////////////////////////////////////////////////////////
  final AppleSignInDataSource appleSignInDataSource;
  @override
  Future<Either<Failure, SocialEntity>> appleSignIn(String token) async {
    try {
      return Right(await appleSignInDataSource.appleSignIn(token));
    } catch (e) {
      debugPrint("appleSignIn error ${e.toString()}");
      return Left(Failure(e.toString()));
    }
  }
////////////////////////////////////////////////////////////////////////////////
  final LoginDataSource loginDataSource;
  @override
  Future<Either<Failure, LoginEntity>> getLogin(String email, String password) async {
    try {
      return Right(await loginDataSource.getLogin(email, password));
    } catch (e){
      debugPrint("getLogin error ${e.toString()}");
      return Left(Failure(e.toString()));
    }
  }
////////////////////////////////////////////////////////////////////////////////
  final GoogleSignInDataSource googleSignInDataSource;
  @override
  Future<Either<Failure, GoogleSignInEntity>> googleSignIn(String token) async {
    try {
      return Right(await googleSignInDataSource.googleSignIn(token));
    } catch (e) {
      debugPrint("googleSignIn error ${e.toString()}");
      return Left(Failure(e.toString()));
    }
  }
////////////////////////////////////////////////////////////////////////////////
  final ValidateEmailDataSource validateEmailDataSource;
  @override
  Future<Either<Failure, ValidateEmailEntity>> validateEmail(String userName) async{
    try {
      return Right(await validateEmailDataSource.validateEmail(userName));
    } catch (e) {
      debugPrint("validateEmail error ${e.toString()}");
      return Left(Failure(e.toString()));
    }
  }
}