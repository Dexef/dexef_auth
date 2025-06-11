import 'package:auth_dexef/core/rest/error_model.dart';

import '../../../login/domain/entity/validate_email_entity.dart';
import '../../domain/entity/resend_code_entity.dart';

abstract class SignUpStates{}

class SignUpInitialState extends SignUpStates{}

class SignUpSuccess extends SignUpInitialState{
  int mobileID;
  SignUpSuccess(this.mobileID);
}

class SignUpFailed extends SignUpInitialState{
  String message;
  List<Errors> signUpErrors;
  SignUpFailed(this.message,this.signUpErrors);
}
class SignUpUnSuccess extends SignUpInitialState{
  String message;
  SignUpUnSuccess(this.message);
}

class ConfirmEmailSuccess extends SignUpInitialState{}

class ConfirmEmailFailed extends SignUpInitialState{}

class NetworkError extends SignUpInitialState{
  String message;
  NetworkError(this.message);
}

class LoadingState extends SignUpInitialState{}
//////////////////////////////////////////////////////////////////////////////// sign Up with google
class SignUpGoogleSuccess extends SignUpInitialState{}

class SignUpGoogleLoading extends SignUpInitialState{}

class SignUpGoogleError extends SignUpInitialState{
  String message;
  SignUpGoogleError(this.message);
}
//////////////////////////////////////////////////////////////////////////////// sign up with google web
class SignUpGoogleWebLoading extends SignUpInitialState{}

class SignUpGoogleWebSuccess extends SignUpInitialState{}

class SignUpGoogleWebError extends SignUpInitialState{
  String message;
  SignUpGoogleWebError(this.message);
}

class CanceledSignUpByUserWebGoogle extends SignUpInitialState{
  String message;
  CanceledSignUpByUserWebGoogle(this.message);
}
//////////////////////////////////////////////////////////////////////////////// sign out from google
class SignOutGoogleLoading extends SignUpInitialState{}

class SignOutGoogleSuccess extends SignUpInitialState{}

class SignOutGoogleError extends SignUpInitialState{}
//////////////////////////////////////////////////////////////////////////////// sign up facebook android
class SignUpFaceBookLoading extends SignUpInitialState{}

class SignUpFaceBookSuccess extends SignUpInitialState{}

class SignUpFaceBookError extends SignUpInitialState{
  String? message;
  SignUpFaceBookError({this.message});
}
//////////////////////////////////////////////////////////////////////////////// sign up facebook web
class SignUpFaceBookWebLoading extends SignUpInitialState{}

class SignUpFaceBookWebSuccess extends SignUpInitialState{
}

class SignUpFaceBookWebError extends SignUpInitialState{
  String? message;
  SignUpFaceBookWebError({this.message});
}

class ChangePasswordVisible extends SignUpInitialState{}

////////////////////////////////////////////////////////////////////////////////
class SignUpAppleLoading extends SignUpInitialState{}
class SignUpAppleSuccess extends SignUpInitialState{}
class SignUpAppleError extends SignUpInitialState{}

class ValidateEmailLoading extends SignUpInitialState{}

class ValidateEmailFailure extends SignUpInitialState{}

class ValidateEmailSuccess extends SignUpInitialState{
  ValidateEmailEntity? validateEmailEntity;
  ValidateEmailSuccess({this.validateEmailEntity});
}

class ValidateEmailError extends SignUpInitialState{}

class LookUpUserSuccess extends SignUpInitialState{}
////////////////////////////////////////////////////////////////////////////////
class ResendCodeLoading extends SignUpInitialState{}
class ResendCodeSuccess extends SignUpInitialState{
  ResendCodeEntity resendCodeEntity;
  ResendCodeSuccess(this.resendCodeEntity);
}
class ResendCodeError extends SignUpInitialState{
  String? message;
  ResendCodeError(this.message);
}
class ResendCodeFailure extends SignUpInitialState{
  String? message;
  ResendCodeFailure(this.message);
}
////////////////////////////////////////////////////////////////////////////////