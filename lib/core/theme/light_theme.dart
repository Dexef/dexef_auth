import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/size_widgets/app_font_style.dart';
import 'colors.dart';

ThemeData lightTheme (BuildContext context) {
  return ThemeData(
    scaffoldBackgroundColor: Colors.white,
/////////////////////////////////////////////////////////////////////////////////////////////////
    iconTheme: const IconThemeData(
        color: description
    ),
/////////////////////////////////////////////////////////////////////////////////////////////////
    drawerTheme: const DrawerThemeData(
        width: 260
    ),
/////////////////////////////////////////////////////////////////////////////////////////////////
    appBarTheme: const AppBarTheme(
      titleSpacing: 20.0,
      systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light
      ),
      backgroundColor: Colors.white,
      elevation: 0.0,
      titleTextStyle: TextStyle(
        color: Colors.black,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(
        color: description,
      ),
    ),
/////////////////////////////////////////////////////////////////////////////////////////////////
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: primaryColor,
      unselectedItemColor: Colors.grey,
      elevation: 20.0,
      backgroundColor: Colors.transparent,
    ),
//////////////////////////////////////////////////////////////////////////////////////////////////
    textTheme: TextTheme(
      ///////////////////////////////////////////// display
      displayLarge: TextStyle(
        fontSize: AppFontStyle.appFontSize.setFontSize(context, webFontSize: 74, mobileFontSize: 72.sp),
        color: brush,
        fontFamily: AppFontStyle.appFontFamily.readex,
        fontWeight: AppFontStyle.fontWeightCustoms.bold,
      ),
      displayMedium: TextStyle(
        fontSize: AppFontStyle.appFontSize.setFontSize(context, webFontSize: 64, mobileFontSize: 62.sp),
        color: brush,
        fontFamily: AppFontStyle.appFontFamily.readex,
        fontWeight: AppFontStyle.fontWeightCustoms.bold,
      ),
      displaySmall: TextStyle(
        fontSize: AppFontStyle.appFontSize.setFontSize(context, webFontSize: 54, mobileFontSize: 52.sp),
        color: brush,
        fontFamily: AppFontStyle.appFontFamily.readex,
        fontWeight: AppFontStyle.fontWeightCustoms.bold,
      ),
      //////////////////////////////////////////////// head
      headlineLarge: TextStyle(
        fontSize: AppFontStyle.appFontSize.setFontSize(context, webFontSize: 42, mobileFontSize: 40.sp),
        color: brush,
        fontFamily: AppFontStyle.appFontFamily.readex,
        fontWeight: AppFontStyle.fontWeightCustoms.bold,
      ),
      headlineMedium: TextStyle(
        fontSize: AppFontStyle.appFontSize.setFontSize(context, webFontSize: 36, mobileFontSize: 34.sp),
        color: brush,
        fontFamily: AppFontStyle.appFontFamily.readex,
        fontWeight: AppFontStyle.fontWeightCustoms.regular,
      ),
      headlineSmall: TextStyle(
          fontSize: AppFontStyle.appFontSize.setFontSize(context, webFontSize: 32, mobileFontSize: 30.sp),
          color: brush,
          fontFamily: AppFontStyle.appFontFamily.readex,
          fontWeight: AppFontStyle.fontWeightCustoms.bold
      ),
      ///////////////////////////////////////////// title
      titleLarge: TextStyle(
        fontSize: AppFontStyle.appFontSize.setFontSize(context, webFontSize: 30, mobileFontSize: 28.sp),
        color: brush,
        fontFamily: AppFontStyle.appFontFamily.readex,
        fontWeight: AppFontStyle.fontWeightCustoms.regular,
      ),
      titleMedium: TextStyle(
          fontSize: AppFontStyle.appFontSize.setFontSize(context, webFontSize: 28, mobileFontSize: 26.sp),
          color: brush,
          fontFamily: AppFontStyle.appFontFamily.readex,
          fontWeight: AppFontStyle.fontWeightCustoms.bold
      ),
      titleSmall: TextStyle(
          fontSize: AppFontStyle.appFontSize.setFontSize(context, webFontSize: 26, mobileFontSize: 24.sp),
          color:  brush,
          fontFamily: AppFontStyle.appFontFamily.readex,
          fontWeight: AppFontStyle.fontWeightCustoms.bold
      ),
      ///////////////////////////////////////////// body
      bodyLarge: TextStyle(
          fontSize: AppFontStyle.appFontSize.setFontSize(context, webFontSize: 24, mobileFontSize: 16.sp),
          color:  brush,
          fontFamily: AppFontStyle.appFontFamily.readex,
          fontWeight: AppFontStyle.fontWeightCustoms.bold
      ),
      bodyMedium: TextStyle(
          fontSize: AppFontStyle.appFontSize.setFontSize(context, webFontSize: 22, mobileFontSize: 20.sp),
          color: brush,
          fontFamily: AppFontStyle.appFontFamily.readex,
          fontWeight: AppFontStyle.fontWeightCustoms.bold
      ),
      bodySmall: TextStyle(
          fontSize: AppFontStyle.appFontSize.setFontSize(context, webFontSize: 20, mobileFontSize: 18.sp),
          color: brush,
          fontFamily: AppFontStyle.appFontFamily.readex,
          fontWeight: AppFontStyle.fontWeightCustoms.bold
      ),
      ////////////////////////////////////////////////// label
      labelLarge: TextStyle(
          fontSize: AppFontStyle.appFontSize.setFontSize(context, webFontSize: 18, mobileFontSize: 16.sp),
          color: brush,
          fontFamily: AppFontStyle.appFontFamily.readex,
          fontWeight: AppFontStyle.fontWeightCustoms.bold
      ),
      labelMedium: TextStyle(
          fontSize: AppFontStyle.appFontSize.setFontSize(context, webFontSize: 16, mobileFontSize: 14.sp),
          color: brush,
          fontFamily: AppFontStyle.appFontFamily.readex,
          fontWeight: AppFontStyle.fontWeightCustoms.normal
      ),
      labelSmall: TextStyle(
        fontSize: AppFontStyle.appFontSize.setFontSize(context, webFontSize: 14, mobileFontSize: 12.sp),
        color: brush,
        fontFamily: AppFontStyle.appFontFamily.readex,
        fontWeight: AppFontStyle.fontWeightCustoms.normal,
      ),
    ),
  );
}
