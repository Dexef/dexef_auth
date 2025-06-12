import 'package:auth_dexef/core/rest/error_model.dart';
import 'package:equatable/equatable.dart';

class CreateNewPasswordEntity extends Equatable{

  CreateNewPasswordEntity({
    this.isSuccess,
    this.errors,
    this.data
  });

  bool? isSuccess;
  List<Errors>? errors;
  bool? data;

  @override
  List<Object?> get props => [isSuccess , errors, data];
}