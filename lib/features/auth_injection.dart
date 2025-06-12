import 'package:auth_dexef/auth/register/register_injection.dart';
import 'package:auth_dexef/auth/resetPassword/resetPassword_injection.dart';
import 'login/login_injection.dart';

authInjection(){
  loginInjection();
  registerInjection();
  resetPasswordInjection();
}