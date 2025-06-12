import '../../../../core/rest/dio_helper.dart';
import '../model/registerBy_Google_Model.dart';

class RegisterByGoogleDataSource{
  Future <RegisterByGoogleModel> registerByGoogle({
    String? token,
    String? email,
    String? mobile,
    String? countryId,
    int? sourceId
  }) async {
    final result = await DioHelper.getPostData(
      url: 'api/Auth/RegisterByGoogle',
      data: {
        "token" : token,
        "email" : email,
        "mobile" : mobile,
        "countryCode" : countryId,
        "sourceId" : sourceId,
      }
    );
    return RegisterByGoogleModel.fromJson(result.data);
  }
}
