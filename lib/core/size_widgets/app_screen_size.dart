import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../rest/app_constants.dart';

double ratioImageWidth = 0.4868;
double ratioImageHeight = 0.34259;
double ratioLogoMiniWidth = 0.1422;
double ratioLogoMiniHeight = 0.02375;
double ratioHeightUnderLogo = 0.09375;
double ratioWidthComponentLogin = 0.61;
double ratioMyDexefWidth = 0.18359;
double ratioMyDexefHeight = 0.2472;
double ratioBackgroundWidth = 0.5868 ;
double ratioBackgroundHeight = 0.43148;

class AppScreenSize {
  static AppDesignSize appDesignSize = AppDesignSize();
  static AppWidgetSize appWidgetSize = AppWidgetSize();
}
//////////////////////////////////////////////////////////////////////////////// design size
class AppDesignSize{
  final double webDesignWidth;
  final double webDesignHeight;
  final double mobileDesignWidth;
  final double mobileDesignHeight;

  AppDesignSize({
    this.webDesignWidth = 1366,
    this.webDesignHeight = 768,
    this.mobileDesignWidth = 390,
    this.mobileDesignHeight = 844
  });

  getScreenWidth(BuildContext context){
    double width = MediaQuery.of(context).size.width;
    return width;
  }

  getScreenHeight(BuildContext context){
    double height = MediaQuery.of(context).size.height;
    return height;
  }

  platformType(BuildContext context){
    if(getScreenWidth(context) < 600){
      return AppConstants.mobileDevice;
    }else if(getScreenWidth(context) < 1000){
      return AppConstants.tabletDevice;
    }else{
      return AppConstants.webDevice;
    }
  }

  isWebPlatform(BuildContext context){
    if(getScreenWidth(context) > 1000){
      return true;
    }else{
      return false;
    }
  }

  doPadding(BuildContext context){
    if(getScreenWidth(context) < 1280){
      return true;
    }else{
      return false;
    }
  }
}
//////////////////////////////////////////////////////////////////////////////// widget size
class AppWidgetSize{
  AppDesignSize appDesignSize = AppDesignSize();
  widgetWidth(BuildContext context, sizeInUI){
    double width = appDesignSize.getScreenWidth(context) * (sizeInUI/appDesignSize.webDesignWidth);
    return width;
  }

  widgetHeight(BuildContext context, sizeInUI){
    double width = appDesignSize.getScreenHeight(context) * (sizeInUI/appDesignSize.webDesignHeight);
    return width;
  }

  getLoginRightPanelWidth (BuildContext context) {
    Orientation? orientation = MediaQuery.of(context).orientation;
    MediaQueryData media = MediaQuery.of(context);
    double? width ;
    if (media.size.width > 1280) {
      width = 700;
    } else if (media.size.width >= 1024 && media.size.width <= 1280 && orientation == Orientation.landscape) {
      width = media.size.width * 0.5;
    }else{
      width = media.size.width;
    }
    return width;
  }
}
////////////////////////////////////////////////////////////////////////////////