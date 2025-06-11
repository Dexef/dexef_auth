import 'package:go_router/go_router.dart';

class Routes{
////////////////////////////////////////////////////////////////////////////// auth Pages
  static const String splashRoute = '/';
  static const String loginScreen = '/login';
  // static const String loginScreen = '/download-center';
  static const String adminSignUpScreen = '/signup';
  static const String appleAuth = '/appleauth';
  ///////////////////////////////////////////////////////////////
  static const String verifyCodeSocial = '/signup/verifyphone/verifycode';
  static const String verifyCodeChooseSocial = '/signup/verifyphone/verifycodeverifycode';
  ///////////////////////////////////////////////////////////////
  static const String verifyPhoneNumber = '/signup/verifyphone';
  static const String changePhoneNumber = '/signup/verifyphone/changephone';
  static const String verifyCodeChangeNumber = '/signup/verifyphone/changephone/verifycode';
  ///////////////////////////////////////////////////////////////
  static const String createNewPasswordScreen = '/createnewpassword';
  static const String passwordChangedSuccessful = '/passwordchangedsuccessful';
  static const String resetPassword = '/resetpassword';
  static const String resetPasswordVerifyCode = '/resetpasswordverifycode';
  static const String verifyCodeResetPassword = '/resetpasswordverifycode/verifycode';
  static const String verifyCodeScreen = '/signup/verifycodesms';
  static const String verifyCodeChooseSignUp = '/signup/verifycode';
  static const String verifyCodeChooseProfile = '/profile/verifycode';
}