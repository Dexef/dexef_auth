import 'package:auth_dexef/core/rest/error_model.dart';

class CreateNewPasswordEntity{

  CreateNewPasswordEntity({
    bool? isSuccess,
    List<Errors>? errors,
    bool? data,}){
    _isSuccess = isSuccess;
    _errors = errors;
    _data = data;
  }

  bool? _isSuccess;
  List<Errors>? _errors;
  bool? _data;

  bool? get isSuccess => _isSuccess;
  List<Errors>? get errors => _errors;
  bool? get data => _data;
}