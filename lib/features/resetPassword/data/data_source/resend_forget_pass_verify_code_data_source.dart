import '../../../../core/rest/dio_helper.dart';
import '../../../register/data/model/ResendCodeModel.dart';

class ResendForgetPasswordCodeDataSource{
  Future <ResendCodeModel> resendCode({int? mobileId,bool? isWhatsApp}) async {
    final result = await DioHelper.getPostData(
      url: '/api/Auth/ResendForgetPassowrdMobileCode/$mobileId?isWhatsapp=$isWhatsApp',
      data: {},
    );
    return ResendCodeModel.fromJson(result.data);
  }
}