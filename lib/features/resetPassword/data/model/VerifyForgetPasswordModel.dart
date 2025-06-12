import 'package:auth_dexef/core/rest/error_model.dart';
import '../../domain/entity/verify_forget_password_entity.dart';

class VerifyForgetPasswordModel extends VerifyForgetPasswordEntity{

  VerifyForgetPasswordModel({ super.isSuccess, super.errors, super.data});

  VerifyForgetPasswordModel.fromJson(dynamic json) {
    isSuccess = json['isSuccess'];
    if (json['errors'] != null) {
      errors = [];
      json['errors'].forEach((v) {
        errors?.add(Errors.fromJson(v));
      });
    }
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['isSuccess'] = isSuccess;
    if (errors != null) {
      map['errors'] = errors?.map((v) => v.toJson()).toList();
    }
    map['data'] = data;
    return map;
  }
}