import 'package:dartz/dartz.dart';
import '../../../../core/rest/failure.dart';
import '../entity/create_new_password_entity.dart';
import '../repo/resetPassword_repo.dart';

class CreateNewPasswordUseCase {
  final ResetPasswordRepository resetPasswordRepository;
  CreateNewPasswordUseCase(this.resetPasswordRepository);
  Future<Either<Failure, CreateNewPasswordEntity>> call(int mobileId, String code, String password) async {
    return await resetPasswordRepository.createNewPassword(mobileId, code, password);
  }
}