import 'package:dartz/dartz.dart';
import '../../../../core/rest/failure.dart';
import '../entity/register_with_facebook_entity.dart';
import '../repo/register_repo.dart';


class RegisterWithFacebookUseCase{
  final RegisterRepository registerRepository;
  RegisterWithFacebookUseCase(this.registerRepository);
  Future<Either<Failure, RegisterFacebookEntity>> call(String token, String email, String mobile, String countryId, int SourceId) async {
    return await registerRepository.registerByFacebook(token, email, mobile, countryId, SourceId);
  }
}