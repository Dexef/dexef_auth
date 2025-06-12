import 'package:dartz/dartz.dart';
import '../../../../core/rest/failure.dart';
import '../entity/register_normal_entity.dart';
import '../entity/change_mobile_entity.dart';
import '../entity/register_apple_entity.dart';
import '../entity/register_google_entity.dart';
import '../entity/resend_code_entity.dart';
import '../entity/send_sms_entity.dart';
import '../entity/verify_code_entity.dart';

abstract class RegisterRepository{

  Future<Either<Failure , RegisterGoogleEntity>> registerByGoogle (String token, String email, String mobile, String countryId, int sourceId);

  Future<Either<Failure , RegisterAppleEntity>> registerByApple (String token, String email, String mobile, String countryId, int sourceId);

  Future<Either<Failure , ChangeMobileEntity>> changePhoneNumber(String phoneNumber,String countryCode,int mobileID,bool isWhatsapp);

  Future<Either<Failure , ResendCodeEntity>> resendSmsCode(int mobileId,bool isWhatsApp);

  Future<Either<Failure, SendSmsEntity>> sendSmsVerification(int mobileId , bool isWhatsApp);

  Future<Either<Failure , RegisterNormalEntity>> registerNormal(String email,String name,String phoneNumber,String password,String countryCode,String companyName);

  Future<Either<Failure , VerifyCodeEntity>> verifySmsCode(int mobileId, String code);

}