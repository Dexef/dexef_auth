import 'package:equatable/equatable.dart';
import '../../../../core/rest/error_model.dart';
import '../../data/model/login_google_model.dart';

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
