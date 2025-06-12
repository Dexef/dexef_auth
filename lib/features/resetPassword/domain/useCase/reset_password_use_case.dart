import 'package:dartz/dartz.dart';
import '../../../../core/rest/failure.dart';
import '../entity/reset_password_entity.dart';
import '../repo/resetPassword_repo.dart';

class ResetPasswordUseCase {
  final ResetPasswordRepository resetPasswordRepository;
  ResetPasswordUseCase(this.resetPasswordRepository);
  Future<Either<Failure, ResetPasswordEntity>> call(
    String emailOrPhone,bool isWhatsapp
  ) async {
    return await resetPasswordRepository.resetPassword(emailOrPhone,isWhatsapp);
  }
}
