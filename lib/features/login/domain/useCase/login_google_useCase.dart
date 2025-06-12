import 'package:dartz/dartz.dart';
import '../../../../core/rest/failure.dart';
import '../entity/login_google_entity.dart';
import '../repo/login_repo.dart';

class GoogleSignInUseCase {
  LoginRepository loginRepository;
  GoogleSignInUseCase(this.loginRepository);
  Future<Either<Failure, GoogleSignInEntity>> call(String token) async {
    return await loginRepository.googleSignIn(token);
  }
}
