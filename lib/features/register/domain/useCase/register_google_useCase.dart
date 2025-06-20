import 'package:dartz/dartz.dart';
import '../../../../core/rest/failure.dart';
import '../entity/register_google_entity.dart';
import '../repo/register_repo.dart';


class RegisterByGoogleUseCase{
  final RegisterRepository registerRepository;
  RegisterByGoogleUseCase(this.registerRepository);
  Future<Either<Failure, RegisterGoogleEntity>> call(String token, String email, String mobile, String countryId, int sourceId) async {
   return await registerRepository.registerByGoogle(token, email, mobile, countryId, sourceId);
  }
}