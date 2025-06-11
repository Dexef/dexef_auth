import '../../../../core/rest/error_model.dart';
import '../../domain/entity/verify_code_entity.dart';

class VerifyCodeModel extends VerifyCodeEntity {
  VerifyCodeModel({
      bool? isSuccess, 
      List<Errors>? errors,
      VerifyCodeData? data,}){
    _isSuccess = isSuccess;
    _errors = errors;
    _data = data;
}

  VerifyCodeModel.fromJson(dynamic json) {
    _isSuccess = json['isSuccess'];
    if (json['errors'] != null) {
      _errors = [];
      json['errors'].forEach((v) {
        _errors?.add(Errors.fromJson(v));
      });
    }
    _data = json['data'] != null ? VerifyCodeData.fromJson(json['data']) : null;
  }
  bool? _isSuccess;
  List<Errors>? _errors;
  VerifyCodeData? _data;

  bool? get isSuccess => _isSuccess;
  List<Errors>? get errors => _errors;
  VerifyCodeData? get data => _data;

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
/// expiryDate : null
/// blockTillDate : null
/// status : 0

class VerifyCodeData {
  VerifyCodeData({
      int? id, 
      int? mobileId, 
      int? emailId, 
      dynamic expiryDate, 
      dynamic blockTillDate, 
      int? status,}){
    _id = id;
    _mobileId = mobileId;
    _emailId = emailId;
    _expiryDate = expiryDate;
    _blockTillDate = blockTillDate;
    _status = status;
}

  VerifyCodeData.fromJson(dynamic json) {
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
  dynamic _expiryDate;
  dynamic _blockTillDate;
  int? _status;

  int? get id => _id;
  int? get mobileId => _mobileId;
  int? get emailId => _emailId;
  dynamic get expiryDate => _expiryDate;
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
