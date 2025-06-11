import 'package:auth_dexef/core/rest/error_model.dart';
import 'package:equatable/equatable.dart';
import '../../data/model/registerBy_Google_Model.dart';

class RegisterByGoogleEntity extends Equatable{
  RegisterByGoogleEntity({
   this.data,
   this.errors,
   this.isSuccess});
  bool? isSuccess;
  List<Errors>? errors;
  RegisterByGoogleData? data;

  @override
  List<Object?> get props => [isSuccess , errors, data];
}



