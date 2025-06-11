
import '../../domain/entity/change_mobile_entity.dart';

/// isSuccess : true
/// errors : [{"fieldName":"","code":"7002","message":"Failed : [MobileId] Not Found","fieldLang":null}]
/// data : {"id":634,"mobileId":605,"emailId":0,"expiryDate":"2023-10-08T13:55:12.1290859Z","blockTillDate":null,"status":1}

class ChangeMobileModel extends ChangeMobileEntity {
  ChangeMobileModel({
      bool? isSuccess, 
      List<ChangeMobileErrors>? errors,
      ChangeMobileData? data,}){
    _isSuccess = isSuccess;
    _errors = errors;
    _data = data;
}

  ChangeMobileModel.fromJson(dynamic json) {
    _isSuccess = json['isSuccess'];
    if (json['errors'] != null) {
      _errors = [];
      json['errors'].forEach((v) {
        _errors?.add(ChangeMobileErrors.fromJson(v));
      });
    }
    _data = json['data'] != null ? ChangeMobileData.fromJson(json['data']) : null;
  }
  bool? _isSuccess;
  List<ChangeMobileErrors>? _errors;
  ChangeMobileData? _data;

  bool? get isSuccess => _isSuccess;
  List<ChangeMobileErrors>? get errors => _errors;
  ChangeMobileData? get data => _data;

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

/// id : 634
/// mobileId : 605
/// emailId : 0
/// expiryDate : "2023-10-08T13:55:12.1290859Z"
/// blockTillDate : null
/// status : 1

class ChangeMobileData {
  ChangeMobileData({
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

  ChangeMobileData.fromJson(dynamic json) {
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

/// fieldName : ""
/// code : "7002"
/// message : "Failed : [MobileId] Not Found"
/// fieldLang : null

class ChangeMobileErrors {
  ChangeMobileErrors({
      String? fieldName, 
      String? code, 
      String? message, 
      dynamic fieldLang,}){
    _fieldName = fieldName;
    _code = code;
    _message = message;
    _fieldLang = fieldLang;
}

  ChangeMobileErrors.fromJson(dynamic json) {
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