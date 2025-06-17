import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import '../../../../core/rest/failure.dart';
import '../../domain/entity/refresh_token_entity.dart';
import '../../domain/repository/refresh_token_repository.dart';
import '../data_source/refresh_token_data_source.dart';

class RefreshTokenRepositoryImpl implements RefreshTokenRepository {
  final RefreshTokenDataSource refreshTokenDataSource;
  RefreshTokenRepositoryImpl({required this.refreshTokenDataSource,});
  @override
  Future<Either<Failure, RefreshTokenEntity>> getRefreshToken(String token, String refreshToken) async {
    try {
      return Right(await refreshTokenDataSource.getRefreshToken(token: token, refreshToken: refreshToken));
    } catch (e) {
      debugPrint(e.toString());
      return Left(Failure(e.toString()));
    }
  }
}
