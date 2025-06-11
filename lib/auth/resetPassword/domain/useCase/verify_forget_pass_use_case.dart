import 'package:dartz/dartz.dart';
import '../../../../core/rest/failure.dart';
import '../entity/verify_forget_password_entity.dart';
import '../repo/resetPassword_repo.dart';


class VerifyForgetPasswordUseCase{
  final ResetPasswordRepository resetPasswordRepository;
  VerifyForgetPasswordUseCase(this.resetPasswordRepository);
  Future<Either<Failure, VerifyForgetPasswordEntity>> call(int mobileId, String code) async => await resetPasswordRepository.verifyForgetPassword(mobileId, code);
}