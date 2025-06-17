import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:html' as html;
import 'core/rest/routes.dart';
import 'features/login/presentation/pages/1.login.dart';
import 'features/register/presentation/pages/admin_sign_up.dart';
import 'my_app.dart';

initializeRoute() {
  routes = [
    GoRoute(
      name: Routes.loginScreen,
      path: Routes.loginScreen,
      pageBuilder: (BuildContext context, GoRouterState state) {
        return const NoTransitionPage(child: LoginScreen());
      },
    ),
    GoRoute(
      name: Routes.adminSignUpScreen,
      path: Routes.adminSignUpScreen,
      pageBuilder: (BuildContext context, GoRouterState state) {
        return const NoTransitionPage(child: AdminSignUp());
      },
    ),
  ];
  return routes;
}