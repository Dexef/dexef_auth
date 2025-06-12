import 'package:auth_dexef/core/rest/error_model.dart';
import 'package:equatable/equatable.dart';
import '../../data/model/login_normal_model.dart';

class LoginEntity extends Equatable{
  LoginEntity({
    this.isSuccess,
    this.errors,
    this.data,
  });

  bool? isSuccess;
  List <Errors>? errors;
  LoginData? data;

  @override
  List<Object?> get props => [isSuccess , errors, data];
}