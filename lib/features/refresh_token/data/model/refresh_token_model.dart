// To parse this JSON data, do
//
//     final refreshTokenModel = refreshTokenModelFromJson(jsonString);

import 'dart:convert';

import '../../domain/entity/refresh_token_entity.dart';


RefreshTokenModel refreshTokenModelFromJson(String str) => RefreshTokenModel.fromJson(json.decode(str));

String refreshTokenModelToJson(RefreshTokenModel data) => json.encode(data.toJson());

class RefreshTokenModel  extends RefreshTokenEntity{
  RefreshTokenModel({
    bool? isSuccess,
    List<Errors>? errors,
    Data? data,}){
    _isSuccess = isSuccess;
    _errors = errors;
    _data = data;
  }

  RefreshTokenModel.fromJson(dynamic json) {
    _isSuccess = json['isSuccess'];
    if (json['errors'] != null) {
      _errors = [];
      json['errors'].forEach((v) {
        _errors?.add(Errors.fromJson(v));
      });
    }
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  bool? _isSuccess;
  List<Errors>? _errors;
  Data? _data;

  bool? get isSuccess => _isSuccess;
  List<Errors>? get errors => _errors;
  Data? get data => _data;

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

class Data {
  String? token;
  String? refreshToken;

  Data({
    this.token,
    this.refreshToken,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    token: json["token"],
    refreshToken: json["refreshToken"],
  );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    data['refreshToken'] = this.refreshToken;
    return data;
  }
}

class Errors {
  Errors({
    String? fieldName,
    String? code,
    String? message,
    dynamic fieldLang,}){
    _fieldName = fieldName;
    _code = code;
    _message = message;
    _fieldLang = fieldLang;
  }

  Errors.fromJson(dynamic json) {
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
