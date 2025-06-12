import 'package:dartz/dartz.dart';
import '../../../../core/rest/failure.dart';
import '../entity/login_google_entity.dart';
import '../entity/login_normal_entity.dart';
import '../entity/login_apple_entity.dart';
import '../entity/validate_email_entity.dart';

abstract class LoginRepository{

  Future<Either<Failure,ValidateEmailEntity>> validateEmail(String userName);

  Future<Either<Failure,LoginEntity>> loginNormal(String email , String password);

  Future<Either<Failure,GoogleSignInEntity>> googleSignIn(String token);

  Future<Either<Failure,SocialEntity>> appleSignIn(String token);

}