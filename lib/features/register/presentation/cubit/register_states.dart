import 'package:auth_dexef/core/rest/error_model.dart';

import '../../../login/domain/entity/validate_email_entity.dart';
import '../../domain/entity/change_mobile_entity.dart';
import '../../domain/entity/register_apple_entity.dart';
import '../../domain/entity/register_google_entity.dart';
import '../../domain/entity/resend_code_entity.dart';
import '../../domain/entity/send_sms_entity.dart';
import '../../domain/entity/verify_code_entity.dart';

abstract class RegisterStates{}

class RegisterInitialState extends RegisterStates{}
//////////////////////////////////////////////////////////////////////////////// register normal
class RegisterNormalLoading extends RegisterStates{}
class RegisterNormalSuccess extends RegisterStates{
  int mobileID;
  RegisterNormalSuccess(this.mobileID);
}
class RegisterNormalFailure extends RegisterStates{
  String? message;
  RegisterNormalFailure(this.message);
}
class RegisterNormalError extends RegisterStates{
  String? message;
  RegisterNormalError(this.message);
}
//////////////////////////////////////////////////////////////////////////////// register google
class RegisterGoogleLoading extends RegisterStates{}
class RegisterGoogleSuccess extends RegisterStates{
  RegisterGoogleEntity registerGoogleEntity;
  RegisterGoogleSuccess(this.registerGoogleEntity);
}
class RegisterGoogleFailure extends RegisterStates{
  String? message;
  RegisterGoogleFailure(this.message);
}
class RegisterGoogleError extends RegisterStates{
  String? message;
  RegisterGoogleError(this.message);
}
//////////////////////////////////////////////////////////////////////////////// sign Up with google
class SignUpGoogleSuccess extends RegisterStates{}

class SignUpGoogleLoading extends RegisterStates{}

class SignUpGoogleError extends RegisterStates{
  String message;
  SignUpGoogleError(this.message);
}
//////////////////////////////////////////////////////////////////////////////// sign up with google web
class SignUpGoogleWebLoading extends RegisterStates{}

class SignUpGoogleWebSuccess extends RegisterStates{}

class SignUpGoogleWebError extends RegisterStates{
  String message;
  SignUpGoogleWebError(this.message);
}

class CanceledSignUpByUserWebGoogle extends RegisterStates{
  String message;
  CanceledSignUpByUserWebGoogle(this.message);
}
//////////////////////////////////////////////////////////////////////////////// sign out from google
class SignOutGoogleLoading extends RegisterStates{}

class SignOutGoogleSuccess extends RegisterStates{}

class SignOutGoogleError extends RegisterStates{}
////////////////////////////////////////////////////////////////////////////////

class ChangePasswordVisible extends RegisterStates{}

////////////////////////////////////////////////////////////////////////////////
class SignUpAppleLoading extends RegisterStates{}
class SignUpAppleSuccess extends RegisterStates{}
class SignUpAppleError extends RegisterStates{}

class ValidateEmailLoading extends RegisterStates{}

class ValidateEmailFailure extends RegisterStates{}

class ValidateEmailSuccess extends RegisterStates{
  ValidateEmailEntity? validateEmailEntity;
  ValidateEmailSuccess({this.validateEmailEntity});
}

class ValidateEmailError extends RegisterStates{}

class LookUpUserSuccess extends RegisterStates{}
////////////////////////////////////////////////////////////////////////////////
class ResendCodeLoading extends RegisterStates{}
class ResendCodeSuccess extends RegisterStates{
  ResendCodeEntity resendCodeEntity;
  ResendCodeSuccess(this.resendCodeEntity);
}
class ResendCodeError extends RegisterStates{
  String? message;
  ResendCodeError(this.message);
}
class ResendCodeFailure extends RegisterStates{
  String? message;
  ResendCodeFailure(this.message);
}
////////////////////////////////////////////////////////////////////////////////
class SendCodeLoading extends RegisterStates{}
class SendCodeSuccess extends RegisterStates{
  SendSmsEntity sendSmsEntity;
  SendCodeSuccess(this.sendSmsEntity);
}
class SendCodeError extends RegisterStates{
  String? message;
  SendCodeError(this.message);
}
class SendCodeFailure extends RegisterStates{
  String? message;
  SendCodeFailure(this.message);
}
////////////////////////////////////////////////////////////////////////////////
class VerifyMobileLoading extends RegisterStates{}
class VerifyMobileSuccess extends RegisterStates{
  VerifyCodeEntity verifyCodeEntity;
  VerifyMobileSuccess(this.verifyCodeEntity);
}
class VerifyMobileError extends RegisterStates{
  String? message;
  VerifyMobileError(this.message);
}
class VerifyMobileFailure extends RegisterStates{
  String? message;
  VerifyMobileFailure(this.message);
}
////////////////////////////////////////////////////////////////////////////////
class ChangeMobileLoading extends RegisterStates{}
class ChangeMobileSuccess extends RegisterStates{
  ChangeMobileEntity changeMobileEntity;
  ChangeMobileSuccess(this.changeMobileEntity);
}
class ChangeMobileError extends RegisterStates{
  String? message;
  ChangeMobileError(this.message);
}
class ChangeMobileFailure extends RegisterStates{
  String? message;
  ChangeMobileFailure(this.message);
}
////////////////////////////////////////////////////////////////////////////////
class RegisterAppleLoading extends RegisterStates{}
class RegisterAppleSuccess extends RegisterStates{
  RegisterAppleEntity registerAppleEntity;
  RegisterAppleSuccess(this.registerAppleEntity);
}
class RegisterAppleFailure extends RegisterStates{
  String? message;
  RegisterAppleFailure(this.message);
}
class RegisterAppleError extends RegisterStates{
  String? message;
  RegisterAppleError(this.message);
}