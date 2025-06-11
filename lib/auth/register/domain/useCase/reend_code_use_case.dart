import 'package:dartz/dartz.dart';
import '../../../../core/rest/failure.dart';
import '../entity/resend_code_entity.dart';
import '../repo/register_repo.dart';

class ResendCodeUseCase{
  final RegisterRepository registerRepository;
  ResendCodeUseCase(this.registerRepository);
  Future<Either<Failure, ResendCodeEntity>> call(int mobileId,bool isWhatsApp) async {
    return await registerRepository.resendSmsCode(mobileId,isWhatsApp);
  }
}