import 'package:auth_dexef/features/register/register_injection.dart';
import 'package:auth_dexef/features/resetPassword/resetPassword_injection.dart';
import 'login/login_injection.dart';

authInjection(){
  loginInjection();
  registerInjection();
  resetPasswordInjection();
}