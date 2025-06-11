import 'package:get_it/get_it.dart';
import 'auth/auth_injection.dart';

final locator = GetIt.instance;

void setup() {
  authInjection();
}