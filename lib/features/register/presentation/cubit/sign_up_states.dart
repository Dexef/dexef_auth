import 'package:auth_dexef/core/rest/error_model.dart';

import '../../../login/domain/entity/validate_email_entity.dart';
import '../../domain/entity/register_google_entity.dart';
import '../../domain/entity/resend_code_entity.dart';

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
////////////////////////////////////////////////////////////////////////////////
// class SignUpSuccess extends RegisterStates{
//   int mobileID;
//   SignUpSuccess(this.mobileID);
// }
//
// class SignUpFailed extends RegisterStates{
//   String message;
//   List<Errors> signUpErrors;
//   SignUpFailed(this.message,this.signUpErrors);
// }
// class SignUpUnSuccess extends RegisterStates{
//   String message;
//   SignUpUnSuccess(this.message);
// }

class ConfirmEmailSuccess extends RegisterStates{}

class ConfirmEmailFailed extends RegisterStates{}

class NetworkError extends RegisterStates{
  String message;
  NetworkError(this.message);
}

class LoadingState extends RegisterStates{}
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
//////////////////////////////////////////////////////////////////////////////// sign up facebook android
class SignUpFaceBookLoading extends RegisterStates{}

class SignUpFaceBookSuccess extends RegisterStates{}

class SignUpFaceBookError extends RegisterStates{
  String? message;
  SignUpFaceBookError({this.message});
}
//////////////////////////////////////////////////////////////////////////////// sign up facebook web
class SignUpFaceBookWebLoading extends RegisterStates{}

class SignUpFaceBookWebSuccess extends RegisterStates{
}

class SignUpFaceBookWebError extends RegisterStates{
  String? message;
  SignUpFaceBookWebError({this.message});
}

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