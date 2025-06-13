import 'package:get_it/get_it.dart';
import 'features/login/login_injection.dart';
import 'features/register/register_injection.dart';
import 'features/resetPassword/resetPassword_injection.dart';

final locator = GetIt.instance;

void setup() {
  loginInjection();
  registerInjection();
  resetPasswordInjection();
}