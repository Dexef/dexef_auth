import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class MyNavigatorObserver extends NavigatorObserver {
  static List<String> backStack = [];

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    backStack.add(route.settings.name ?? '');
    // send page issued name to sentry.
    Sentry.configureScope((scope) {
      scope.setContexts('current_page', {
        'route': route.settings.name ?? 'Unknown',
      });
    });
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    backStack.removeLast();
  }

  static void popUntil(String routeName, BuildContext context) {
    if (!MyNavigatorObserver.backStack.contains(routeName)) {
      return;
    }
    print('ddddddd ${MyNavigatorObserver.backStack.last}');
    while (MyNavigatorObserver.backStack.last != routeName) {
      GoRouter.of(context).pop();
    }
  }
}