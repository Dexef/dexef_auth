import 'package:auth_dexef/core/rest/error_model.dart';
import 'package:equatable/equatable.dart';

import '../../data/model/SendSmsModel.dart';

class SendSmsEntity extends Equatable{
  SendSmsEntity({
    this.isSuccess,
    this.errors,
    this.data
  });

  bool? isSuccess;
  List<Errors>? errors;
  SendSmsData? data;

  @override
  List<Object?> get props => [isSuccess , errors, data];
}
