import 'package:equatable/equatable.dart';
import '../../../../core/rest/error_model.dart';
import '../../data/model/google_signIn_model.dart';

// ignore: must_be_immutable
class GoogleSignInEntity extends Equatable{
  GoogleSignInEntity({
    this.data,
    this.errors,
    this.isSuccess
  });

  bool? isSuccess;
  List <Errors>? errors;
  GoogleSignInData? data;

  @override
  List<Object?> get props => [isSuccess , errors, data];
}
