import 'package:auth_dexef/core/rest/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import '../../../register/domain/entity/resend_code_entity.dart';
import '../../domain/entity/create_new_password_entity.dart';
import '../../domain/entity/reset_password_entity.dart';
import '../../domain/entity/verify_forget_password_entity.dart';
import '../../domain/repo/resetPassword_repo.dart';
import '../data_source/create_new_password_data_source.dart';
import '../data_source/resend_forget_pass_verify_code_data_source.dart';
import '../data_source/reset_password_data_source.dart';
import '../data_source/verify_forget_password_data_source.dart';

class ResetPasswordRepoImp implements ResetPasswordRepository {
  ResetPasswordRepoImp(
    this.resetPasswordDataSource,
    this.verifyForgetPasswordDataSource,
    this.resendForgetPasswordCodeDataSource,
    this.createNewPasswordDataSource,
  );
////////////////////////////////////////////////////////////////////////////////
  final CreateNewPasswordDataSource createNewPasswordDataSource;
  @override
  Future<Either<Failure, CreateNewPasswordEntity>> createNewPassword(
      int mobileID, String code, String password) async {
    try {
      return Right(await createNewPasswordDataSource.createNewPassword(mobileID, code, password));
    } catch (e) {
      debugPrint(e.toString());
      return Left(Failure(e.toString()));
    }
  }
////////////////////////////////////////////////////////////////////////////////
  final ResendForgetPasswordCodeDataSource resendForgetPasswordCodeDataSource;
  @override
  Future<Either<Failure, ResendCodeEntity>> resendForgetPasswordSmsCode(
      int mobileId,bool isWhatsApp) async {
    try {
      return Right(await resendForgetPasswordCodeDataSource.resendCode(
          mobileId: mobileId,isWhatsApp: isWhatsApp));
    } catch (e) {
      debugPrint(e.toString());
      return Left(Failure(e.toString()));
    }
  }
////////////////////////////////////////////////////////////////////////////////
  final ResetPasswordDataSource resetPasswordDataSource;
  @override
  Future<Either<Failure, ResetPasswordEntity>> resetPassword(
      String emailOrPhone,bool isWhatsapp) async {
    try {
      return Right(await resetPasswordDataSource.resetPassword(emailOrPhone,isWhatsapp));
    } catch (e) {
      debugPrint(e.toString());
      return Left(Failure(e.toString()));
    }
  }
////////////////////////////////////////////////////////////////////////////////
  final VerifyForgetPasswordDataSource verifyForgetPasswordDataSource;
  @override
  Future<Either<Failure, VerifyForgetPasswordEntity>> verifyForgetPassword(
      int mobileID, String code) async {
    try {
      return Right(await verifyForgetPasswordDataSource.verifyForgetPassword(mobileID, code));
    } catch (e) {
      debugPrint(e.toString());
      return Left(Failure(e.toString()));
    }
  }
}