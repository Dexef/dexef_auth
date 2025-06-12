import 'package:auth_dexef/core/rest/error_model.dart';
import 'package:equatable/equatable.dart';
import '../../data/model/ResetPasswordModel.dart';

class ResetPasswordEntity extends Equatable{
  ResetPasswordEntity({
    this.isSuccess,
    this.errors,
    this.data
  });

  bool? isSuccess;
  List<Errors>? errors;
  ResetPasswordData? data;

  @override
  List<Object?> get props => [isSuccess , errors, data];
}


