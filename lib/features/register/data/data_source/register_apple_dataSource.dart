import '../../../../core/rest/dio_helper.dart';
import '../model/register_apple_model.dart';

class RegisterAppleDataSource{
  Future <RegisterAppleModel> registerByApple(
    String? token,
    String? email,
    String? mobile,
    String? countryId,
    int? sourceId
  ) async {
    final result = await DioHelper.getPostData(
        url: 'api/Auth/RegisterByApple',
        data: {
          "token" : token,
          "email" : email,
          "mobile" : mobile,
          "countryCode" : countryId,
          "sourceId" : 2,
        }
    );
    return RegisterAppleModel.fromJson(result.data);
  }
}
