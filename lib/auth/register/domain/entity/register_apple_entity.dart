import 'package:equatable/equatable.dart';
import '../../../../core/rest/error_model.dart';
import '../../data/model/register_apple_model.dart';

class RegisterAppleEntity extends Equatable{
  RegisterAppleEntity({
    this.data,
    this.errors,
    this.isSuccess});
  bool? isSuccess;
  List<Errors>? errors;
  RegisterAppleData? data;

  @override
  List<Object?> get props => [isSuccess , errors, data];
}