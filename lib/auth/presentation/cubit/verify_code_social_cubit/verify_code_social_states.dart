import '../../../login/domain/entity/google_signIn_entity.dart';
import '../../../login/domain/entity/sign_in_with_facebook_entity.dart';
import '../../../login/domain/entity/social_entity.dart';
import '../../../domain/entity/verify_code_entity.dart';

abstract class VerifyCodeSocialStates{}

class InitialVerifyCodeSocialState extends VerifyCodeSocialStates{}
////////////////////////////////////////////////////////////////////////////////
class VerifyCodeGoogleFaceLoading extends VerifyCodeSocialStates{}
class VerifyCodeGoogleFaceFailure extends VerifyCodeSocialStates{
  String message;
  VerifyCodeGoogleFaceFailure(this.message);
}
class VerifyCodeGoogleSuccess extends VerifyCodeSocialStates{
  VerifyCodeEntity verifyCodeEntity;
  VerifyCodeGoogleSuccess(this.verifyCodeEntity);
}
class VerifyCodeFaceSuccess extends VerifyCodeSocialStates{
  VerifyCodeEntity verifyCodeEntity;
  VerifyCodeFaceSuccess(this.verifyCodeEntity);
}
class VerifyCodeGoogleFaceError extends VerifyCodeSocialStates{
  VerifyCodeEntity verifyCodeEntity;
  VerifyCodeGoogleFaceError(this.verifyCodeEntity);
}
////////////////////////////////////////////////////////////////////////////////
class SignInWithGoogleStartLoading extends VerifyCodeSocialStates{}
class SignInWithGoogleFailure extends VerifyCodeSocialStates{
  String message;
  SignInWithGoogleFailure(this.message);
}
class SignInWithGoogleSuccess extends VerifyCodeSocialStates{
  GoogleSignInEntity googleSignInEntity;
  SignInWithGoogleSuccess(this.googleSignInEntity);
}
class SignInWithGoogleError extends VerifyCodeSocialStates{
  GoogleSignInEntity googleSignInEntity;
  SignInWithGoogleError(this.googleSignInEntity);
}
////////////////////////////////////////////////////////////////////////////////
class SignInWithFaceLoading extends VerifyCodeSocialStates{}
class SignInWithFaceFailure extends VerifyCodeSocialStates{
  String message;
  SignInWithFaceFailure(this.message);
}
class SignInWithFaceSuccess extends VerifyCodeSocialStates{
  SignInFacebookEntity signInFacebookEntity;
  SignInWithFaceSuccess(this.signInFacebookEntity);
}
class SignInWithFaceError extends VerifyCodeSocialStates{
  SignInFacebookEntity signInFacebookEntity;
  SignInWithFaceError(this.signInFacebookEntity);
}
////////////////////////////////////////////////////////////////////////////////

class ResendLoadingState extends VerifyCodeSocialStates{}
class ResendCodeFailed extends VerifyCodeSocialStates{
  String message;
  ResendCodeFailed(this.message);
}
class ResendCodeSuccess extends VerifyCodeSocialStates{
  ResendCodeSuccess();
}

class ResendCodeError extends VerifyCodeSocialStates{
  String message;
  ResendCodeError(this.message);
}
////////////////////////////////////////////////////////////////////////////////
class AppleSignInLoading extends VerifyCodeSocialStates{}
class AppleSignInFailure extends VerifyCodeSocialStates{
  String message;
  AppleSignInFailure(this.message);
}
class AppleSignInSuccess extends VerifyCodeSocialStates{
  SocialEntity socialEntity;
  AppleSignInSuccess(this.socialEntity);
}
class AppleSignInError extends VerifyCodeSocialStates{
  String message;
  AppleSignInError(this.message);
}
////////////////////////////////////////////////////////////////////////////////