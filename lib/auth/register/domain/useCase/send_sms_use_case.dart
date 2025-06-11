import 'package:dartz/dartz.dart';
import '../../../../core/rest/failure.dart';
import '../entity/send_sms_entity.dart';
import '../repo/register_repo.dart';

class SendSmsUseCase{
  final RegisterRepository registerRepository;
  SendSmsUseCase(this.registerRepository);
  Future<Either<Failure, SendSmsEntity>> call(int mobileId , bool isWhatsApp) async {
    return await registerRepository.sendSmsVerification(mobileId, isWhatsApp);
  }
}