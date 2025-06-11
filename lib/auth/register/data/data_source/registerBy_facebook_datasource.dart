import '../../../../core/rest/dio_helper.dart';
import '../../data/model/registerBy_facebook_model.dart';

class RegisterWithFacebookDataSource{
  Future <RegisterFacebookModel> registerByFacebook({
    String? token,
    String? email,
    String? mobile,
    String? countryId,
    int? sourceId
  }) async {
    final result = await DioHelper.getPostData(
        url: 'api/Auth/RegisterByFaceBook',
        data: {
          "token" : token,
          "email" : email,
          "mobile" : mobile,
          "countryCode" : countryId,
          "sourceId" : 2,
        }
    );
    return RegisterFacebookModel.fromJson(result.data);
  }
}
