import '../../../../core/rest/error_model.dart';
import '../../domain/entity/register_apple_entity.dart';

class RegisterAppleModel extends RegisterAppleEntity{

  RegisterAppleModel({ super.isSuccess, super.errors, super.data});

  RegisterAppleModel.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    if (json['errors'] != null) {
      errors = <Errors>[];
      json['errors'].forEach((v) {
        errors!.add(Errors.fromJson(v));
      });
    }
    data = json['data'] != null ? RegisterAppleData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isSuccess'] = this.isSuccess;
    if (this.errors != null) {
      data['errors'] = this.errors!.map((v) => v.toJson()).toList();
    }
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}
////////////////////////////////////////////////////////////////////////////////
class RegisterAppleData {
  int? id;
  int? mobileId;
  int? emailId;
  String? expiryDate;
  String? blockTillDate;
  int? status;

  RegisterAppleData(
      {this.id,
        this.mobileId,
        this.emailId,
        this.expiryDate,
        this.blockTillDate,
        this.status});

  RegisterAppleData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    mobileId = json['mobileId'];
    emailId = json['emailId'];
    expiryDate = json['expiryDate'];
    blockTillDate = json['blockTillDate'];
    status = json['status'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['mobileId'] = this.mobileId;
    data['emailId'] = this.emailId;
    data['expiryDate'] = this.expiryDate;
    data['blockTillDate'] = this.blockTillDate;
    data['status'] = this.status;
    return data;
  }
}
