import '../../../../core/rest/error_model.dart';
import '../../domain/entity/SignUpEntity.dart';

/// isSuccess : true
/// errors : [{"fieldName":"Password","code":"6004","message":"Failed : [Password] Must Be Between [8] And [500]","fieldLang":null}]
/// data : {"id":279,"mobileId":270,"emailId":0,"expiryDate":"2023-07-17T09:57:34.7100112Z","blockTillDate":"2023-07-17T09:59:34.7042204Z","status":1}

class SignUpModel extends SignUpEntity{
  SignUpModel({
      bool? isSuccess, 
      List<Errors>? errors,
      SignUpData? data,}){
    _isSuccess = isSuccess;
    _errors = errors;
    _data = data;
}

  SignUpModel.fromJson(dynamic json) {
    _isSuccess = json['isSuccess'];
    if (json['errors'] != null) {
      _errors = [];
      json['errors'].forEach((v) {
        _errors?.add(Errors.fromJson(v));
      });
    }
    _data = json['data'] != null ? SignUpData.fromJson(json['data']) : null;
  }
  bool? _isSuccess;
  List<Errors>? _errors;
  SignUpData? _data;

  bool? get isSuccess => _isSuccess;
  List<Errors>? get errors => _errors;
  SignUpData? get data => _data;

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

class SignUpData {
  SignUpData({
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

  SignUpData.fromJson(dynamic json) {
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
