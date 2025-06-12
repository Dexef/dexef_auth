import 'package:auth_dexef/core/rest/error_model.dart';

import '../../domain/entity/send_sms_entity.dart';

/// isSuccess : true
/// errors : [{"fieldName":"Password","code":"6004","message":"Failed : [Password] Must Be Between [8] And [500]","fieldLang":null}]
/// data : {"id":279,"mobileId":270,"emailId":0,"expiryDate":"2023-07-17T09:57:34.7100112Z","blockTillDate":"2023-07-17T09:59:34.7042204Z","status":1}

class SendSmsModel extends SendSmsEntity{

  SendSmsModel({super.isSuccess, super.errors, super.data});

  SendSmsModel.fromJson(dynamic json) {
    isSuccess = json['isSuccess'];
    if (json['errors'] != null) {
      errors = [];
      json['errors'].forEach((v) {
        errors?.add(Errors.fromJson(v));
      });
    }
    data = json['data'] != null ? SendSmsData.fromJson(json['data']) : null;
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
////////////////////////////////////////////////////////////////////////////////
class SendSmsData {
  int? id;
  int? mobileId;
  int? emailId;
  String? expiryDate;
  String? blockTillDate;
  int? status;

  SendSmsData({
    this.id,
    this.mobileId,
    this.emailId,
    this.expiryDate,
    this.blockTillDate,
    this.status
  });

  SendSmsData.fromJson(dynamic json) {
    id = json['id'];
    mobileId = json['mobileId'];
    emailId = json['emailId'];
    expiryDate = json['expiryDate'];
    blockTillDate = json['blockTillDate'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['mobileId'] = mobileId;
    map['emailId'] = emailId;
    map['expiryDate'] = expiryDate;
    map['blockTillDate'] = blockTillDate;
    map['status'] = status;
    return map;
  }
}
