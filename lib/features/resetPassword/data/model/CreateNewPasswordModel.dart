import 'package:auth_dexef/core/rest/error_model.dart';
import '../../domain/entity/create_new_password_entity.dart';

/// isSuccess : false
/// errors : [{"fieldName":"Password","code":"6004","message":"Failed : [Password] Must Be Between [8] And [500]","fieldLang":null},{"fieldName":"Password","code":"6015","message":"Failed :[Password] should contain at least 1 digit","fieldLang":null},{"fieldName":"Password","code":"6017","message":"Failed  :[Password] should contain at least one special character","fieldLang":null}]
/// data : false

class CreateNewPasswordModel  extends CreateNewPasswordEntity{
  CreateNewPasswordModel({
      bool? isSuccess, 
      List<Errors>? errors,
      bool? createNewPasswordData,}){
    _isSuccess = isSuccess;
    _errors = errors;
    _data = createNewPasswordData;
}

  CreateNewPasswordModel.fromJson(dynamic json) {
    _isSuccess = json['isSuccess'];
    if (json['errors'] != null) {
      _errors = [];
      json['errors'].forEach((v) {
        _errors?.add(Errors.fromJson(v));
      });
    }
    _data = json['data'];
  }
  bool? _isSuccess;
  List<Errors>? _errors;
  bool? _data;

  bool? get isSuccess => _isSuccess;
  List<Errors>? get errors => _errors;
  bool? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['isSuccess'] = _isSuccess;
    if (_errors != null) {
      map['errors'] = _errors?.map((v) => v.toJson()).toList();
    }
    map['data'] = _data;
    return map;
  }

}
