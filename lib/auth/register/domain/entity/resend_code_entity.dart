
import 'package:auth_dexef/core/rest/error_model.dart';

import '../../data/model/ResendCodeModel.dart';

class ResendCodeEntity{
  ResendCodeEntity({
    bool? isSuccess,
    List<Errors>? errors,
    ResendCodeData? data,}){
    _isSuccess = isSuccess;
    _errors = errors;
    _data = data;
  }

  bool? _isSuccess;
  List<Errors>? _errors;
  ResendCodeData? _data;

  bool? get isSuccess => _isSuccess;
  List<Errors>? get errors => _errors;
  ResendCodeData? get data => _data;

}

