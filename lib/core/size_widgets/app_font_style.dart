import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppFontStyle{
  static AppFontFamily appFontFamily = AppFontFamily();
  static AppFontWeight fontWeightCustoms = AppFontWeight();
  static AppFontSize appFontSize = AppFontSize();
}
//////////////////////////////////////////////////////////////////////////////// font weight
class AppFontWeight{
  final FontWeight thin;
  final FontWeight extraLight;
  final FontWeight light;
  final FontWeight regular;
  final FontWeight normal;
  final FontWeight medium;
  final FontWeight semiBold;
  final FontWeight bold;
  final FontWeight extraBold;
  final FontWeight black;

  AppFontWeight({
    this.thin = FontWeight.w100,
    this.extraLight = FontWeight.w200,
    this.light = FontWeight.w300,
    this.regular = FontWeight.w400,
    this.normal = FontWeight. w400,
    this.medium = FontWeight.w500,
    this.semiBold = FontWeight.w600,
    this.bold = FontWeight.w700,
    this.extraBold = FontWeight.w800,
    this.black = FontWeight.w900,
  });
}
//////////////////////////////////////////////////////////////////////////////// font size
class AppFontSize{
  setFontSize(BuildContext context,{double? webFontSize, double? mobileFontSize}) {
    if (MediaQuery.of(context).size.width > 600){
      if(webFontSize != null){
        if (MediaQuery.of(context).size.width <= 1280 && MediaQuery.of(context).size.height <= 800) {
          return webFontSize;
        }else if (MediaQuery.of(context).size.width <= 1366 && MediaQuery.of(context).size.height <= 768) {
          double size = webFontSize + 1;
          return size;
        }else if (MediaQuery.of(context).size.width <= 1920 && MediaQuery.of(context).size.height <= 1080) {
          double size = webFontSize + 2 ;
          return size;
        }
      }
    }else{
      if(mobileFontSize != null){
        return mobileFontSize.sp;
      }
    }
  }
}
//////////////////////////////////////////////////////////////////////////////// font family
class AppFontFamily{
  final String readex;
  AppFontFamily({
    this.readex = 'Readex'
  });
}
