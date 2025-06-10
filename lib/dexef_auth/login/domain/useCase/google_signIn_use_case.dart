import 'package:dartz/dartz.dart';
import '../../../../core/rest/failure.dart';
import '../entity/google_signIn_entity.dart';
import '../repo/repo.dart';

class GoogleSignInUseCase {
  LoginRepository loginRepository;
   GoogleSignInUseCase(this.loginRepository);
  Future<Either<Failure, GoogleSignInEntity>> call(String token) async {
    return await loginRepository.googleSignIn(token);
  }
}
