import 'package:auth_dexef/core/rest/error_model.dart';
import 'package:equatable/equatable.dart';
import '../../data/model/VerifyCodeModel.dart';

class VerifyCodeEntity extends Equatable{
  VerifyCodeEntity({
    this.isSuccess,
    this.errors,
    this.data
  });

  bool? isSuccess;
  List<Errors>? errors;
  VerifyCodeData? data;

  @override
  List<Object?> get props => [isSuccess , errors, data];
}