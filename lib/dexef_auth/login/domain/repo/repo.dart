import 'package:dartz/dartz.dart';
import '../../../../core/rest/failure.dart';
import '../entity/google_signIn_entity.dart';
import '../entity/login_entity.dart';
import '../entity/social_entity.dart';
import '../entity/validate_email_entity.dart';

abstract class LoginRepository{
  Future<Either<Failure,LoginEntity>> getLogin(String email , String password);

  Future<Either<Failure,GoogleSignInEntity>> googleSignIn(String token);

  Future<Either<Failure,SocialEntity>> appleSignIn(String token);

  Future<Either<Failure,ValidateEmailEntity>> validateEmail(String userName);
}