import 'package:dartz/dartz.dart';
import '../../../../core/rest/failure.dart';
import '../entity/change_mobile_entity.dart';
import '../repo/register_repo.dart';


class ChangePhoneNumberUseCase{
  final RegisterRepository registerRepository;
  ChangePhoneNumberUseCase(this.registerRepository);
  Future<Either<Failure, ChangeMobileEntity>> call(String phoneNumber,String countryCode,int mobileID,bool isWhatsapp) async {
    return await registerRepository.changePhoneNumber(phoneNumber, countryCode, mobileID,isWhatsapp);
  }
}