import 'package:equatable/equatable.dart';
import '../../../../core/rest/error_model.dart';
import '../../data/model/LoginModel.dart';

class LoginEntity extends Equatable{
  LoginEntity({
    this.data,
    this.errors,
    this.isSuccess
  });

  bool? isSuccess;
  List<Errors>?errors;
  LoginData? data;

  @override
  List<Object?> get props => [isSuccess , errors, data];
}