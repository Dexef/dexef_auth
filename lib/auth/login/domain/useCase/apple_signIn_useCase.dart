import 'package:dartz/dartz.dart';
import '../../../../core/rest/failure.dart';
import '../entity/social_entity.dart';
import '../repo/login_repo.dart';

class AppleSignInUseCase {
  LoginRepository loginRepository;
  AppleSignInUseCase(this.loginRepository);
  Future<Either<Failure, SocialEntity>> call(String token) async {
    return await loginRepository.appleSignIn(token);
  }
}
