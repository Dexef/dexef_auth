
import '../../../register/domain/entity/resend_code_entity.dart';
import '../../../resetPassword/domain/entity/reset_password_entity.dart';
import '../../../domain/entity/verify_code_entity.dart';

abstract class VerifyCodeStates{}

class VerifyCodeInitialState extends VerifyCodeStates{}

class VerifyLoadingState extends VerifyCodeStates{}

class ChangePhoneLoadingState extends VerifyCodeStates{}

class VerifyCodeSuccess extends VerifyCodeStates{
  VerifyCodeEntity verifyCodeEntity;
  VerifyCodeSuccess(this.verifyCodeEntity);
}

class VerifyCodeFailed extends VerifyCodeStates{
  String message;
  VerifyCodeFailed(this.message);

}class VerifyCodeError extends VerifyCodeStates{
  String message;
  VerifyCodeError(this.message);
}

class ResendCodeLoading extends VerifyCodeStates{}


class ResendCodeSuccess extends VerifyCodeStates{
  ResendCodeEntity resendCodeEntity;
  ResendCodeSuccess(this.resendCodeEntity);
}

class ResendCodeFailed extends VerifyCodeStates{
  String message;
  ResendCodeFailed(this.message);
}

class ResendCodeError extends VerifyCodeStates{
  String message;
  ResendCodeError(this.message);
}
//
// class AdminSignInSuccess extends VerifyCodeStates{}
//
// class AdminSignInFailed extends VerifyCodeStates{}
//
// class AdminSignInError extends VerifyCodeStates{}

class SignInWithGoogleLoading extends VerifyCodeStates{}

class SignInWithGoogleStateSuccess extends VerifyCodeStates{
  // SignInGoogleEntity signInGoogleEntity;
  // SignInWithGoogleStateSuccess(this.signInGoogleEntity);
}

class SignInWithGoogleStateError extends VerifyCodeStates{
  // SignInGoogleEntity signInGoogleEntity;
  // SignInWithGoogleStateError(this.signInGoogleEntity);
}

class SignInWithGoogleStateFailure extends VerifyCodeStates{
  String message;
  SignInWithGoogleStateFailure(this.message);
}

class ChangePhoneNumberSuccess extends VerifyCodeStates{
  int mobileID;
  ChangePhoneNumberSuccess(this.mobileID);
}

class ChangePhoneNumberFailed extends VerifyCodeStates{
  String message;
  ChangePhoneNumberFailed(this.message);
}

class ChangePhoneNumberError extends VerifyCodeStates{
  String message;
  ChangePhoneNumberError(this.message);
}

class AdminSignDialCodeError extends VerifyCodeStates{}

class LoginLoading extends VerifyCodeStates{}

class LoginNetworkFailed extends VerifyCodeStates{}

class LoginSuccess extends VerifyCodeStates{}

class LoginUnSuccess extends VerifyCodeStates{}

class FormFailed extends VerifyCodeStates{}

class WhatsappCodeChecked extends VerifyCodeStates{}

class SmsCodeChecked extends VerifyCodeStates{}

class SendSmsLoading extends VerifyCodeStates{}

class SendSmsSuccess extends VerifyCodeStates{
  // SignInGoogleEntity signInGoogleEntity;
  // SignInWithGoogleStateSuccess(this.signInGoogleEntity);
}

class SendSmsError extends VerifyCodeStates{
  String message;
  SendSmsError(this.message);
}

class SendSmsFailure extends VerifyCodeStates{
  String message;
  SendSmsFailure(this.message);
}

class ResetPasswordLoadingState extends VerifyCodeStates{}

class ResetPasswordSuccess extends VerifyCodeStates{
  ResetPasswordEntity? resetPasswordEntity;
  ResetPasswordSuccess(this.resetPasswordEntity);
}

class ResetPasswordError extends VerifyCodeStates{
  String message;
  ResetPasswordError(this.message);
}

class ResetPasswordFailure extends VerifyCodeStates{
  String message;
  ResetPasswordFailure(this.message);
}

class CheckDifferenceState extends VerifyCodeStates{}

class RemoveDateState extends VerifyCodeStates{}

class  UpdateMobileLoading extends VerifyCodeStates {}

class UpdateMobileFailure extends VerifyCodeStates {
  String message;
  UpdateMobileFailure(this.message);
}

class UpdateMobileSuccess extends VerifyCodeStates {}

class UpdateMobileError extends VerifyCodeStates {
  String message;
  UpdateMobileError(this.message);
}

class VerifyMobileLoading extends VerifyCodeStates {}

class VerifyMobileFailure extends VerifyCodeStates {
  String message;
  VerifyMobileFailure(this.message);
}

class VerifyMobileSuccess extends VerifyCodeStates {}

class VerifyMobileError extends VerifyCodeStates {
  String message;
  VerifyMobileError(this.message);
}
