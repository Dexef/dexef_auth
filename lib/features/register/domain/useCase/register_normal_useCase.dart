import 'package:dartz/dartz.dart';
import '../../../../core/rest/failure.dart';
import '../entity/register_normal_entity.dart';
import '../repo/register_repo.dart';

class RegisterNormalUseCase{
  final RegisterRepository registerRepository;
  RegisterNormalUseCase(this.registerRepository);
  Future<Either<Failure, RegisterNormalEntity>> call(String email,String name,String phoneNumber,String password,String countryCode,String companyName) async {
    return await registerRepository.registerNormal(email, name, phoneNumber, password, countryCode,companyName);
  }
}