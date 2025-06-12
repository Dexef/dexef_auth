import 'package:auth_dexef/core/rest/error_model.dart';
import 'package:equatable/equatable.dart';
import '../../data/model/ResendCodeModel.dart';

class ResendCodeEntity extends Equatable{
  ResendCodeEntity({
    this.isSuccess,
    this.errors,
    this.data
  });

  bool? isSuccess;
  List<Errors>? errors;
  ResendCodeData? data;

  @override
  List<Object?> get props => [isSuccess , errors, data];
}

