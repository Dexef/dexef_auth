import 'package:dartz/dartz.dart';
import '../../../../core/rest/failure.dart';
import '../entity/verify_code_entity.dart';
import '../repo/register_repo.dart';

class VerifyCodeUseCase{
  final RegisterRepository registerRepository;
  VerifyCodeUseCase(this.registerRepository);
  Future<Either<Failure, VerifyCodeEntity>> call(int mobileId, String code) async {
    return await registerRepository.verifySmsCode(mobileId, code);
  }
}