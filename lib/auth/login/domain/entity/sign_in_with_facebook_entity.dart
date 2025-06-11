import 'package:equatable/equatable.dart';
import '../../../../core/rest/error_model.dart';
import '../../data/model/facebook_signIn_model.dart';

class SignInFacebookEntity extends Equatable{
  SignInFacebookEntity({
    this.data,
    this.errors,
    this.isSuccess
  });

  bool? isSuccess;
  List <Errors>? errors;
  SignInFacebookData? data;

  @override
  List<Object?> get props => [isSuccess , errors, data];
}