import '../../../../core/rest/error_model.dart';
import '../../domain/entity/social_entity.dart';

// ignore: must_be_immutable
class SocialModel extends SocialEntity{

  SocialModel({ bool? isSuccess, List <Errors>? errors, SocialData? data}) : super(data: data, errors: errors, isSuccess: isSuccess);

  SocialModel.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    if (json['errors'] != null) {
      errors = <Errors>[];
      json['errors'].forEach((v) {
        errors!.add(Errors.fromJson(v));
      });
    }
    data = json['data'] != null ? SocialData.fromJson(json['data']) : null;
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

class SocialData {
  String? token;
  String? refreshToken;

  SocialData({
    this.token,
    this.refreshToken,
  });

  SocialData.fromJson(Map<String, dynamic> json) {
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