import '../../../../core/rest/dio_helper.dart';
import '../model/login_google_model.dart';

class GoogleSignInDataSource {
  Future<GoogleSignInModel> googleSignIn (String token) async{
    final result =
    await DioHelper.getPostData(
        url:'api/Auth/LoginByGoogle',
        data: {
          "token":token,
        });
    return GoogleSignInModel.fromJson(result.data);
  }
}