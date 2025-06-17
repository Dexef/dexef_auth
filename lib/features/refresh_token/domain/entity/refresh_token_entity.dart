
import '../../data/model/refresh_token_model.dart';

class RefreshTokenEntity{
  RefreshTokenEntity({
    bool? isSuccess,
    List<Errors>? errors,
    Data? data,}){
    _isSuccess = isSuccess;
    _errors = errors;
    _data = data;
  }
  bool? _isSuccess;
  List<Errors>? _errors;
  Data? _data;

  bool? get isSuccess => _isSuccess;
  List<Errors>? get errors => _errors;
  Data? get data => _data;


}