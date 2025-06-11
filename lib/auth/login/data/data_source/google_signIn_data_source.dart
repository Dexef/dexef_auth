import '../../../../core/rest/dio_helper.dart';
import '../model/google_signIn_model.dart';

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