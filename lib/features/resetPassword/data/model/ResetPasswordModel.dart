
import '../../domain/entity/reset_password_entity.dart';

/// isSuccess : true
/// errors : [{"fieldName":"Password","code":"6004","message":"Failed : [Password] Must Be Between [8] And [500]","fieldLang":null}]
/// data : {"id":279,"mobileId":270,"emailId":0,"expiryDate":"2023-07-20T12:06:10.2381768Z","blockTillDate":null,"status":1}

class ResetPasswordModel extends ResetPasswordEntity{
  ResetPasswordModel({
      bool? isSuccess, 
      List<ResetPasswordErrors>? errors,
      ResetPasswordData? data,}){
    _isSuccess = isSuccess;
    _errors = errors;
    _data = data;
}

  ResetPasswordModel.fromJson(dynamic json) {
    _isSuccess = json['isSuccess'];
    if (json['errors'] != null) {
      _errors = [];
      json['errors'].forEach((v) {
        _errors?.add(ResetPasswordErrors.fromJson(v));
      });
    }
    _data = json['data'] != null ? ResetPasswordData.fromJson(json['data']) : null;
  }
  bool? _isSuccess;
  List<ResetPasswordErrors>? _errors;
  ResetPasswordData? _data;

  bool? get isSuccess => _isSuccess;
  List<ResetPasswordErrors>? get errors => _errors;
  ResetPasswordData? get data => _data;

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

/// id : 279
/// mobileId : 270
/// emailId : 0
/// expiryDate : "2023-07-20T12:06:10.2381768Z"
/// blockTillDate : null
/// status : 1

class ResetPasswordData {
  ResetPasswordData({
      int? id, 
      int? mobileId, 
      int? emailId, 
      String? expiryDate, 
      dynamic blockTillDate, 
      int? status,}){
    _id = id;
    _mobileId = mobileId;
    _emailId = emailId;
    _expiryDate = expiryDate;
    _blockTillDate = blockTillDate;
    _status = status;
}

  ResetPasswordData.fromJson(dynamic json) {
    _id = json['id'];
    _mobileId = json['mobileId'];
    _emailId = json['emailId'];
    _expiryDate = json['expiryDate'];
    _blockTillDate = json['blockTillDate'];
    _status = json['status'];
  }
  int? _id;
  int? _mobileId;
  int? _emailId;
  String? _expiryDate;
  dynamic _blockTillDate;
  int? _status;

  int? get id => _id;
  int? get mobileId => _mobileId;
  int? get emailId => _emailId;
  String? get expiryDate => _expiryDate;
  dynamic get blockTillDate => _blockTillDate;
  int? get status => _status;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['mobileId'] = _mobileId;
    map['emailId'] = _emailId;
    map['expiryDate'] = _expiryDate;
    map['blockTillDate'] = _blockTillDate;
    map['status'] = _status;
    return map;
  }

}

/// fieldName : "Password"
/// code : "6004"
/// message : "Failed : [Password] Must Be Between [8] And [500]"
/// fieldLang : null

class ResetPasswordErrors {
  ResetPasswordErrors({
      String? fieldName, 
      String? code, 
      String? message, 
      dynamic fieldLang,}){
    _fieldName = fieldName;
    _code = code;
    _message = message;
    _fieldLang = fieldLang;
}

  ResetPasswordErrors.fromJson(dynamic json) {
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