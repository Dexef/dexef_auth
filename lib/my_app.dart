import 'package:auth_dexef/redirect.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'core/rest/app_localizations.dart';
import 'core/rest/cash_helper.dart';
import 'core/rest/constants.dart';
import 'core/rest/custom_scroll_behavior.dart';
import 'core/rest/my_navigator_observer.dart';
import 'core/rest/routes.dart';
import 'core/theme/light_theme.dart';
import 'features/login/presentation/cubit/login_cubit.dart';
import 'main.dart';
import 'package:auth_dexef/locator.dart' as di;

class MyApp extends StatefulWidget {
  const MyApp({super.key, this.title});

  final String? title;

  @override
  State<MyApp> createState() => MyAppState();
}

bool isDark = false;
ValueNotifier<int> routerNotifier = ValueNotifier<int>(0);
List<GoRoute> routes = [];

class MyAppState extends State<MyApp> {
  late Future? loadLibraryFuture;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CacheHelper.saveData(key: Constants.appLanguage.toString(), value: context.locale.languageCode);
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => di.locator<LoginCubit>()..lookupUserCountry()),
      ],
      child: ValueListenableBuilder<int>(
        valueListenable: routerNotifier,
        builder: (BuildContext context, int value, Widget? child) {
          final width = MediaQuery.of(context).size.width;
          final designSize =  width < 600 ? const Size(390, 844) : width < 1000 ?  const Size(768, 1024) : const Size(1366, 768);
          return ScreenUtilInit(
            designSize: designSize,
            useInheritedMediaQuery: true,
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (context, child) {
              return MaterialApp.router(
                routeInformationParser: router.routeInformationParser,
                routeInformationProvider: router.routeInformationProvider,
                routerDelegate: router.routerDelegate,
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                ],
                scrollBehavior: MyCustomScrollBehavior(),
                supportedLocales: context.supportedLocales,
                locale: context.locale,
                builder: (context, child) {
                  final mediaQueryData = MediaQuery.of(context);
                  return MediaQuery(
                    data: mediaQueryData.copyWith(textScaleFactor: 1.0),
                    child: child!,
                  );
                },
                debugShowCheckedModeBanner: false,
                theme: lightTheme(context),
                themeMode: ThemeMode.light,
              );
            },
          );
        },
      ),
    );
  }

  static GoRouter router = GoRouter(
    initialLocation: Routes.loginScreen,
    observers: [MyNavigatorObserver()],
    navigatorKey: navigatorKey,
    routerNeglect: true,
    refreshListenable: routerNotifier,
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return MainScaffold(child: child); // <- Always show header & footer
        },
        routes: routes
      ),
    ],
  );
}