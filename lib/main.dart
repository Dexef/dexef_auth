import 'dart:async';
import 'package:auth_dexef/redirect.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:url_strategy/url_strategy.dart';
import 'core/rest/bloc_observer.dart';
import 'core/rest/cash_helper.dart';
import 'core/rest/dio_helper.dart';
import 'firebase_options.dart';
import 'locator.dart';
import 'my_app.dart';

ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);
final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
BuildContext currentContext = navigatorKey.currentContext!;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
  ]);
  unawaited(EasyLocalization.ensureInitialized());
  setPathUrlStrategy();
  await CacheHelper.init();
  DioHelper.init();
  DioHelper.initDioTicket();
  Bloc.observer = MyBlocObserver();
  GoRouter.optionURLReflectsImperativeAPIs = true;
  setup();
  routes = initializeRoute();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runMethod();
}
////////////////////////////////////////////////////////////////////////////////
runMethod() {
  runApp(
    EasyLocalization(
      path: 'assets/translations',
      supportedLocales: const [
        Locale('en'),
        Locale('ar'),
        Locale('fr'),
      ],
      fallbackLocale: const Locale('en'),
      startLocale: const Locale('ar'),
      child: const MyApp(title: ""), // Wrap your app
    ),
  );
}
////////////////////////////////////////////////////////////////////////////////