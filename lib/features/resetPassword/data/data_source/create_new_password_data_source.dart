import '../../../../core/rest/dio_helper.dart';
import '../model/CreateNewPasswordModel.dart';

class CreateNewPasswordDataSource{

  Future<CreateNewPasswordModel> createNewPassword(int mobileID,String code,String password) async {
    final result = await DioHelper.getPostData(
        url: 'api/Auth/ChangePasswordByMobileCode',
        data: {
          "mobileId" : mobileID,
          "password" : password,
          "code" : code,
        }
    );
    return CreateNewPasswordModel.fromJson(result.data);
  }
}