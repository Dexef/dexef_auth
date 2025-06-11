
import '../../domain/entity/verify_forget_password_entity.dart';

/// isSuccess : false
/// errors : [{"fieldName":"","code":"7065","message":"Failed: Invalid code.","fieldLang":null}]
/// data : false

class VerifyForgetPasswordModel extends VerifyForgetPasswordEntity{
  VerifyForgetPasswordModel({
      bool? isSuccess, 
      List<VerifyForgetPasswordErrors>? errors,
      bool? verifyForgetPasswordData,}){
    _isSuccess = isSuccess;
    _errors = errors;
    _data = verifyForgetPasswordData;
}

  VerifyForgetPasswordModel.fromJson(dynamic json) {
    _isSuccess = json['isSuccess'];
    if (json['errors'] != null) {
      _errors = [];
      json['errors'].forEach((v) {
        _errors?.add(VerifyForgetPasswordErrors.fromJson(v));
      });
    }
    _data = json['data'];
  }
  bool? _isSuccess;
  List<VerifyForgetPasswordErrors>? _errors;
  bool? _data;

  bool? get isSuccess => _isSuccess;
  List<VerifyForgetPasswordErrors>? get errors => _errors;
  bool? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['isSuccess'] = _isSuccess;
    if (_errors != null) {
      map['errors'] = _errors?.map((v) => v.toJson()).toList();
    }
    map['data'] = _data;
    return map;
  }

}

/// fieldName : ""
/// code : "7065"
/// message : "Failed: Invalid code."
/// fieldLang : null

class VerifyForgetPasswordErrors {
  VerifyForgetPasswordErrors({
      String? fieldName, 
      String? code, 
      String? message, 
      dynamic fieldLang,}){
    _fieldName = fieldName;
    _code = code;
    _message = message;
    _fieldLang = fieldLang;
}

  VerifyForgetPasswordErrors.fromJson(dynamic json) {
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