import '../../../../core/rest/dio_helper.dart';
import '../model/ResendCodeModel.dart';

class ResendCodeDataSource{
  Future <ResendCodeModel> resendCode(int mobileId,bool isWhatsApp) async {
    final result = await DioHelper.getPostData(
        url: 'api/Auth/ResendMobileCode/$mobileId',
      query: {
        'isWhatsapp':isWhatsApp
      }
    );
    return ResendCodeModel.fromJson(result.data);
  }
}