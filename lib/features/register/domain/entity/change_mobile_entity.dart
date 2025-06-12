import 'package:auth_dexef/core/rest/error_model.dart';
import 'package:equatable/equatable.dart';

import '../../data/model/ChangeMobileModel.dart';

class ChangeMobileEntity extends Equatable{
  ChangeMobileEntity({
    this.isSuccess,
    this.errors,
    this.data
  });

  bool? isSuccess;
  List<Errors>? errors;
  ChangeMobileData? data;

  @override
  List<Object?> get props => [isSuccess , errors, data];
}