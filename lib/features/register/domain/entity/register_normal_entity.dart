import 'package:auth_dexef/core/rest/error_model.dart';
import 'package:equatable/equatable.dart';
import '../../data/model/SignUpModel.dart';

class RegisterNormalEntity extends Equatable{
  RegisterNormalEntity({
    this.isSuccess,
    this.errors,
    this.data
  });

  bool? isSuccess;
  List<Errors>? errors;
  RegisterNormalData? data;

  @override
  List<Object?> get props => [isSuccess , errors, data];
}

