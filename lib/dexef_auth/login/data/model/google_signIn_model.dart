import '../../../../core/rest/error_model.dart';
import '../../domain/entity/google_signIn_entity.dart';

// ignore: must_be_immutable
class GoogleSignInModel extends GoogleSignInEntity{

  GoogleSignInModel({ super.isSuccess, super.errors, super.data});

  GoogleSignInModel.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    if (json['errors'] != null) {
      errors = <Errors>[];
      json['errors'].forEach((v) {
        errors!.add(Errors.fromJson(v));
      });
    }
    data = json['data'] != null ? GoogleSignInData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['isSuccess'] = isSuccess;
    if (errors != null) {
      data['errors'] = errors!.map((v) => v.toJson()).toList();
    }
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class GoogleSignInData {
  String? token;
  String? refreshToken;

  GoogleSignInData({
    this.token,
    this.refreshToken,
  });

  GoogleSignInData.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    refreshToken = json['refreshToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    data['refreshToken'] = this.refreshToken;
    return data;
  }
}

// class SignInGoogleError {
//   SignInGoogleError({
//     String? fieldName,
//     String? code,
//     String? message,
//     dynamic fieldLang,
//   }) {
//     _fieldName = fieldName;
//     _code = code;
//     _message = message;
//     _fieldLang = fieldLang;
//   }
//
//   SignInGoogleError.fromJson(dynamic json) {
//     _fieldName = json['fieldName'];
//     _code = json['code'];
//     _message = json['message'];
//     _fieldLang = json['fieldLang'];
//   }
//   String? _fieldName;
//   String? _code;
//   String? _message;
//   dynamic _fieldLang;
//
//   String? get fieldName => _fieldName;
//   String? get code => _code;
//   String? get message => _message;
//   dynamic get fieldLang => _fieldLang;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['fieldName'] = _fieldName;
//     map['code'] = _code;
//     map['message'] = _message;
//     map['fieldLang'] = _fieldLang;
//     return map;
//   }
// }
