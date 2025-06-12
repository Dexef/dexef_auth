import '../../../../core/rest/dio_helper.dart';
import '../model/login_normal_model.dart';

class LoginDataSource {
  Future<LoginModel> getLogin(String email, String password) async{
    final result =
        await DioHelper.getPostData(
            url:'/api/Auth/Login',
            data: {
              "email":email,
              "password":password,
            },);
    return LoginModel.fromJson(result.data);
  }
}