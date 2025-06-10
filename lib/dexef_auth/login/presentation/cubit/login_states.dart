import '../../domain/entity/google_signIn_entity.dart';
import '../../domain/entity/login_entity.dart';
import '../../domain/entity/social_entity.dart';
import '../../domain/entity/validate_email_entity.dart';

abstract class LoginState {}

class LoginInitial extends LoginState {}
////////////////////////////////////////////////////////////////////////////////
class LoginLoading extends LoginInitial {}
class LoginFailure extends LoginInitial {
  String? message;
  LoginFailure(this.message);
}
class LoginSuccess extends LoginInitial {
  LoginEntity loginEntity;
  LoginSuccess(this.loginEntity);
}
class LoginError extends LoginInitial {
  String? error;
  LoginError(this.error);
}
////////////////////////////////////////////////////////////////////////////////
class GoogleLoginLoading extends LoginInitial {}
class GoogleLoginSuccess extends LoginInitial {
  GoogleSignInEntity googleSignInEntity;
  GoogleLoginSuccess(this.googleSignInEntity);
}
class GoogleLoginError extends LoginInitial {
  String? message;
  GoogleLoginError(this.message);
}
class GoogleLoginFailure extends LoginInitial {
  String? message;
  GoogleLoginFailure(this.message);
}
////////////////////////////////////////////////////////////////////////////////
class AppleLoginLoading extends LoginInitial{}
class AppleLoginFailure extends LoginInitial{
  String? message;
  AppleLoginFailure(this.message);
}
class AppleLoginSuccess extends LoginInitial{
  SocialEntity socialEntity;
  AppleLoginSuccess(this.socialEntity);
}
class AppleLoginError extends LoginInitial{
  String? message;
  AppleLoginError(this.message);
}
////////////////////////////////////////////////////////////////////////////////
class ValidateEmailLoading extends LoginInitial{}
class ValidateEmailSuccess extends LoginInitial{
  ValidateEmailEntity? validateEmailEntity;
  ValidateEmailSuccess({this.validateEmailEntity});
}
class ValidateEmailError extends LoginInitial{
  String? error;
  ValidateEmailError(this.error);
}
class ValidateEmailFailure extends LoginInitial{
  String? error;
  ValidateEmailFailure({this.error});
}
////////////////////////////////////////////////////////////////////////////////
class GetIPForCountryLoading extends LoginInitial{}
class GetIPForCountrySuccess extends LoginInitial{}
class GetIPForCountryError extends LoginInitial{
  String? error;
  GetIPForCountryError({this.error});
}
class GetIPForCountryFailure extends LoginInitial{
  String? error;
  GetIPForCountryFailure({this.error});
}
////////////////////////////////////////////////////////////////////////////////
class GoogleFirebaseLoginWebLoading extends LoginInitial {}
class GoogleFirebaseLoginWebSuccess extends LoginInitial {}
class GoogleFirebaseLoginWebError extends LoginInitial {}
class CanceledByUserWebGoogle extends LoginInitial {}
////////////////////////////////////////////////////////////////////////////////
class GettingDialCode extends LoginInitial {}
class AdminSignDialCodeError extends LoginInitial {}
////////////////////////////////////////////////////////////////////////////////
class ModifyDataState extends LoginInitial {}
////////////////////////////////////////////////////////////////////////////////
class ChangeMessageErrorState extends LoginInitial {}
////////////////////////////////////////////////////////////////////////////////
class GoogleLoginFirebaseWebLoading extends LoginInitial {}
class GoogleLoginFirebaseWebSuccess extends LoginInitial {}
class GoogleLoginFirebaseWebError extends LoginInitial {
  String? message;
  GoogleLoginFirebaseWebError(this.message);
}
////////////////////////////////////////////////////////////////////////////////
class AppleLoginFirebaseWebLoading extends LoginInitial {}
class AppleLoginFirebaseWebSuccess extends LoginInitial {}
class AppleLoginFirebaseWebError extends LoginInitial {}
////////////////////////////////////////////////////////////////////////////////
class SearchStartingLoading extends LoginInitial {}
class SearchEndState extends LoginInitial {}
////////////////////////////////////////////////////////////////////////////////
class GoogleFirebaseLoginMobileLoading extends LoginInitial {}
class GoogleFirebaseLoginMobileSuccess extends LoginInitial {}
class GoogleFirebaseLoginMobileError extends LoginInitial {}

