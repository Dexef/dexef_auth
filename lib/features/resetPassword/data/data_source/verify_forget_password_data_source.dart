import '../../../../core/rest/dio_helper.dart';
import '../model/VerifyForgetPasswordModel.dart';

class VerifyForgetPasswordDataSource{
  Future <VerifyForgetPasswordModel> verifyForgetPassword(int mobileID,String code) async {
    final result = await DioHelper.getPostData(
        url: 'api/Auth/VerifyForgetPasswordMobileCode',
        data: {
          "mobileId" : mobileID,
          "code" : code
        }
    );
    return VerifyForgetPasswordModel.fromJson(result.data);
  }
}
