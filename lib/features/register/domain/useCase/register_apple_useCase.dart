import 'package:dartz/dartz.dart';
import '../../../../core/rest/failure.dart';
import '../entity/register_apple_entity.dart';
import '../repo/register_repo.dart';


class RegisterAppleUseCase{
  final RegisterRepository registerRepository;
  RegisterAppleUseCase(this.registerRepository);
  Future<Either<Failure, RegisterAppleEntity>> call(String token, String email, String mobile, String countryId, int sourceId) async {
    return await registerRepository.registerByApple(token, email, mobile, countryId, sourceId);
  }
}