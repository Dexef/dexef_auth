import '../../domain/entity/login_google_entity.dart';
import '../../domain/entity/login_normal_entity.dart';
import '../../domain/entity/login_apple_entity.dart';
import '../../domain/entity/validate_email_entity.dart';

abstract class LoginState {}

class LoginInitial extends LoginState {}
//////////////////////////////////////////////////////////////////////////////// validate email
class ValidateEmailLoading extends LoginInitial{}
class ValidateEmailSuccess extends LoginInitial{
  ValidateEmailEntity? validateEmailEntity;
  ValidateEmailSuccess({this.validateEmailEntity});
}
class ValidateEmailError extends LoginInitial{
  String? message;
  ValidateEmailError(this.message);
}
class ValidateEmailFailure extends LoginInitial{
  String? message;
  ValidateEmailFailure(this.message);
}
//////////////////////////////////////////////////////////////////////////////// normal login
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
  String error;
  LoginError(this.error);
}
//////////////////////////////////////////////////////////////////////////////// dial code
class GettingDialCode extends LoginInitial {}
class AdminSignDialCodeError extends LoginInitial {}
//////////////////////////////////////////////////////////////////////////////// sign in google mobile firebase
class SignInWithGoogleMobileLoading extends LoginInitial {}

class SignInWithGoogleMobileSuccess extends LoginInitial {}

class SignInWithGoogleMobileError extends LoginInitial {
  String? message;
  SignInWithGoogleMobileError(this.message);
}
//////////////////////////////////////////////////////////////////////////////// sign in google web firebase
class SignInWithGoogleWebLoading extends LoginInitial {}
class SignInWithGoogleWebSuccess extends LoginInitial {}
class SignInWithGoogleWebError extends LoginInitial {
  String? message;
  SignInWithGoogleWebError(this.message);
}
class CanceledByUserWebGoogle extends LoginInitial {}
//////////////////////////////////////////////////////////////////////////////// login with google
class LoginWithGoogleLoading extends LoginInitial {}
class LoginWithGoogleSuccess extends LoginInitial {
  GoogleSignInEntity googleSignInEntity;
  LoginWithGoogleSuccess(this.googleSignInEntity);
}
class LoginWithGoogleError extends LoginInitial {
  String? message;
  LoginWithGoogleError(this.message);
}
class LoginWithGoogleFailure extends LoginInitial {
  String? message;
  LoginWithGoogleFailure(this.message);
}
//////////////////////////////////////////////////////////////////////////////// Sign in apple firebase
class SignInAppleLoadingFirebase extends LoginInitial{}
class SignInAppleSuccessFirebase extends LoginInitial{}
class SignInAppleErrorFirebase extends LoginInitial{
  String? message;
  SignInAppleErrorFirebase(this.message);
}
//////////////////////////////////////////////////////////////////////////////// login in apple
class LoginWithAppleLoading extends LoginInitial{}
class LoginWithAppleFailure extends LoginInitial{
  String? message;
  LoginWithAppleFailure(this.message);
}
class LoginWithAppleSuccess extends LoginInitial{
  SocialEntity socialEntity;
  LoginWithAppleSuccess(this.socialEntity);
}
class LoginWithAppleError extends LoginInitial{
  String? message;
  LoginWithAppleError(this.message);
}
//////////////////////////////////////////////////////////////////////////////// sign out
class SignOutGoogleLoading extends LoginInitial {}

class SignOutGoogleSuccess extends LoginInitial {}

class SignOutGoogleWebSuccess extends LoginInitial {}

class SignOutGoogleError extends LoginInitial {}

class SignOutGoogleWebError extends LoginInitial {}
//////////////////////////////////////////////////////////////////////////////// Change Message
class ChangeMessageErrorState extends LoginInitial{}
//////////////////////////////////////////////////////////////////////////////// modify data
class ModifyDataState extends LoginInitial{}
//////////////////////////////////////////////////////////////////////////////// search countries
class SearchStartingLoading extends LoginInitial{}
class SearchEndState extends LoginInitial{}
//////////////////////////////////////////////////////////////////////////////// GetIP For Country
class GetIPForCountryLoading extends LoginInitial{}
class GetIPForCountrySuccessful extends LoginInitial{}
class GetIPForCountryError extends LoginInitial{
  String? message;
  GetIPForCountryError(this.message);
}
class GetIPForCountryFailure extends LoginInitial{
  String? message;
  GetIPForCountryFailure(this.message);
}
////////////////////////////////////////////////////////////////////////////////
