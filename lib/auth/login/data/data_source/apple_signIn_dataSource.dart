import '../../../../core/rest/dio_helper.dart';
import '../model/social_model.dart';

class AppleSignInDataSource {
  Future<SocialModel> appleSignIn (String token) async{
    final result = await DioHelper.getPostData(
        url:'api/Auth/LoginByApple',
        data: {
          "token":token,
        });
    return SocialModel.fromJson(result.data);
  }
}