import 'package:dartz/dartz.dart';

import '../../../../core/rest/failure.dart';
import '../entity/login_normal_entity.dart';
import '../repo/login_repo.dart';

class LoginUseCase {
  final LoginRepository loginRepository;
  LoginUseCase(this.loginRepository);
  Future<Either<Failure, LoginEntity>> call(String email, String password) async {
    return await loginRepository.loginNormal(email, password);
  }
}
