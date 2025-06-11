import 'package:auth_dexef/core/rest/error_model.dart';

import '../../data/model/ConfirmEmailModel.dart';

class ConfirmEmailEntity {
  ConfirmEmailEntity({
    bool? isSuccess,
    List<Errors>? errors,
    CheckEmailData? data,}){
    _isSuccess = isSuccess;
    _errors = errors;
    _data = data;
  }
  ConfirmEmailEntity.fromJson(dynamic json) {
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