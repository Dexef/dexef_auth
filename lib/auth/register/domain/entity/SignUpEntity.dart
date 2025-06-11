import 'package:auth_dexef/core/rest/error_model.dart';
import '../../data/model/SignUpModel.dart';

/// status : "Success"
/// errors : [{"fieldName":"Email","message":"Email Already Registered","code":null},{"fieldName":"Phone","message":"Phone is in invalid Format","code":null}]
/// data : {"customerId":277,"customerFullName":"amr","customerEmail":"amr@gmail.com","customerPhone":"+201025314161","accessToken":"","phoneVerified":false,"customerPhone2":"","phonePrefix":"20","mobileId":270,"emailId":0,"expiryDate":"0001-01-01T00:00:00","status":1,"country":null,"customerPassword":"Aa#123456","rememberLoginInfo":false,"registerationType":{"typeId":3,"typeName":"Normal","typeImage":null},"registerationTypeTypeId":3,"workSpaces":[],"customerMobile":"+20102531416120","registerationIP":"197.34.59.107"}

class SignUpEntity {
  SignUpEntity({
    bool? isSuccess,
    List<Errors>? errors,
    SignUpData? data,}){
    _isSuccess = isSuccess;
    _errors = errors;
    _data = data;
  }

  bool? _isSuccess;
  List<Errors>? _errors;
  SignUpData? _data;

  bool? get isSuccess => _isSuccess;
  List<Errors>? get errors => _errors;
  SignUpData? get data => _data;


}

