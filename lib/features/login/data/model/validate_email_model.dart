import '../../../../core/rest/error_model.dart';
import '../../domain/entity/validate_email_entity.dart';

class ValidateEmailModel extends ValidateEmailEntity{

  ValidateEmailModel({ super.isSuccess, super.errors, super.data});

  ValidateEmailModel.fromJson(dynamic json) {
    isSuccess = json['isSuccess'];
    if (json['errors'] != null) {
      errors = [];
      json['errors'].forEach((v) {
        errors?.add(Errors.fromJson(v));
      });
    }
    data = json['data'] != null ? ValidateEmailData.fromJson(json['data']) : null;
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
class ValidateEmailData {
  String? email;
  String? type;
  CustomerStatus? customerStatus;

  ValidateEmailData({
    this.customerStatus,
    this.type,
    this.email
  });

  ValidateEmailData.fromJson(dynamic json) {
    email = json['email'];
    type = json['type'];
    customerStatus = json['customerStatus'] != null ? CustomerStatus.fromJson(json['customerStatus']) : null;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['email'] = email;
    map['type'] = type;
    if (customerStatus != null) {
      map['customerStatus'] = customerStatus?.toJson();
    }
    return map;
  }
}
////////////////////////////////////////////////////////////////////////////////
class CustomerStatus {
  num? id;
  num? mobileId;
  num? emailId;
  String? expiryDate;
  dynamic blockTillDate;
  num? status;

  CustomerStatus({
    this.id,
    this.mobileId,
    this.emailId,
    this.expiryDate,
    this.blockTillDate,
    this.status
  });

  CustomerStatus.fromJson(dynamic json) {
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