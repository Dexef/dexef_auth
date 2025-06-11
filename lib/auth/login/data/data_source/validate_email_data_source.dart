import '../../../../core/rest/dio_helper.dart';
import '../model/ValidateEmailModel.dart';

class ValidateEmailDataSource{
  Future <ValidateEmailModel> validateEmail(String userName) async {
    final result = await DioHelper.getPostData(
        url: 'api/Auth/ValidateEmail',
        query: {
          "userName" : userName,
        },
        data: {}
    );
    return ValidateEmailModel.fromJson(result.data);
  }
}