
import 'package:auth_dexef/core/rest/error_model.dart';
import '../../data/model/LoginModel.dart';

class LoginEntity {
  LoginEntity({
    bool? isSuccess,
    List<Errors>? errors,
    LoginData? data,}){
    _isSuccess = isSuccess;
    _errors = errors;
    _data = data;
  }


  bool? _isSuccess;
  List<Errors>? _errors;
  LoginData? _data;

  bool? get isSuccess => _isSuccess;
  List<Errors>? get errors => _errors;
  LoginData? get data => _data;
}