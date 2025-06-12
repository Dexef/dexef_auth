import 'package:auth_dexef/core/rest/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import '../../domain/entity/login_google_entity.dart';
import '../../domain/entity/login_normal_entity.dart';
import '../../domain/entity/login_apple_entity.dart';
import '../../domain/entity/validate_email_entity.dart';
import '../../domain/repo/login_repo.dart';
import '../data_source/login_apple_dataSource.dart';
import '../data_source/login_google_dataSource.dart';
import '../data_source/login_normal_dataSource.dart';
import '../data_source/validate_email_data_source.dart';

class LoginRepositoryImpl implements LoginRepository {
  LoginRepositoryImpl(
    this.appleSignInDataSource,
    this.validateEmailDataSource,
    this.googleSignInDataSource,
    this.loginDataSource,
  );

////////////////////////////////////////////////////////////////////////////////
  final ValidateEmailDataSource validateEmailDataSource;
  @override
  Future<Either<Failure, ValidateEmailEntity>> validateEmail(String userName) async{
    try {
      return Right(await validateEmailDataSource.validateEmail(userName));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
////////////////////////////////////////////////////////////////////////////////
  final LoginDataSource loginDataSource;
  @override
  Future<Either<Failure, LoginEntity>> loginNormal(
      String email, String password) async {
    try {
      return Right(await loginDataSource.getLogin(email, password));
    } catch (e) {
      debugPrint(e.toString());
      return Left(Failure(e.toString()));
    }
  }
////////////////////////////////////////////////////////////////////////////////
  final AppleSignInDataSource appleSignInDataSource;
  @override
  Future<Either<Failure, SocialEntity>> appleSignIn(String token) async {
    try {
      return Right(await appleSignInDataSource.appleSignIn(token));
    } catch (e) {
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
      return Left(Failure(e.toString()));
    }
  }
}