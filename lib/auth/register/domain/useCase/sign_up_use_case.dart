import 'package:dartz/dartz.dart';
import '../../../../core/rest/failure.dart';
import '../entity/SignUpEntity.dart';
import '../repo/register_repo.dart';

class SignUpUseCase{
  final RegisterRepository registerRepository;
  SignUpUseCase(this.registerRepository);
  Future<Either<Failure, SignUpEntity>> call(String email,String name,String phoneNumber,String password,String countryCode,String companyName) async {
    return await registerRepository.signUp(email, name, phoneNumber, password, countryCode,companyName);
  }
}