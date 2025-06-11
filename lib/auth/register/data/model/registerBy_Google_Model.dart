import 'package:auth_dexef/core/rest/error_model.dart';
import '../../domain/entity/register_with_google_entity.dart';

class RegisterByGoogleModel extends RegisterByGoogleEntity{

  RegisterByGoogleModel({ bool? isSuccess, List <Errors>? errors, RegisterByGoogleData? data})
      : super(data: data, errors: errors, isSuccess: isSuccess);

  RegisterByGoogleModel.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    if (json['errors'] != null) {
      errors = <Errors>[];
      json['errors'].forEach((v) {
        errors!.add(Errors.fromJson(v));
      });
    }
    data = json['data'] != null ? RegisterByGoogleData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
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

class RegisterByGoogleData {
  int? id;
  int? mobileId;
  int? emailId;
  String? expiryDate;
  dynamic blockTillDate;
  int? status;

  RegisterByGoogleData(
      {this.id,
        this.mobileId,
        this.emailId,
        this.expiryDate,
        this.blockTillDate,
        this.status});

  RegisterByGoogleData.fromJson(Map<String, dynamic> json) {
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

class RegisterByGoogleErrors {
  RegisterByGoogleErrors({
    String? fieldName,
    String? code,
    String? message,
    dynamic fieldLang,}){
    _fieldName = fieldName;
    _code = code;
    _message = message;
    _fieldLang = fieldLang;
  }

  RegisterByGoogleErrors.fromJson(dynamic json) {
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











// import '../../domain/entities/register_with_google_entity.dart';
// import 'ResetPasswordModel.dart';
//
// class RegisterByGoogleModel  extends RegisterByGoogleEntity{
//
//   RegisterByGoogleModel({
//     bool? isSuccess,
//     List<Errors>? errors,
//     RegisterGoogleData? data,
//   }){
//     _isSuccess = isSuccess;
//     _errors = errors;
//     _data = data;
//   }
//
//   bool? _isSuccess;
//   List<Errors>? _errors;
//   RegisterGoogleData? _data;
//
//   bool? get isSuccess => _isSuccess;
//   List <Errors>? get errors => _errors;
//   RegisterGoogleData? get data => _data;
//
//   RegisterByGoogleModel.fromJson(dynamic json) {
//     _isSuccess = json['isSuccess'];
//     if (json['errors'] != null) {
//       _errors = [];
//       json['errors'].forEach((v) {
//         _errors?.add(Errors.fromJson(v));
//       });
//     }
//     _data = json['data'] != null ? RegisterGoogleData.fromJson(json['data']) : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['isSuccess'] = _isSuccess;
//     if (_errors != null) {
//       map['errors'] = _errors?.map((v) => v.toJson()).toList();
//     }
//     if (_data != null) {
//       map['data'] = _data?.toJson();
//     }
//     return map;
//   }
// }
//
// class RegisterGoogleData{
//   RegisterGoogleData({
//     int? id,
//     int? mobileId,
//     int? emailId,
//     String? expiryDate,
//     dynamic blockTillDate,
//     int? status,
//   }){
//     _id = id;
//     _mobileId = mobileId!;
//     _emailId = emailId;
//     _expiryDate = expiryDate;
//     _blockTillDate = blockTillDate;
//     _status = status;
//   }
//
//   int? _id;
//   int? _mobileId;
//   int? _emailId;
//   String? _expiryDate;
//   dynamic _blockTillDate;
//   int? _status;
//
//   int? get id => _id;
//   int? get mobileId => _mobileId;
//   int? get emailId => _emailId;
//   String? get expiryDate => _expiryDate;
//   dynamic get blockTillDate => _blockTillDate;
//   int? get status => _status;
//
//   RegisterGoogleData.fromJson(dynamic json){
//     _id = json['id'];
//     _mobileId = json['mobileId'];
//     _emailId = json['emailId'];
//     _expiryDate = json['expiryDate'];
//     _blockTillDate = json['blockTillDate'];
//     _status = json['status'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['id'] = _id;
//     map['mobileId'] = _mobileId;
//     map['emailId'] = _emailId;
//     map['expiryDate'] = _expiryDate;
//     map['blockTillDate'] = _blockTillDate;
//     map['status'] = _status;
//     return map;
//   }
// }
//
//


