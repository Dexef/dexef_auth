import 'package:flutter/material.dart';

class ArgumentsSideNavigationBar {
  bool? isUserDefaultExist;
  ArgumentsSideNavigationBar({this.isUserDefaultExist});

  factory ArgumentsSideNavigationBar.fromJson(Map<String, dynamic> json) {
    return ArgumentsSideNavigationBar(
      isUserDefaultExist : json['isUserDefaultExist'],
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'isUserDefaultExist': isUserDefaultExist,
    };
  }
}
////////////////////////////////////////////////////////////////////////////////
class ArgumentsVerifyPhoneNumber {
  dynamic email;
  dynamic name;
  dynamic token;
  bool? isGoogle;
  bool? isFacebook;
  bool? isApple;
  ArgumentsVerifyPhoneNumber({this.email, this.name, this.token, this.isGoogle, this.isFacebook, this.isApple});
  factory ArgumentsVerifyPhoneNumber.fromJson(Map<String, dynamic> json) {
    return ArgumentsVerifyPhoneNumber(
      email : json['email'],
      name: json['name'],
      token: json['token'],
      isGoogle: json['isGoogle'],
      isFacebook: json['isFacebook'],
      isApple: json['isApple'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'name': name,
      'token': token,
      'isGoogle': isGoogle,
      'isFacebook': isFacebook,
      'isApple' : isApple
    };
  }
}
////////////////////////////////////////////////////////////////////////////////
class ArgumentsChangePhoneNumber {
  int? mobileID;
  String? email;
  String? password;
  bool? isGoogle;
  bool? isFacebook;
  ArgumentsChangePhoneNumber(
      {this.mobileID,
      this.password,
      this.email,
      this.isGoogle,
      this.isFacebook});

  factory ArgumentsChangePhoneNumber.fromJson(Map<String, dynamic> json) {
    return ArgumentsChangePhoneNumber(
      mobileID : json['mobileID'],
      email: json['email'],
      password: json['password'],
      isGoogle: json['isGoogle'],
      isFacebook: json['isFacebook'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'mobileID': mobileID,
      'email': email,
      'password': password,
      'isGoogle': isGoogle,
      'isFacebook': isFacebook,
    };
  }
}
////////////////////////////////////////////////////////////////////////////////
class ArgumentsVerifyCodeScreen {
  String? email;
  String? password;
  int? mobileId;
  String? fromPage;
  String? mobilePhone;
  String? countryCode;
  bool? isFromGoogle;
  bool? isFromFaceBook;
  ArgumentsVerifyCodeScreen({this.email, this.mobileId, this.password, this.fromPage,this.mobilePhone,this.countryCode,this.isFromGoogle,this.isFromFaceBook});

  factory ArgumentsVerifyCodeScreen.fromJson(Map<String, dynamic> json) {
    return ArgumentsVerifyCodeScreen(
      email : json['email'],
      password: json['password'],
      mobileId: json['mobileId'],
      fromPage: json['fromPage'],
      mobilePhone: json['mobilePhone'],
      countryCode: json['countryCode'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'mobileId': mobileId,
      'fromPage': fromPage,
      'mobilePhone': mobilePhone,
      'countryCode': countryCode,
    };
  }
}
////////////////////////////////////////////////////////////////////////////////
class ArgumentsCreateNewPassword {
  int? mobileID;
  String? code;
  ArgumentsCreateNewPassword({this.mobileID, this.code});

  factory ArgumentsCreateNewPassword.fromJson(Map<String, dynamic> json) {
    return ArgumentsCreateNewPassword(
      mobileID : json['mobileID'],
      code: json['code'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'mobileID': mobileID,
      'code': code,
    };
  }
}
////////////////////////////////////////////////////////////////////////////////
class ArgumentsResetPasswordVerifyCode {
  int? mobileID;
  bool? isFromGoogle;
  bool? isFromFacebook;
  bool? isApple;
  ArgumentsResetPasswordVerifyCode({this.mobileID, this.isFromGoogle = false, this.isFromFacebook = false, this.isApple});

  factory ArgumentsResetPasswordVerifyCode.fromJson(Map<String, dynamic> json) {
    return ArgumentsResetPasswordVerifyCode(
      mobileID : json['mobileID'],
      isFromGoogle: json['isFromGoogle'],
      isFromFacebook: json['isFromFacebook'],
      isApple: json['isApple'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'mobileID': mobileID,
      'isFromGoogle': isFromGoogle,
      'isFromFacebook': isFromFacebook,
      'isApple': isApple,
    };
  }
}
////////////////////////////////////////////////////////////////////////////////
class ArgumentsUserLogin {
  String? name;
  ArgumentsUserLogin({this.name});

  factory ArgumentsUserLogin.fromJson(Map<String, dynamic> json) {
    return ArgumentsUserLogin(
      name : json['name'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }
}
////////////////////////////////////////////////////////////////////////////////
class ArgumentsResponsivePage {
  Widget mobileWidget;
  Widget tabletWidget;
  Widget webWidget;
  ArgumentsResponsivePage({ required this.mobileWidget, required this.tabletWidget, required this.webWidget,});
}
////////////////////////////////////////////////////////////////////////////////
class PaymentDetailsArguments {
  // num versionId;
  // num paymentCountryId;
  int? applicationID;
  int? discriminator;
  int? invoiceNum;
  int? versionID;
  int? subscriptionType;
  int? paymentCountryID;
  bool? isFromAddon;
  String? priceLevelName;
  int? priceLevelId;
  int? addonId;
  int? versionSubscriptionId;
  PaymentDetailsArguments(
      {this.applicationID,
      this.discriminator,
      this.invoiceNum,
      this.versionID,
      this.subscriptionType,
      this.paymentCountryID,
      this.isFromAddon,
      this.priceLevelName,
      this.priceLevelId,
      this.addonId,
      this.versionSubscriptionId,
      });

  factory PaymentDetailsArguments.fromJson(Map<String, dynamic> json) {
    return PaymentDetailsArguments(
      applicationID : json['applicationID'],
      discriminator : json['discriminator'],
      invoiceNum : json['invoiceNum'],
      versionID : json['versionID'],
      subscriptionType : json['subscriptionType'],
      paymentCountryID : json['paymentCountryID'],
      isFromAddon : json['isFromAddon'],
      priceLevelName : json['priceLevelName'],
      priceLevelId : json['priceLevelId'],
      addonId : json['addonId'],
      versionSubscriptionId : json['versionSubscriptionId'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'applicationID': applicationID,
      'discriminator': discriminator,
      'invoiceNum': invoiceNum,
      'versionID': versionID,
      'subscriptionType': subscriptionType,
      'paymentCountryID': paymentCountryID,
      'isFromAddon': isFromAddon,
      'priceLevelName': priceLevelName,
      'priceLevelId': priceLevelId,
      'addonId': addonId,
      'versionSubscriptionId': versionSubscriptionId,
    };
  }
}
////////////////////////////////////////////////////////////////////////////////
class ArgumentsTypeSubscription {
  int? appId;
  String? applicationTitle;
  ArgumentsTypeSubscription({
    this.appId,
    this.applicationTitle
  });
  factory ArgumentsTypeSubscription.fromJson(Map<String, dynamic> json) {
    return ArgumentsTypeSubscription(
      appId : json['appId'],
      applicationTitle: json['applicationTitle'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'appId': appId,
      'applicationTitle': applicationTitle,
    };
  }
}
////////////////////////////////////////////////////////////////////////////////
class ArgumentsCardDevices {
  int deviceTypeId;
  String deviceTypeName;
  ArgumentsCardDevices({required this.deviceTypeId, required this.deviceTypeName});
  factory ArgumentsCardDevices.fromJson(Map<String, dynamic> json) {
    return ArgumentsCardDevices(
      deviceTypeId : json['deviceTypeId'],
      deviceTypeName: json['deviceTypeName'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'deviceTypeId': deviceTypeId,
      'deviceTypeName': deviceTypeName,
    };
  }
}
////////////////////////////////////////////////////////////////////////////////
class ArgumentsViewInvoiceScreen {
  int invoiceId;
  ArgumentsViewInvoiceScreen({required this.invoiceId});

  factory ArgumentsViewInvoiceScreen.fromJson(Map<String, dynamic> json) {
    return ArgumentsViewInvoiceScreen(
      invoiceId : json['invoiceId'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'invoiceId': invoiceId,
    };
  }
}
////////////////////////////////////////////////////////////////////////////////
class ArgumentsVersionCompare {
  int appId;
  int? versionId;
  int? subscriptionType;
  String? appName;
  String? logoUrl;
  bool? isFromVersion;
  ArgumentsVersionCompare({required this.appId , this.subscriptionType, this.appName, this.isFromVersion, this.versionId, this.logoUrl});
  factory ArgumentsVersionCompare.fromJson(Map<String, dynamic> json) {
    return ArgumentsVersionCompare(
      appId : json['appId'],
      subscriptionType: json['subscriptionType'],
      appName: json['appName'],
      isFromVersion: json['isFromVersion'],
      versionId: json['versionId'],
      logoUrl: json['logoUrl'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'appId': appId,
      'subscriptionType': subscriptionType,
      'appName': appName,
      'isFromVersion': isFromVersion,
      'versionId': versionId,
      'logoUrl': logoUrl,
    };
  }
}
////////////////////////////////////////////////////////////////////////////////
class ArgumentsApplicationsTicket {
  int appId;

  ArgumentsApplicationsTicket({required this.appId ,});

  factory ArgumentsApplicationsTicket.fromJson(Map<String, dynamic> json) {
    return ArgumentsApplicationsTicket(
      appId : json['appId'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'appId': appId,

    };
  }
}
////////////////////////////////////////////////////////////////////////////////
class ArgumentDownloadApp {
  String appDownloadLink;

  ArgumentDownloadApp({required this.appDownloadLink });

  factory ArgumentDownloadApp.fromJson(Map<String, dynamic> json) {
    return ArgumentDownloadApp(
      appDownloadLink: json['appDownloadLink'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'appDownloadLink': appDownloadLink,
    };
  }
}
////////////////////////////////////////////////////////////////////////////////
class ArgumentAddon {
  int addonId;
  dynamic addonPrice;

  ArgumentAddon({required this.addonId,this.addonPrice });

  factory ArgumentAddon.fromJson(Map<String, dynamic> json) {
    return ArgumentAddon(
      addonId: json['addonId'],
      addonPrice: json['addonPrice'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'addonId': addonId,
      'addonPrice': addonPrice,
    };
  }
}
////////////////////////////////////////////////////////////////////////////////
class ArgumentsAddonVersion {
  int? versionSubscriptionId;
  String? versionTitle;
  ArgumentsAddonVersion({
    this.versionSubscriptionId,
    this.versionTitle
  });
  factory ArgumentsAddonVersion.fromJson(Map<String, dynamic> json) {
    return ArgumentsAddonVersion(
      versionSubscriptionId : json['versionSubscriptionId'],
      versionTitle: json['versionTitle'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'versionSubscriptionId': versionSubscriptionId,
      'versionTitle': versionTitle,
    };
  }
}
////////////////////////////////////////////////////////////////////////////////