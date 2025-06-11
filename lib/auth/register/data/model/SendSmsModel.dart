import '../../domain/entity/send_sms_entity.dart';

/// isSuccess : true
/// errors : [{"fieldName":"Password","code":"6004","message":"Failed : [Password] Must Be Between [8] And [500]","fieldLang":null}]
/// data : {"id":279,"mobileId":270,"emailId":0,"expiryDate":"2023-07-17T09:57:34.7100112Z","blockTillDate":"2023-07-17T09:59:34.7042204Z","status":1}

class SendSmsModel extends SendSmsEntity{
  SendSmsModel({
    bool? isSuccess,
    List<SendSmsErrors>? errors,
    SendSmsData? data,}){
    _isSuccess = isSuccess;
    _errors = errors;
    _data = data;
  }

  SendSmsModel.fromJson(dynamic json) {
    _isSuccess = json['isSuccess'];
    if (json['errors'] != null) {
      _errors = [];
      json['errors'].forEach((v) {
        _errors?.add(SendSmsErrors.fromJson(v));
      });
    }
    _data = json['data'] != null ? SendSmsData.fromJson(json['data']) : null;
  }
  bool? _isSuccess;
  List<SendSmsErrors>? _errors;
  SendSmsData? _data;

  bool? get isSuccess => _isSuccess;
  List<SendSmsErrors>? get errors => _errors;
  SendSmsData? get data => _data;

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
/// expiryDate : "2023-07-17T09:57:34.7100112Z"
/// blockTillDate : "2023-07-17T09:59:34.7042204Z"
/// status : 1

class SendSmsData {
  SendSmsData({
    int? id,
    int? mobileId,
    int? emailId,
    String? expiryDate,
    String? blockTillDate,
    int? status,}){
    _id = id;
    _mobileId = mobileId;
    _emailId = emailId;
    _expiryDate = expiryDate;
    _blockTillDate = blockTillDate;
    _status = status;
  }

  SendSmsData.fromJson(dynamic json) {
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
  String? _blockTillDate;
  int? _status;

  int? get id => _id;
  int? get mobileId => _mobileId;
  int? get emailId => _emailId;
  String? get expiryDate => _expiryDate;
  String? get blockTillDate => _blockTillDate;
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

class SendSmsErrors {
  SendSmsErrors({
    String? fieldName,
    String? code,
    String? message,
    dynamic fieldLang,}){
    _fieldName = fieldName;
    _code = code;
    _message = message;
    _fieldLang = fieldLang;
  }

  SendSmsErrors.fromJson(dynamic json) {
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