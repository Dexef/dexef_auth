
import '../../domain/entity/create_new_password_entity.dart';

abstract class ResetPasswordStates{}

class ResetPasswordInitialState extends ResetPasswordStates{}

class ResetPasswordSuccess extends ResetPasswordInitialState{
  int mobileID;
  ResetPasswordSuccess(this.mobileID);
}

class ResetPasswordFailed extends ResetPasswordInitialState{
  String message;
  ResetPasswordFailed(this.message);
}

class ResetPasswordError extends ResetPasswordInitialState{
  String message;
  ResetPasswordError(this.message);
}
class LoadingStateVerifyCode extends ResetPasswordInitialState{}

class LoadingState extends ResetPasswordInitialState{}

class VerifyForgetPasswordSuccess extends ResetPasswordInitialState{}

class VerifyForgetPasswordFailed extends ResetPasswordInitialState{
  String message;
  VerifyForgetPasswordFailed(this.message);
}
class VerifyForgetPasswordError extends ResetPasswordInitialState{
  String message;
  VerifyForgetPasswordError(this.message);
}


class ResendCodeSuccess extends ResetPasswordInitialState{}

class ResendCodeFailed extends ResetPasswordInitialState{
  String message;
  ResendCodeFailed(this.message);
}

class VerifyCodeFailed extends ResetPasswordInitialState{
  String message;
  VerifyCodeFailed(this.message);
}
class VerifyCodeError extends ResetPasswordInitialState{
  String message;
  VerifyCodeError(this.message);
}

class CheckDifferenceState extends ResetPasswordInitialState{}

class RemoveDateState extends ResetPasswordInitialState{}
////////////////////////////////////////////////////////////////////////////////
class CreateNewPasswordLoading extends ResetPasswordInitialState{}
class CreateNewPasswordFailure extends ResetPasswordInitialState{
  String message;
  CreateNewPasswordFailure(this.message);
}
class CreateNewPasswordSuccess extends ResetPasswordInitialState{
  CreateNewPasswordEntity createNewPasswordEntity;
  CreateNewPasswordSuccess(this.createNewPasswordEntity);
}
class CreateNewPasswordError extends ResetPasswordInitialState{
  CreateNewPasswordEntity createNewPasswordEntity;
  CreateNewPasswordError(this.createNewPasswordEntity);
}
////////////////////////////////////////////////////////////////////////////////
