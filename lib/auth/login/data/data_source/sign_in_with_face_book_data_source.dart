import '../../../../core/rest/dio_helper.dart';
import '../model/facebook_signIn_model.dart';

class SignInFacebookDataSource{
  Future <SignInFacebookModel> signInWithFacebook(
    String token,
  ) async {
    final result = await DioHelper.getPostData(
        url: 'api/Auth/LoginByFaceBook',
        data: {
          "token" : token,
        }
    );
    return SignInFacebookModel.fromJson(result.data);
  }
}
