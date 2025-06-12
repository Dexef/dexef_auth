import '../../../../core/rest/error_model.dart';
import '../../domain/entity/verify_code_entity.dart';

class VerifyCodeModel extends VerifyCodeEntity {

  VerifyCodeModel({super.isSuccess, super.errors, super.data});

  VerifyCodeModel.fromJson(dynamic json) {
    isSuccess = json['isSuccess'];
    if (json['errors'] != null) {
      errors = [];
      json['errors'].forEach((v) {
        errors?.add(Errors.fromJson(v));
      });
    }
    data = json['data'] != null ? VerifyCodeData.fromJson(json['data']) : null;
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
class VerifyCodeData {
  int? id;
  int? mobileId;
  int? emailId;
  String? expiryDate;
  String? blockTillDate;
  int? status;

  VerifyCodeData({
    this.id,
    this.mobileId,
    this.emailId,
    this.expiryDate,
    this.blockTillDate,
    this.status
  });

  VerifyCodeData.fromJson(dynamic json) {
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
