import 'package:equatable/equatable.dart';
import '../../../../core/rest/error_model.dart';
import '../../data/model/validate_email_model.dart';

class ValidateEmailEntity extends Equatable{
  ValidateEmailEntity({
    this.isSuccess,
    this.errors,
    this.data
  });

  bool? isSuccess;
  List <Errors>? errors;
  ValidateEmailData? data;

  @override
  List<Object?> get props => [isSuccess , errors, data];
}
