import 'package:get_it/get_it.dart';
import 'dexef_auth/auth_injection.dart';

final locator = GetIt.instance;

void setup() {
  authInjection();
}