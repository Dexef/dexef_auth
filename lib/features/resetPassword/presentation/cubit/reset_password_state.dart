
import '../../../register/domain/entity/resend_code_entity.dart';
import '../../domain/entity/create_new_password_entity.dart';
import '../../domain/entity/reset_password_entity.dart';
import '../../domain/entity/verify_forget_password_entity.dart';
import '../../domain/useCase/verify_forget_pass_use_case.dart';

abstract class ResetPasswordStates{}

class ResetPasswordInitialState extends ResetPasswordStates{}
////////////////////////////////////////////////////////////////////////////////
class CreateNewPasswordLoading extends ResetPasswordStates{}
class CreateNewPasswordFailure extends ResetPasswordStates{
  String? message;
  CreateNewPasswordFailure(this.message);
}
class CreateNewPasswordSuccess extends ResetPasswordStates{
  CreateNewPasswordEntity createNewPasswordEntity;
  CreateNewPasswordSuccess(this.createNewPasswordEntity);
}
class CreateNewPasswordError extends ResetPasswordStates{
  String? message;
  CreateNewPasswordError(this.message);
}
////////////////////////////////////////////////////////////////////////////////
class ResendForgetPasswordLoading extends ResetPasswordStates{}
class ResendForgetPasswordFailure extends ResetPasswordStates{
  String? message;
  ResendForgetPasswordFailure(this.message);
}
class ResendForgetPasswordSuccess extends ResetPasswordStates{
  ResendCodeEntity resendCodeEntity;
  ResendForgetPasswordSuccess(this.resendCodeEntity);
}
class ResendForgetPasswordError extends ResetPasswordStates{
  String? message;
  ResendForgetPasswordError(this.message);
}
////////////////////////////////////////////////////////////////////////////////
class ResetPasswordLoading extends ResetPasswordStates{}
class ResetPasswordFailure extends ResetPasswordStates{
  String? message;
  ResetPasswordFailure(this.message);
}
class ResetPasswordSuccess extends ResetPasswordStates{
  ResetPasswordEntity resetPasswordEntity;
  ResetPasswordSuccess(this.resetPasswordEntity);
}
class ResetPasswordError extends ResetPasswordStates{
  String? message;
  ResetPasswordError(this.message);
}
////////////////////////////////////////////////////////////////////////////////
class VerifyMobileForgetLoading extends ResetPasswordStates{}
class VerifyMobileForgetFailure extends ResetPasswordStates{
  String? message;
  VerifyMobileForgetFailure(this.message);
}
class VerifyMobileForgetSuccess extends ResetPasswordStates{
  VerifyForgetPasswordEntity verifyForgetPasswordEntity;
  VerifyMobileForgetSuccess(this.verifyForgetPasswordEntity);
}
class VerifyMobileForgetError extends ResetPasswordStates{
  String? message;
  VerifyMobileForgetError(this.message);
}
////////////////////////////////////////////////////////////////////////////////
class CheckDifferenceState extends ResetPasswordStates{}
class RemoveDateState extends ResetPasswordStates{}
////////////////////////////////////////////////////////////////////////////////
