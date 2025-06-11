import 'package:dartz/dartz.dart';
import '../../../../core/rest/failure.dart';
import '../../../register/domain/entity/resend_code_entity.dart';
import '../entity/create_new_password_entity.dart';
import '../entity/reset_password_entity.dart';
import '../entity/verify_forget_password_entity.dart';

abstract class ResetPasswordRepository{

  Future<Either<Failure , ResendCodeEntity>> resendForgetPasswordSmsCode(int mobileId,bool isWhatsApp);

  Future<Either<Failure , ResetPasswordEntity>> resetPassword(String emailOrPhone , bool isWhatsapp);

  Future<Either<Failure , VerifyForgetPasswordEntity>> verifyForgetPassword(int mobileID,String code);

  Future<Either<Failure , CreateNewPasswordEntity>> createNewPassword(int mobileID,String code,String password);

}