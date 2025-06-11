import '../../../../core/rest/error_model.dart';
import '../../domain/entity/confirm_email_entity.dart';

/// isSuccess : true
/// errors : [{"fieldName":"","code":"7026","message":"Failed :Invalid login credentials","fieldLang":null}]
/// data : {"isEmailExist":true,"isMobileVerified":true,"mobileId":187}

class ConfirmEmailModel  extends ConfirmEmailEntity{
  ConfirmEmailModel({
      bool? isSuccess, 
      List<Errors>? errors,
      CheckEmailData? data,}){
    _isSuccess = isSuccess;
    _errors = errors;
    _data = data;
}

  ConfirmEmailModel.fromJson(dynamic json) {
    _isSuccess = json['isSuccess'];
    if (json['errors'] != null) {
      _errors = [];
      json['errors'].forEach((v) {
        _errors?.add(Errors.fromJson(v));
      });
    }
    _data = json['data'] != null ? CheckEmailData.fromJson(json['data']) : null;
  }
  bool? _isSuccess;
  List<Errors>? _errors;
  CheckEmailData? _data;

  bool? get isSuccess => _isSuccess;
  List<Errors>? get errors => _errors;
  CheckEmailData? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['isSuccess'] = _isSuccess;
    if (_errors != null) {
      map['errors'] = _errors?.map((v) => v.toJson()).toList();
    }
    if (_data != null) {
      map['data'] = _data?.toJson();
    }
    return map;
  }

}

/// isEmailExist : true
/// isMobileVerified : true
/// mobileId : 187

class CheckEmailData {
  CheckEmailData({
      bool? isEmailExist, 
      bool? isMobileVerified, 
      int? mobileId,}){
    _isEmailExist = isEmailExist;
    _isMobileVerified = isMobileVerified;
    _mobileId = mobileId;
}

  CheckEmailData.fromJson(dynamic json) {
    _isEmailExist = json['isEmailExist'];
    _isMobileVerified = json['isMobileVerified'];
    _mobileId = json['mobileId'];
  }
  bool? _isEmailExist;
  bool? _isMobileVerified;
  int? _mobileId;

  bool? get isEmailExist => _isEmailExist;
  bool? get isMobileVerified => _isMobileVerified;
  int? get mobileId => _mobileId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['isEmailExist'] = _isEmailExist;
    map['isMobileVerified'] = _isMobileVerified;
    map['mobileId'] = _mobileId;
    return map;
  }
}