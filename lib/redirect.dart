import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:html' as html;
import 'core/rest/routes.dart';
import 'features/login/presentation/pages/1.login.dart';
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
  ];
  return routes;
}