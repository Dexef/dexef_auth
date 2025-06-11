import '../../../../core/rest/error_model.dart';
import '../../domain/entity/sign_in_with_facebook_entity.dart';

class SignInFacebookModel extends SignInFacebookEntity{

  SignInFacebookModel({ bool? isSuccess, List <Errors>? errors, SignInFacebookData? data}) : super(data: data, errors: errors, isSuccess: isSuccess);

  SignInFacebookModel.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    if (json['errors'] != null) {
      errors = <Errors>[];
      json['errors'].forEach((v) {
        errors!.add(Errors.fromJson(v));
      });
    }
    data = json['data'] != null ? SignInFacebookData.fromJson(json['data']) : null;
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

class SignInFacebookData {
  String? token;
  String? refreshToken;

  SignInFacebookData({
    this.token,
    this.refreshToken,
  });

  SignInFacebookData.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    refreshToken = json['refreshToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = token;
    data['refreshToken'] = refreshToken;
    return data;
  }
}