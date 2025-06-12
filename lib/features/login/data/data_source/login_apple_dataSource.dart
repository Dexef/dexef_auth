import '../../../../core/rest/dio_helper.dart';
import '../model/login_apple_model.dart';

class AppleSignInDataSource {
  Future<LoginAppleModel> appleSignIn (String token) async{
    final result = await DioHelper.getPostData(
        url:'api/Auth/LoginByApple',
        data: {
          "token":token,
        });
    return LoginAppleModel.fromJson(result.data);
  }
}