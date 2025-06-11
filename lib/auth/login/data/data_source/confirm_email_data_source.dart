import '../../../../core/rest/dio_helper.dart';
import '../../data/model/ConfirmEmailModel.dart';

class ConfirmEmailDataSource{
  Future<ConfirmEmailModel> confirmEmail(String email) async {
    final result = await DioHelper.getData(
      url: '/api/Auth/CheckEmailExist',
      query: {
        "email" : email
      }
    );
    return ConfirmEmailModel.fromJson(result.data);
  }
}