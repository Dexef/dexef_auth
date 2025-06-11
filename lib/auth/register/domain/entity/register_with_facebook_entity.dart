import 'package:equatable/equatable.dart';
import '../../data/model/registerBy_facebook_model.dart';

class RegisterFacebookEntity extends Equatable{
  RegisterFacebookEntity({
    this.data,
    this.errors,
    this.isSuccess});
  bool? isSuccess;
  List<RegisterFacebookErrors>? errors;
  RegisterFacebookData? data;

  @override
  List<Object?> get props => [isSuccess , errors, data];
}