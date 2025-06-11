import 'package:flutter/material.dart';
import '../../../../core/rest/dio_helper.dart';
import '../model/VerifyCodeModel.dart';

class VerifyCodeDataSource{
  Future <VerifyCodeModel> verifyCode({int? mobileId, String? code}) async {
    debugPrint('Mobile id $mobileId');
    debugPrint('code$code');
    final result = await DioHelper.getPostData(
        url: 'api/Auth/VerifyMobile',
        data: {
          "mobileId" : mobileId,
          "code" : code,
          "isPrimaryMobile": true,
          "fromLandingPage": true
        }
    );
    return VerifyCodeModel.fromJson(result.data);
  }
}