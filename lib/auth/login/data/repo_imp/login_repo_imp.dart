import 'package:auth_dexef/auth/login/domain/entity/confirm_email_entity.dart';

import 'package:auth_dexef/auth/login/domain/entity/google_signIn_entity.dart';

import 'package:auth_dexef/auth/login/domain/entity/login_entity.dart';
import 'package:auth_dexef/auth/login/domain/entity/sign_in_with_facebook_entity.dart';

import 'package:auth_dexef/auth/login/domain/entity/social_entity.dart';

import 'package:auth_dexef/auth/login/domain/entity/validate_email_entity.dart';

import 'package:auth_dexef/core/rest/failure.dart';

import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';

import '../../domain/repo/login_repo.dart';
import '../data_source/apple_signIn_dataSource.dart';
import '../data_source/confirm_email_data_source.dart';
import '../data_source/google_signIn_data_source.dart';
import '../data_source/login_data_source.dart';
import '../data_source/sign_in_with_face_book_data_source.dart';
import '../data_source/validate_email_data_source.dart';

class LoginRepositoryImpl implements LoginRepository {
  LoginRepositoryImpl(
    this.appleSignInDataSource,
    this.confirmEmailDataSource,
    this.validateEmailDataSource,
    this.googleSignInDataSource,
    this.loginDataSource,
    this.signInFacebookDataSource
  );

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
  final ConfirmEmailDataSource confirmEmailDataSource;
  @override
  Future<Either<Failure, ConfirmEmailEntity>> confirmEmail(String email) async {
    try {
      return Right(await confirmEmailDataSource.confirmEmail(email));
    } catch (e) {
      print(e.toString());
      return Left(Failure(e.toString()));
    }
  }
////////////////////////////////////////////////////////////////////////////////
  final LoginDataSource loginDataSource;
  @override
  Future<Either<Failure, LoginEntity>> getLogin(
      String email, String password) async {
    try {
      return Right(await loginDataSource.getLogin(email, password));
    } catch (e) {
      debugPrint(e.toString());
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
  final SignInFacebookDataSource signInFacebookDataSource;
  @override
  Future<Either<Failure, SignInFacebookEntity>> signInWithFaceBook(String token) async{
    try {
      return Right(await signInFacebookDataSource.signInWithFacebook(token));
    } catch (e) {
      print(e.toString());
      return Left(Failure(e.toString()));
    }
  }
}