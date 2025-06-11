import '../../data/model/SendSmsModel.dart';

class SendSmsEntity {
  SendSmsEntity({
    bool? isSuccess,
    List<SendSmsErrors>? errors,
    SendSmsData? data,}){
    _isSuccess = isSuccess;
    _errors = errors;
    _data = data;
  }

  SendSmsEntity.fromJson(dynamic json) {
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
