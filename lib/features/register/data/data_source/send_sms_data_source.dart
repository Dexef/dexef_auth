import '../../../../core/rest/dio_helper.dart';
import '../model/SendSmsModel.dart';

class SendSmsDataSource{

  Future<SendSmsModel> sendSmsVerification(int mobileId , bool isWhatsApp) async {
    final result = await DioHelper.getPostData(
        url: 'api/Auth/SendSmsVerification',
        query:  {
          "mobileId" : mobileId,
          "isWatsAPP" : isWhatsApp,
        }
    );
    return SendSmsModel.fromJson(result.data);
  }
}