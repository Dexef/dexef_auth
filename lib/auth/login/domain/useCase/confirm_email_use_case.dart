import 'package:dartz/dartz.dart';
import '../../../../core/rest/failure.dart';
import '../entity/confirm_email_entity.dart';
import '../repo/login_repo.dart';

class ConfirmEmailUseCase{
  LoginRepository loginRepository;
  ConfirmEmailUseCase(this.loginRepository);
  Future<Either<Failure, ConfirmEmailEntity>> call(String email) async {
    return await loginRepository.confirmEmail(email);
  }
}