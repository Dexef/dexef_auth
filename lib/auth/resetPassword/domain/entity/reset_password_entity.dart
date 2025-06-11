
import '../../data/model/ResetPasswordModel.dart';


class ResetPasswordEntity {
  ResetPasswordEntity({
    bool? isSuccess,
    List<ResetPasswordErrors>? errors,
    ResetPasswordData? data,}){

    _isSuccess = isSuccess;
    _errors = errors;
    _data = data;
  }

  bool? _isSuccess;
  List<ResetPasswordErrors>? _errors;
  ResetPasswordData? _data;

  bool? get isSuccess => _isSuccess;
  List<ResetPasswordErrors>? get errors => _errors;
  ResetPasswordData? get data => _data;


}


