import 'package:dartz/dartz.dart';
import '../../../../core/rest/failure.dart';
import '../entity/sign_in_with_facebook_entity.dart';
import '../repo/login_repo.dart';

class SignInWithFaceBookUseCase {
  LoginRepository loginRepository;

  SignInWithFaceBookUseCase(this.loginRepository);

  Future<Either<Failure, SignInFacebookEntity>> call(String token) async {
    return await loginRepository.signInWithFaceBook(token);
  }
}
