

import '../../../register/domain/entity/register_apple_entity.dart';
import '../../../register/domain/entity/register_with_facebook_entity.dart';
import '../../../domain/entity/register_with_google_entity.dart';

abstract class VerifyPhoneGoogleFaceStates{}

class InitialRegisterByGoogleState extends VerifyPhoneGoogleFaceStates{}

class RegisterByGoogleStateLoading extends VerifyPhoneGoogleFaceStates{}

class RegisterByGoogleStateSuccess extends VerifyPhoneGoogleFaceStates{
  RegisterByGoogleEntity registerByGoogleEntity;
  RegisterByGoogleStateSuccess(this.registerByGoogleEntity);
}

class RegisterByGoogleStateError extends VerifyPhoneGoogleFaceStates{
  RegisterByGoogleEntity registerByGoogleEntity;
  RegisterByGoogleStateError(this.registerByGoogleEntity);
}

class RegisterByGoogleStateFailure extends VerifyPhoneGoogleFaceStates{
  String message;
  RegisterByGoogleStateFailure(this.message);
}
////////////////////////////////////////////////////////////////////////////////
class RegisterFacebookLoading extends VerifyPhoneGoogleFaceStates{}

class RegisterFacebookSuccess extends VerifyPhoneGoogleFaceStates{
  RegisterFacebookEntity registerFacebookEntity;
  RegisterFacebookSuccess(this.registerFacebookEntity);
}

class RegisterFacebookError extends VerifyPhoneGoogleFaceStates{
  RegisterFacebookEntity registerFacebookEntity;
  RegisterFacebookError(this.registerFacebookEntity);
}

class RegisterFacebookFailure extends VerifyPhoneGoogleFaceStates{
  String message;
  RegisterFacebookFailure(this.message);
}
////////////////////////////////////////////////////////////////////////////////
class RegisterAppleLoading extends VerifyPhoneGoogleFaceStates{}

class RegisterAppleSuccess extends VerifyPhoneGoogleFaceStates{
  RegisterAppleEntity registerAppleEntity;
  RegisterAppleSuccess(this.registerAppleEntity);
}

class RegisterAppleError extends VerifyPhoneGoogleFaceStates{
  RegisterAppleEntity registerAppleEntity;
  RegisterAppleError(this.registerAppleEntity);
}

class RegisterAppleFailure extends VerifyPhoneGoogleFaceStates{
  String message;
  RegisterAppleFailure(this.message);
}
////////////////////////////////////////////////////////////////////////////////