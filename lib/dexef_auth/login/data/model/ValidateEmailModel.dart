import '../../../../core/rest/error_model.dart';
import '../../domain/entity/validate_email_entity.dart';

// ignore: must_be_immutable
class ValidateEmailModel extends ValidateEmailEntity{

  ValidateEmailModel({ super.isSuccess, super.errors, super.data});

  ValidateEmailModel.fromJson(dynamic json) {
    isSuccess = json['isSuccess'];
    if (json['errors'] != null) {
      errors = [];
      json['errors'].forEach((v) {
        errors?.add(Errors.fromJson(v));
      });
    }
    data = json['data'] != null ? ValidateEmailData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['isSuccess'] = isSuccess;
    if (errors != null) {
      map['errors'] = errors?.map((v) => v.toJson()).toList();
    }
    if (data != null) {
      map['data'] = data?.toJson();
    }
    return map;
  }

}

/// email : "alaabaker166@gmail.com"
/// type : "Google"
/// customerStatus : {"id":73238,"mobileId":70518,"emailId":0,"expiryDate":"2025-01-14T10:40:55.9622946Z","blockTillDate":null,"status":1}

class ValidateEmailData {
  ValidateEmailData({
      String? email, 
      String? type, 
      CustomerStatus? customerStatus,}){
    _email = email;
    _type = type;
    _customerStatus = customerStatus;
}

  ValidateEmailData.fromJson(dynamic json) {
    _email = json['email'];
    _type = json['type'];
    _customerStatus = json['customerStatus'] != null ? CustomerStatus.fromJson(json['customerStatus']) : null;
  }
  String? _email;
  String? _type;
  CustomerStatus? _customerStatus;
ValidateEmailData copyWith({  String? email,
  String? type,
  CustomerStatus? customerStatus,
}) => ValidateEmailData(  email: email ?? _email,
  type: type ?? _type,
  customerStatus: customerStatus ?? _customerStatus,
);
  String? get email => _email;
  String? get type => _type;
  CustomerStatus? get customerStatus => _customerStatus;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['email'] = _email;
    map['type'] = _type;
    if (_customerStatus != null) {
      map['customerStatus'] = _customerStatus?.toJson();
    }
    return map;
  }

}

/// id : 73238
/// mobileId : 70518
/// emailId : 0
/// expiryDate : "2025-01-14T10:40:55.9622946Z"
/// blockTillDate : null
/// status : 1

class CustomerStatus {
  CustomerStatus({
      num? id, 
      num? mobileId, 
      num? emailId, 
      String? expiryDate, 
      dynamic blockTillDate, 
      num? status,}){
    _id = id;
    _mobileId = mobileId;
    _emailId = emailId;
    _expiryDate = expiryDate;
    _blockTillDate = blockTillDate;
    _status = status;
}

  CustomerStatus.fromJson(dynamic json) {
    _id = json['id'];
    _mobileId = json['mobileId'];
    _emailId = json['emailId'];
    _expiryDate = json['expiryDate'];
    _blockTillDate = json['blockTillDate'];
    _status = json['status'];
  }
  num? _id;
  num? _mobileId;
  num? _emailId;
  String? _expiryDate;
  dynamic _blockTillDate;
  num? _status;
CustomerStatus copyWith({  num? id,
  num? mobileId,
  num? emailId,
  String? expiryDate,
  dynamic blockTillDate,
  num? status,
}) => CustomerStatus(  id: id ?? _id,
  mobileId: mobileId ?? _mobileId,
  emailId: emailId ?? _emailId,
  expiryDate: expiryDate ?? _expiryDate,
  blockTillDate: blockTillDate ?? _blockTillDate,
  status: status ?? _status,
);
  num? get id => _id;
  num? get mobileId => _mobileId;
  num? get emailId => _emailId;
  String? get expiryDate => _expiryDate;
  dynamic get blockTillDate => _blockTillDate;
  num? get status => _status;

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