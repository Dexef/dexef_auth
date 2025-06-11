
import '../../domain/entity/resend_code_entity.dart';

/// isSuccess : true
/// errors : []
/// data : {"id":279,"mobileId":270,"emailId":0,"expiryDate":"2023-07-17T12:05:10.7650716Z","blockTillDate":null,"status":1}

class ResendCodeModel extends ResendCodeEntity{
  ResendCodeModel({
      bool? isSuccess, 
      List<dynamic>? errors, 
      ResendCodeData? data,}){
    _isSuccess = isSuccess;
    _errors = errors;
    _data = data;
}

  ResendCodeModel.fromJson(dynamic json) {
    _isSuccess = json['isSuccess'];
    if (json['errors'] != null) {
      _errors = [];
      // json['errors'].forEach((v) {
      //   _errors?.add(Dynamic.fromJson(v));
      // });
    }
    _data = json['data'] != null ? ResendCodeData.fromJson(json['data']) : null;
  }
  bool? _isSuccess;
  List<dynamic>? _errors;
  ResendCodeData? _data;

  bool? get isSuccess => _isSuccess;
  List<dynamic>? get errors => _errors;
  ResendCodeData? get data => _data;

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
/// expiryDate : "2023-07-17T12:05:10.7650716Z"
/// blockTillDate : null
/// status : 1

class ResendCodeData {
  ResendCodeData({
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

  ResendCodeData.fromJson(dynamic json) {
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