import '../../data/model/ChangeMobileModel.dart';

class ChangeMobileEntity {
  ChangeMobileEntity({
    bool? isSuccess,
    List<ChangeMobileErrors>? errors,
    ChangeMobileData? data,}) {
    _isSuccess = isSuccess;
    _errors = errors;
    _data = data;
  }


  bool? _isSuccess;
  List<ChangeMobileErrors>? _errors;
  ChangeMobileData? _data;

  bool? get isSuccess => _isSuccess;

  List<ChangeMobileErrors>? get errors => _errors;

  ChangeMobileData? get data => _data;
}