import 'package:dartz/dartz.dart';
import '../../../../core/rest/failure.dart';
import '../../../register/domain/entity/resend_code_entity.dart';
import '../repo/resetPassword_repo.dart';

class ResendForgetPasswordCodeUseCase{
  final ResetPasswordRepository resetPasswordRepository;
  ResendForgetPasswordCodeUseCase(this.resetPasswordRepository);
  Future<Either<Failure, ResendCodeEntity>> call(int mobileId,bool isWhatsApp) async {
    return await resetPasswordRepository.resendForgetPasswordSmsCode(mobileId,isWhatsApp);
  }
}