import '../../../../core/rest/dio_helper.dart';
import '../model/ResetPasswordModel.dart';

class ResetPasswordDataSource{
  Future <ResetPasswordModel> resetPassword(String emailOrPhone,bool isWhatsapp) async {
    final result = await DioHelper.getPostData(
      url: 'api/Auth/ForgetPasswordByMobile',
      data: {
        "username" : emailOrPhone,
        "isWatsApp" : isWhatsapp
      }
    );
    return ResetPasswordModel.fromJson(result.data);
  }
}