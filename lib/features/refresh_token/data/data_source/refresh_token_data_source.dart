import '../../../../core/rest/dio_helper.dart';
import '../model/refresh_token_model.dart';

class RefreshTokenDataSource{
  Future<RefreshTokenModel> getRefreshToken({String? token, String? refreshToken})async {
    final result = await DioHelper.getPostData(
        url: 'api/Auth/RefreshToken',
        data: {
      'token':token,
      'refreshToken' :refreshToken,
    });
    return RefreshTokenModel.fromJson(result.data);
  }
}