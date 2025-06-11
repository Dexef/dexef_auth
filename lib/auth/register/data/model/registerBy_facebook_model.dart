
import '../../domain/entity/register_with_facebook_entity.dart';

class RegisterFacebookModel extends RegisterFacebookEntity{

  RegisterFacebookModel({ bool? isSuccess, List <RegisterFacebookErrors>? errors, RegisterFacebookData? data})
      : super(data: data, errors: errors, isSuccess: isSuccess);

  RegisterFacebookModel.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    if (json['errors'] != null) {
      errors = <RegisterFacebookErrors>[];
      json['errors'].forEach((v) {
        errors!.add(RegisterFacebookErrors.fromJson(v));
      });
    }
    data = json['data'] != null ? RegisterFacebookData.fromJson(json['data']) : null;
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

class RegisterFacebookData {
  int? id;
  int? mobileId;
  int? emailId;
  String? expiryDate;
  dynamic blockTillDate;
  int? status;

  RegisterFacebookData(
  {this.id,
  this.mobileId,
  this.emailId,
  this.expiryDate,
  this.blockTillDate,
  this.status});

  RegisterFacebookData.fromJson(Map<String, dynamic> json) {
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

class RegisterFacebookErrors {
  RegisterFacebookErrors({
    String? fieldName,
    String? code,
    String? message,
    dynamic fieldLang,}){
    _fieldName = fieldName;
    _code = code;
    _message = message;
    _fieldLang = fieldLang;
  }

  RegisterFacebookErrors.fromJson(dynamic json) {
    _fieldName = json['fieldName'];
    _code = json['code'];
    _message = json['message'];
    _fieldLang = json['fieldLang'];
  }
  String? _fieldName;
  String? _code;
  String? _message;
  dynamic _fieldLang;

  String? get fieldName => _fieldName;
  String? get code => _code;
  String? get message => _message;
  dynamic get fieldLang => _fieldLang;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['fieldName'] = _fieldName;
    map['code'] = _code;
    map['message'] = _message;
    map['fieldLang'] = _fieldLang;
    return map;
  }
}




