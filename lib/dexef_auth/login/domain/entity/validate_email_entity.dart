import 'package:equatable/equatable.dart';
import '../../../../core/rest/error_model.dart';
import '../../data/model/ValidateEmailModel.dart';

// ignore: must_be_immutable
class ValidateEmailEntity extends Equatable{
  ValidateEmailEntity({
    this.data,
    this.errors,
    this.isSuccess
  });

  bool? isSuccess;
  List <Errors>? errors;
  ValidateEmailData? data;

  @override
  List<Object?> get props => [isSuccess , errors, data];
}
