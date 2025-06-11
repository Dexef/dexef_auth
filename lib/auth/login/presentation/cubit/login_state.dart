import '../../domain/entity/google_signIn_entity.dart';
import '../../domain/entity/login_entity.dart';
import '../../domain/entity/social_entity.dart';
import '../../domain/entity/validate_email_entity.dart';

abstract class LoginState {}

class LoginInitial extends LoginState {}
////////////////////////////////////////////////////////////////////////////////
class LoginLoading extends LoginInitial {}
class LoginNetworkFailed extends LoginInitial {
  String message;
  LoginNetworkFailed(this.message);
}
class LoginSuccess extends LoginInitial {
  LoginEntity loginEntity;
  LoginSuccess(this.loginEntity);
}
class LoginUnSuccess extends LoginInitial {
  String errorTxt;
  LoginUnSuccess(this.errorTxt);
}
////////////////////////////////////////////////////////////////////////////////
class AdminLogInError extends LoginInitial {}

class AdminSignDialCodeError extends LoginInitial {}

class LoadingState extends LoginInitial {}

///////////////////////////////////////////////////////////////////////// method sign in with google android
class LogInWithGoogleLoading extends LoginInitial {}

class LogInWithGoogleSuccess extends LoginInitial {}

class LogInWithGoogleError extends LoginInitial {}

///////////////////////////////////////////////////////////////////////// cubit login with google states
class LoginWithGoogleLoading extends LoginInitial {}

class LoginWithGoogleSuccess extends LoginInitial {
  GoogleSignInEntity googleSignInEntity;

  LoginWithGoogleSuccess(this.googleSignInEntity);
}

class LoginWithGoogleError extends LoginInitial {
  GoogleSignInEntity googleSignInEntity;

  LoginWithGoogleError(this.googleSignInEntity);
}

class LoginWithGoogleFailure extends LoginInitial {
  String message;

  LoginWithGoogleFailure(this.message);
}

////////////////////////////////////////////////////////////////////////// method sign in with google web
class LogInWithGoogleWebSuccess extends LoginInitial {}

class LogInWithGoogleWebError extends LoginInitial {}

class LogInWithGoogleWebLoading extends LoginInitial {}

////////////////////////////////////////////////////////////////////////// Sign in with facebook android
class LogInWithFacebookSuccess extends LoginInitial {}

class LogInWithFacebookError extends LoginInitial {}

class LogInWithFacebookLoading extends LoginInitial {}

///////////////////////////////////////////////////////////////////////// Sign in with facebook web
class LogInWithFacebookWebSuccess extends LoginInitial {}

class LogInWithFacebookWebError extends LoginInitial {}

class LogInWithFacebookWebLoading extends LoginInitial {}

////////////////////////////////////////////////////////////////////////// cubit state to login with facebook
class LoginWithFacebookLoading extends LoginInitial {}

class LoginWithFacebookError extends LoginInitial {
  String errorText;

  LoginWithFacebookError(this.errorText);
}

class LoginWithFacebookFailure extends LoginInitial {
  String message;

  LoginWithFacebookFailure(this.message);
}

////////////////////////////////////////////////////////////////////////////
class SignOutGoogleLoading extends LoginInitial {}

class SignOutGoogleSuccess extends LoginInitial {}

class SignOutGoogleWebSuccess extends LoginInitial {}

class SignOutGoogleError extends LoginInitial {}

class SignOutGoogleWebError extends LoginInitial {}

class SignInWithGoogleWebError extends LoginInitial {}

class SignInWithGoogleWebLoading extends LoginInitial {}

class CanceledByUserWebGoogle extends LoginInitial {}

////////////////////////////////////////////////////////////////////////// Sign in with facebook android
class SignInWithFacebookSuccess extends LoginInitial {}

class SignInWithFacebookError extends LoginInitial {}

class SignInWithFacebookLoading extends LoginInitial {}

///////////////////////////////////////////////////////////////////////// Sign in with facebook web
class SignInWithFacebookWebSuccess extends LoginInitial {}

class SignInWithFacebookWebError extends LoginInitial {}

class SignInWithFacebookWebLoading extends LoginInitial {}

class SignInWithGoogleLoading extends LoginInitial {}

class SignInWithGoogleSuccess extends LoginInitial {}

class SignInWithGoogleError extends LoginInitial {}

class SignInWithGoogleWebSuccess extends LoginInitial {}

class GettingDialCode extends LoginInitial {}
///////////////////////////////////////////////////////////////////////// Sign in apple
class AppleSignInLoading extends LoginInitial{}
class AppleSignInFailure extends LoginInitial{
  String message;
  AppleSignInFailure(this.message);
}
class AppleSignInSuccess extends LoginInitial{
  SocialEntity socialEntity;
  AppleSignInSuccess(this.socialEntity);
}
class AppleSignInError extends LoginInitial{
  String message;
  AppleSignInError(this.message);
}
///////////////////////////////////////////////////////////////////////// Sign in apple
class SignUpAppleLoading extends LoginInitial{}
class SignUpAppleSuccess extends LoginInitial{}
class SignUpAppleFirstSuccess extends LoginInitial{}
class SignUpAppleError extends LoginInitial{}
/////////////////////////////////////////////////////////////////////////
class ValidateEmailLoading extends LoginInitial{}

class ValidateEmailSuccess extends LoginInitial{
  ValidateEmailEntity? validateEmailEntity;
  ValidateEmailSuccess({this.validateEmailEntity});
}

class ValidateEmailError extends LoginInitial{
  ValidateEmailEntity? validateEmailEntity;
  ValidateEmailError({this.validateEmailEntity});
}

class ValidateEmailFailure extends LoginInitial{}
/////////////////////////////////////////////////////////////////////////

class SignUpGoogleWebLoading extends LoginInitial{}

class SignUpFirstGoogleWebSuccess extends LoginInitial{}

class CanceledSignUpByUserWebGoogle extends LoginInitial{
  String error;
  CanceledSignUpByUserWebGoogle(this.error);
}

class SignUpGoogleWebError extends LoginInitial{
  String error;
  SignUpGoogleWebError(this.error);
}
////////////////////////////////////////////////////////////////////////////////
class ChangeMessageErrorState extends LoginInitial{}
class ModifyDataState extends LoginInitial{}
class CountryCodeLoadingState extends LoginInitial{}
class CountryCodeSuccessState extends LoginInitial{}

////////////////////////////////////////////////////////////////////////////////
class GetIPForCountryLoading extends LoginInitial{}
class GetIPForCountrySuccessful extends LoginInitial{}
class GetIPForCountryError extends LoginInitial{}
class GetIPForCountryFailure extends LoginInitial{}
////////////////////////////////////////////////////////////////////////////////
class SearchStartingLoading extends LoginInitial{}
class SearchEndState extends LoginInitial{}