import 'package:auth_dexef/core/rest/error_model.dart';

import '../../domain/entity/reset_password_entity.dart';

class ResetPasswordModel extends ResetPasswordEntity{

  ResetPasswordModel({super.isSuccess, super.errors, super.data});

  ResetPasswordModel.fromJson(dynamic json) {
    isSuccess = json['isSuccess'];
    if (json['errors'] != null) {
      errors = [];
      json['errors'].forEach((v) {
        errors?.add(Errors.fromJson(v));
      });
    }
    data = json['data'] != null ? ResetPasswordData.fromJson(json['data']) : null;
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
class ResetPasswordData {
  int? id;
  int? mobileId;
  int? emailId;
  String? expiryDate;
  String? blockTillDate;
  int? status;

  ResetPasswordData({
    this.id,
    this.mobileId,
    this.emailId,
    this.expiryDate,
    this.blockTillDate,
    this.status
  });

  ResetPasswordData.fromJson(dynamic json) {
    id = json['id'];
    mobileId = json['mobileId'];
    emailId = json['emailId'];
    expiryDate = json['expiryDate'];
    blockTillDate = json['blockTillDate'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['mobileId'] = mobileId;
    map['emailId'] = emailId;
    map['expiryDate'] = expiryDate;
    map['blockTillDate'] = blockTillDate;
    map['status'] = status;
    return map;
  }
}
