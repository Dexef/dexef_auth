import 'package:dartz/dartz.dart';
import '../../../../core/rest/failure.dart';
import '../entity/refresh_token_entity.dart';

abstract class RefreshTokenRepository{
  Future<Either<Failure,RefreshTokenEntity>>getRefreshToken(String token ,String refreshToken);
}