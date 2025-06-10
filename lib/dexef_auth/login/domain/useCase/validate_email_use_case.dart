import 'package:dartz/dartz.dart';
import '../../../../core/rest/failure.dart';
import '../entity/validate_email_entity.dart';
import '../repo/repo.dart';

class ValidateEmailUseCase{
  final LoginRepository loginRepository;
  ValidateEmailUseCase(this.loginRepository);
  Future<Either<Failure,ValidateEmailEntity>> call(String userName) async {
    return await loginRepository.validateEmail(userName);
  }
}