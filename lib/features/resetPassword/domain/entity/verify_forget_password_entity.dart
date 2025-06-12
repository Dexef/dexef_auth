import '../../data/model/VerifyForgetPasswordModel.dart';

class VerifyForgetPasswordEntity{
  VerifyForgetPasswordEntity({
    bool? isSuccess,
    List<VerifyForgetPasswordErrors>? errors,
    bool? data,}){
    _isSuccess = isSuccess;
    _errors = errors;
    _data = data;
  }

  bool? _isSuccess;
  List<VerifyForgetPasswordErrors>? _errors;
  bool? _data;

  bool? get isSuccess => _isSuccess;
  List<VerifyForgetPasswordErrors>? get errors => _errors;
  bool? get data => _data;
}