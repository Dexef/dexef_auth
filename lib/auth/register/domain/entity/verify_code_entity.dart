import 'package:auth_dexef/core/rest/error_model.dart';
import '../../data/model/VerifyCodeModel.dart';

class VerifyCodeEntity{
  VerifyCodeEntity({
    bool? isSuccess,
    List<Errors>? errors,
    VerifyCodeData? data,}){
    _isSuccess = isSuccess;
    _errors = errors;
    _data = data;
  }


  bool? _isSuccess;
  List<Errors>? _errors;
  VerifyCodeData? _data;

  bool? get isSuccess => _isSuccess;
  List<Errors>? get errors => _errors;
  VerifyCodeData? get data => _data;
}