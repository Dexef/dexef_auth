import 'package:equatable/equatable.dart';
import '../../../../core/rest/error_model.dart';
import '../../data/model/login_apple_model.dart';

// ignore: must_be_immutable
class SocialEntity extends Equatable{

  SocialEntity({
    this.data,
    this.errors,
    this.isSuccess
  });

  bool? isSuccess;
  List <Errors>? errors;
  LoginAppleData? data;

  @override
  List<Object?> get props => [isSuccess , errors, data];
}
