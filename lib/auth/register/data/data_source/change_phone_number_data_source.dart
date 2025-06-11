import '../../../../core/rest/dio_helper.dart';
import '../../data/model/ChangeMobileModel.dart';

class ChangePhoneNumberDataSource{

  Future<ChangeMobileModel> changePhoneNumber(String phoneNumber,String countryCode,int mobileID,bool isWhatsapp) async {
    final result = await DioHelper.getPostData(
        url: '/api/Auth/ChangeMobile',
        data: {
          "mobileId" : mobileID,
          "newMobile" : phoneNumber,
          "newMobileCountryCode" : countryCode,
          "isWatsApp": isWhatsapp
        }
    );
    return ChangeMobileModel.fromJson(result.data);
  }
}