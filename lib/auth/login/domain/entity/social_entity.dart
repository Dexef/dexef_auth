import 'package:equatable/equatable.dart';
import '../../../../core/rest/error_model.dart';
import '../../data/model/social_model.dart';

// ignore: must_be_immutable
class SocialEntity extends Equatable{

  SocialEntity({
    this.data,
    this.errors,
    this.isSuccess
  });

  bool? isSuccess;
  List <Errors>? errors;
  SocialData? data;

  @override
  List<Object?> get props => [isSuccess , errors, data];
}
