import '../../../../core/rest/error_model.dart';
import '../../domain/entity/login_google_entity.dart';

class GoogleSignInModel extends GoogleSignInEntity{

  GoogleSignInModel({ super.isSuccess, super.errors, super.data});

  GoogleSignInModel.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    if (json['errors'] != null) {
      errors = <Errors>[];
      json['errors'].forEach((v) {
        errors!.add(Errors.fromJson(v));
      });
    }
    data = json['data'] != null ? GoogleSignInData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['isSuccess'] = isSuccess;
    if (errors != null) {
      data['errors'] = errors!.map((v) => v.toJson()).toList();
    }
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}
////////////////////////////////////////////////////////////////////////////////
class GoogleSignInData {
  String? token;
  String? refreshToken;

  GoogleSignInData({
    this.token,
    this.refreshToken,
  });

  GoogleSignInData.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    refreshToken = json['refreshToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    data['refreshToken'] = this.refreshToken;
    return data;
  }
}
