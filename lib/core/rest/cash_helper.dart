import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'arguments.dart';

class CacheHelper {
  static SharedPreferences? sharedPreferences;
  static SharedPreferences? policysharedPreferences;

  static init() async {
    sharedPreferences = await SharedPreferences.getInstance();
    policysharedPreferences = await SharedPreferences.getInstance();
  }

  static dynamic getData({
    @required String? key,
  }) {
    return sharedPreferences!.get(key!);
  }

  static dynamic getPolicyData({
    @required String? key,
  }) {
    return policysharedPreferences!.get(key!);
  }

  static Future<bool> savePolicyData({
    required String key,
    @required dynamic value,
  }) async {
    // if (value is bool)
    //   return await policysharedPreferences!.setBool(key, value);
    return await policysharedPreferences!.setBool(key, value);
  }

  static Future<bool> saveData({
    required String key,
    @required dynamic value,
  }) async {
    if (value is String) return await sharedPreferences!.setString(key, value);
    if (value is int) return await sharedPreferences!.setInt(key, value);
    if (value is bool) return await sharedPreferences!.setBool(key, value);
    return await sharedPreferences!.setDouble(key, value);
  }

  static List<String> selectedCondId=[];
  static List<String> similarDetailsCondition=[];
  static List<String> surahCondition=[];
  static List<String> allSurahDetails=[];
  static List<String> surahName = [];



   static saveList() async {
     return await sharedPreferences!.setStringList('selectedCondId', selectedCondId);

  }

  static saveSurahCondition() async {
    return await sharedPreferences!.setStringList('save_surah_condition', surahCondition);

  }

  static saveSurahName() async {
    return await sharedPreferences!.setStringList('save_surah_name', surahName);

  }



  static saveSimilarDetails() async {
    return await sharedPreferences!.setStringList('save_similar_details', similarDetailsCondition);

  }

  static saveAllSurahDetails() async {
    return await sharedPreferences!.setStringList('all_surah_details', allSurahDetails);

  }


  static dynamic getDataList({
    @required String? key,
  }) {
    return sharedPreferences!.get(key!);
  }


  static Future<bool> removeData({
    required String key,
  }) async {
    return await sharedPreferences!.remove(key);
  }

  static Future<bool> clearAllData() async {
    return await sharedPreferences!.clear();
  }

  static saveObjectToPrefs({required String key, object}) async {
    final jsonString = jsonEncode(object);
    return await sharedPreferences!.setString(key, jsonString);
  }


  static dynamic getObjectFromPrefs({ @required String? key, @required dynamic model}) {
    final jsonString = sharedPreferences!.getString(key!);
    if(jsonString == null){
      return null;
    }
    switch(model){
      case ArgumentsSideNavigationBar:
        return ArgumentsSideNavigationBar.fromJson(jsonDecode(jsonString));
      case ArgumentsVerifyPhoneNumber:
        return ArgumentsVerifyPhoneNumber.fromJson(jsonDecode(jsonString));
      case ArgumentsTypeSubscription:
        return ArgumentsTypeSubscription.fromJson(jsonDecode(jsonString));
      case ArgumentsCardDevices:
        return ArgumentsCardDevices.fromJson(jsonDecode(jsonString!));
      case ArgumentsVersionCompare:
        return ArgumentsVersionCompare.fromJson(jsonDecode(jsonString!));
      case ArgumentsChangePhoneNumber:
        return ArgumentsChangePhoneNumber.fromJson(jsonDecode(jsonString!));
      case ArgumentsVerifyCodeScreen:
        return ArgumentsVerifyCodeScreen.fromJson(jsonDecode(jsonString!));
      case ArgumentsCreateNewPassword:
        return ArgumentsCreateNewPassword.fromJson(jsonDecode(jsonString!));
      case ArgumentsResetPasswordVerifyCode:
        return ArgumentsResetPasswordVerifyCode.fromJson(jsonDecode(jsonString!));
      case ArgumentsUserLogin:
        return ArgumentsUserLogin.fromJson(jsonDecode(jsonString!));
      case PaymentDetailsArguments:
        return PaymentDetailsArguments.fromJson(jsonDecode(jsonString!));
      case ArgumentsViewInvoiceScreen:
        return ArgumentsViewInvoiceScreen.fromJson(jsonDecode(jsonString!));
      case ArgumentsApplicationsTicket:
        return ArgumentsApplicationsTicket.fromJson(jsonDecode(jsonString!));
      case ArgumentDownloadApp:
        return ArgumentDownloadApp.fromJson(jsonDecode(jsonString!));
      case ArgumentAddon:
        return ArgumentAddon.fromJson(jsonDecode(jsonString));
      case ArgumentsAddonVersion:
        return ArgumentsAddonVersion.fromJson(jsonDecode(jsonString));

    }
  }
}

// if(model == ArgumentsVerifyPhoneNumber){
//   return ArgumentsVerifyPhoneNumber.fromJson(jsonDecode(jsonString!));
// }else if(model == ArgumentsTypeSubscription){
//   return ArgumentsTypeSubscription.fromJson(jsonDecode(jsonString!));
// } else if(model == ArgumentsCardDevices){
//   return ArgumentsCardDevices.fromJson(jsonDecode(jsonString!));
// }else if(model == ArgumentsVersionCompare){
//   return ArgumentsVersionCompare.fromJson(jsonDecode(jsonString!));
// }