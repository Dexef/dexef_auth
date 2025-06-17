import 'package:dartz/dartz.dart';
import '../../../../core/rest/failure.dart';
import '../entity/refresh_token_entity.dart';
import '../repository/refresh_token_repository.dart';

class RefreshTokenUseCase{
  final RefreshTokenRepository repository;
  RefreshTokenUseCase({required this.repository});

  Future<Either<Failure,RefreshTokenEntity>> call(String token , String refreshToken,)async{
    return await repository.getRefreshToken(token ,refreshToken );
  }
}
