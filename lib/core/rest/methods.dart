import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../main.dart';
import 'cash_helper.dart';
import 'constants.dart';

String getString({BuildContext? context, required String title,}) {
  BuildContext currentContext = navigatorKey.currentContext!;
  Locale currentLocale = Localizations.localeOf(currentContext);
  bool isDefault = currentLocale.languageCode == 'en';
  if(title != ""){
    Map<String, dynamic> jsonMap = jsonDecode(title);
    if (isDefault) {
      return jsonMap['default'];
    } else {
      return jsonMap['ar'];
    }
  }
  return "";
}
////////////////////////////////////////////////////////////////////////////////
getLanguageCode(BuildContext context){
  return context.locale.languageCode;
}
////////////////////////////////////////////////////////////////////////////////
getImage({required String path, bool isSvg = false, double? width, double? height, BoxFit fit = BoxFit.contain, Color? color}){
  if(kDebugMode || !kIsWeb){
    if(isSvg){
      return SvgPicture.asset(
        "assets/$path",
        width: width,
        height: height,
        fit: fit,
        color: color,
      );
    }else{
      return Image.asset(
        "assets/$path",
        width: width,
        height: height,
        fit: fit,
        color: color,
      );
    }
  }else if (kIsWeb && !kDebugMode){
    if(isSvg){
      return  SvgPicture.network(
        // "https://dexefcustomer.dexef.com/assets/assets/$path",
        "https://my.dexef.com/assets/assets/$path",
        width: width,
        height: height,
        fit: fit,
        color: color,
      );
    }else{
      return Image.network(
        // "https://dexefcustomer.dexef.com/assets/assets/$path",
        "https://my.dexef.com/assets/assets/$path",
        width: width,
        height: height,
        fit: fit,
        color: color,
      );
    }
  }
}
////////////////////////////////////////////////////////////////////////////////
getLanguage(){
  if(CacheHelper.getData(key: Constants.isArabic.toString()) != null){
    if(CacheHelper.getData(key: Constants.isArabic.toString()) == true){
      return "AR";
    }else{
      return "EN";
    }
  }else{
    return "AR";
  }
}
////////////////////////////////////////////////////////////////////////////////
bool isLogged() {
  if (CacheHelper.getData(key: Constants.isLogged.toString()) == true) {
    return true;
  }
  return false;
}
////////////////////////////////////////////////////////////////////////////////
getErrorMessage(String apiMessage){
  if(apiMessage == "Failed : This mobile is not verified"){
    return 'The mobile is not verified';
  }else if(apiMessage == "Failed : {0} Not Found"){
    return "Please, sign up first";
  }else{
    return apiMessage;
  }
}
////////////////////////////////////////////////////////////////////////////////
String enforceLTRForNumbers(String text) {
  // Regular expression to find numbers
  final regex = RegExp(r'\d+');
  return text.replaceAllMapped(regex, (match) {
    return '\u200E${match.group(0)}\u200E';
  });
}
////////////////////////////////////////////////////////////////////////////////
getLocation(bool value) {
  dynamic location;
  if (value) {
    location = const Offset(1, 0);
  } else {
    location = const Offset(0, 0);
  }
  return location;
}



