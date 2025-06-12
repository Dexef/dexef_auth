import '../../../../core/rest/dio_helper.dart';
import '../model/SignUpModel.dart';

class SignUpDataSource{

  Future<RegisterNormalModel> signUp(String email,String name,String phoneNumber,String password,String countryCode,String companyName) async {
    final result = await DioHelper.getPostData(
        // url: 'api/Auth/RegisterLandingPage',
        url: 'api/Auth/RegisterTest',
        data: {
          "name" : name,
          "email" : email,
          "countryCode" : countryCode.substring(1),
          "password" : password,
          "mobile" :  phoneNumber,
          "companyName" : "default",
          "sourceId" : 2,
        }
    );
    return RegisterNormalModel.fromJson(result.data);
  }
}