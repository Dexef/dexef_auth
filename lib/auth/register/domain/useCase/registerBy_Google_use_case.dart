import 'package:dartz/dartz.dart';
import '../../../../core/rest/failure.dart';
import '../entity/register_with_google_entity.dart';
import '../repo/register_repo.dart';


class RegisterByGoogleUseCase{
  final RegisterRepository registerRepository;
  RegisterByGoogleUseCase(this.registerRepository);
  Future<Either<Failure, RegisterByGoogleEntity>> call(String token, String email, String mobile, String countryId, int SourceId) async {
   return await registerRepository.registerByGoogle(token, email, mobile, countryId, SourceId);
  }
}