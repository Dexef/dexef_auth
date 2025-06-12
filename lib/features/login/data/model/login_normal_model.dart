import '../../../../core/rest/error_model.dart';
import '../../domain/entity/login_normal_entity.dart';

class LoginModel extends LoginEntity {

  LoginModel({ super.isSuccess, super.errors, super.data});

  LoginModel.fromJson(dynamic json) {
    isSuccess = json['isSuccess'];
    if (json['errors'] != null) {
      errors = [];
      json['errors'].forEach((v) {
        errors?.add(Errors.fromJson(v));
      });
    }
    data = json['data'] != null ? LoginData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['isSuccess'] = isSuccess;
    if (errors != null) {
      map['errors'] = errors?.map((v) => v.toJson()).toList();
    }
    if (data != null) {
      map['data'] = data?.toJson();
    }
    return map;
  }
}
////////////////////////////////////////////////////////////////////////////////
class LoginData {
  String? token;
  String? refreshToken;

  LoginData({
    this.token,
    this.refreshToken,
  });

  LoginData.fromJson(dynamic json) {
    token = json['token'];
    refreshToken = json['refreshToken'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['token'] = token;
    map['refreshToken'] = refreshToken;
    return map;
  }
}

