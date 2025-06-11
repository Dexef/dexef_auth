import '../../../../core/rest/error_model.dart';
import '../../data/model/ValidateEmailModel.dart';

class ValidateEmailEntity {
  ValidateEmailEntity({
    bool? isSuccess,
    List<Errors>? errors,
    ValidateEmailData? data,}){
    _isSuccess = isSuccess;
    _errors = errors;
    _data = data;
  }

  bool? _isSuccess;
  List<Errors>? _errors;
  ValidateEmailData? _data;

  bool? get isSuccess => _isSuccess;
  List<Errors>? get errors => _errors;
  ValidateEmailData? get data => _data;
  set data(ValidateEmailData? value) => _data = value;
}
