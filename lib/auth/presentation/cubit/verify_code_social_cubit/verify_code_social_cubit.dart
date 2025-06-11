import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jwt_decode_full/jwt_decode_full.dart';
import 'package:mydexef/features/auth/presentation/cubit/verify_code_social_cubit/verify_code_social_states.dart';
import '../../../../../rest/dio_helper.dart';
import '../../../../../utils/cash_helper.dart';
import '../../../../../utils/constants.dart';
import '../../../login/data/model/facebook_signIn_model.dart';
import '../../../login/domain/entity/google_signIn_entity.dart';
import '../../../login/domain/useCase/apple_signIn_useCase.dart';
import '../../../register/domain/useCase/reend_code_use_case.dart';
import '../../../resetPassword/domain/useCase/resend_forget_pass_code_use_case.dart';
import '../../../login/domain/useCase/sign_in_with_facebook_use_case.dart';
import '../../../login/domain/useCase/google_signIn_use_case.dart';
import '../../../domain/use_case/verify_code_use_case.dart';

class VerifyCodeSocialCubit extends Cubit<VerifyCodeSocialStates>{
  VerifyCodeUseCase verifyCodeUseCase;
  GoogleSignInUseCase googleSignInUseCase;
  SignInWithFaceBookUseCase signInWithFaceBookUseCase;
  ResendCodeUseCase resendForgetPasswordCodeUseCase;
  AppleSignInUseCase appleSignInUseCase;

  VerifyCodeSocialCubit(
    this.verifyCodeUseCase,
    this.googleSignInUseCase,
    this.signInWithFaceBookUseCase,
    this.resendForgetPasswordCodeUseCase,
    this.appleSignInUseCase
  ): super(InitialVerifyCodeSocialState());
  static VerifyCodeSocialCubit get(context) => BlocProvider.of(context);

  String? errorMessage;
////////////////////////////////////////////////////////////////////////////////
    verifyCodeSmsSocial({
    required int mobileId,
    required String code,
    required bool isFromGoogle,
    required bool isFromApple,
  }) async {
    emit(VerifyCodeGoogleFaceLoading());
    final result = await verifyCodeUseCase(mobileId,code);
    result.fold((failure) {
      errorMessage = failure.errorMessage;
      emit(VerifyCodeGoogleFaceFailure(failure.errorMessage));
      }, (verifyCode) {
          if(verifyCode.isSuccess == true) {
            if(isFromGoogle){
              loginWithGoogle(token: CacheHelper.getData(key: Constants.tokenGoogle.toString()));
              emit(VerifyCodeGoogleSuccess(verifyCode));
            }else if (isFromApple){
              appleSignIn(token: CacheHelper.getData(key: Constants.appleToken.toString()));
              emit(VerifyCodeFaceSuccess(verifyCode));
            }
          }else{
            errorMessage = verifyCode.errors?.first.message;
            emit(VerifyCodeGoogleFaceError(verifyCode));
          }
        });
  }

////////////////////////////////////////////////////////////////////////////////
  loginWithGoogle({required String token, context}) async {
  emit(SignInWithGoogleStartLoading());
  final result = await googleSignInUseCase(token);
  result.fold(
     (failure) {
       errorMessage = failure.errorMessage;
       emit(SignInWithGoogleFailure(failure.errorMessage));
     },
       (signInGoogle) {
        if (signInGoogle.isSuccess == true) {
          log('Success = true');
          saveGoogleLoginData(signInGoogle);
          DioHelper.init();
          emit(SignInWithGoogleSuccess(signInGoogle));
        } else {
          log('Success = false');
          errorMessage = signInGoogle.errors?.first.message;
          emit(SignInWithGoogleError(signInGoogle));
        }
      });
}
/////////////////////////////////////////////////////////////////////////////////// login facebook
  loginWithFacebook({required String token, context}) async {
  emit(SignInWithFaceLoading());
  final result = await signInWithFaceBookUseCase(token);
  result.fold(
    (failure) {
      errorMessage = failure.errorMessage;
      emit(SignInWithFaceFailure(failure.errorMessage));
    },
      (signInFacebook) {
        if(signInFacebook.isSuccess == true) {
          log('Success = true');
          saveFaceBookLoginDataInShared(signInFacebook.data!);
          DioHelper.init();
          emit(SignInWithFaceSuccess(signInFacebook));
        } else {
          errorMessage = signInFacebook.errors?.first.message;
          log('Success = false');
          log('Error = ${signInFacebook.errors?.first.message}');
          emit(SignInWithFaceError(signInFacebook));
        }
      });
  }
/////////////////////////////////////////////////////////////////////////////////// login apple
  appleSignIn({required String token, context}) async {
    emit(AppleSignInLoading());
    final result = await appleSignInUseCase(token);
    result.fold((failure) {
          emit(AppleSignInFailure(failure.errorMessage));
        },(appleSignIn) {
          if (appleSignIn.isSuccess == true) {
            log('Success = true');
            saveSocialData(appleSignIn);
            DioHelper.init();
            emit(AppleSignInSuccess(appleSignIn));
          } else {
            log('Success = false');
            emit(AppleSignInError(appleSignIn.errors!.first.message!));
          }
        });
  }
///////////////////////////////////////////////////////////////////////////////////

  void saveFaceBookLoginDataInShared(SignInFacebookData signInFacebook) {
    CacheHelper.saveData(key: Constants.token.toString(), value: signInFacebook.token);
    CacheHelper.saveData(key: Constants.refreshToken.toString(), value: signInFacebook.refreshToken);
    CacheHelper.saveData(key: Constants.isLogged.toString(), value: true);
    final jwtData = jwtDecode(signInFacebook.token.toString());
    print(jwtData.payload["Id"]);
    CacheHelper.saveData(key: Constants.customerID.toString(), value: jwtData.payload["Id"]);
    CacheHelper.saveData(
        key: Constants.countryID.toString(),
        value: jwtData.payload["CountryId"]);
    CacheHelper.saveData(
        key: Constants.dexefCountryId.toString(),
        value: jwtData.payload["DexefCountryId"]);
    CacheHelper.saveData(
        key: Constants.customerEmail.toString(),
        value: jwtData.payload["email"]);
    CacheHelper.saveData(
        key: Constants.customerPhone.toString(),
        value: jwtData.payload["Mobile"]);
    CacheHelper.saveData(
        key: Constants.customerName.toString(),
        value: jwtData.payload["Name"]);
    CacheHelper.saveData(
        key: Constants.activeStatus.toString(),
        value: jwtData.payload["StatusId"]);
    String customerName =CacheHelper.getData(key: Constants.customerName.toString());

    List<String> customerNameSeparated = customerName.split(" ");
    String customerFirstName = customerNameSeparated[0];
    String customerLastName = customerNameSeparated.length > 1 ? customerNameSeparated.sublist(1).join(" ") : "Dexef Customer";

    CacheHelper.saveData(
        key: Constants.customerFirstName.toString(),
        value: customerFirstName);
    CacheHelper.saveData(
        key: Constants.customerLastName.toString(),
        value:customerLastName);
    DioHelper.init();
  }

///////////////////////////////////////////////////////////////////////////////////

  void saveGoogleLoginData(GoogleSignInEntity googleSignInEntity) {
    CacheHelper.saveData(
        key: Constants.token.toString(), value: googleSignInEntity.data!.token);
    CacheHelper.saveData(
        key: Constants.refreshToken.toString(),
        value: googleSignInEntity.data!.refreshToken);
    CacheHelper.saveData(key: Constants.isLogged.toString(), value: true);
    final jwtData = jwtDecode(googleSignInEntity.data!.token.toString());
    log(jwtData.payload["Id"]);
    CacheHelper.saveData(
        key: Constants.customerID.toString(), value: jwtData.payload["Id"]);
    CacheHelper.saveData(
        key: Constants.countryID.toString(),
        value: jwtData.payload["CountryId"]);
    CacheHelper.saveData(
        key: Constants.dexefCountryId.toString(),
        value: jwtData.payload["DexefCountryId"]);
    CacheHelper.saveData(
        key: Constants.customerEmail.toString(),
        value: jwtData.payload["email"]);
    CacheHelper.saveData(
        key: Constants.customerPhone.toString(),
        value: jwtData.payload["Mobile"]);
    CacheHelper.saveData(
        key: Constants.customerName.toString(),
        value: jwtData.payload["Name"]);
    String customerName =CacheHelper.getData(key: Constants.customerName.toString());
    CacheHelper.saveData(
        key: Constants.activeStatus.toString(),
        value: jwtData.payload["StatusId"]);

    List<String> customerNameSeperate = customerName.split(" ");
    String customerFirstName = customerNameSeperate[0];
    String customerLastName = customerNameSeperate.length > 1 ? customerNameSeperate.sublist(1).join(" ") : "Dexef Customer";

    CacheHelper.saveData(
        key: Constants.customerFirstName.toString(),
        value: customerFirstName);
    CacheHelper.saveData(
        key: Constants.customerLastName.toString(),
        value:customerLastName);
    DioHelper.init();
  }
///////////////////////////////////////////////////////////////////////////////////

  void saveSocialData(entity) {
    CacheHelper.saveData(key: Constants.token.toString(), value: entity.data!.token);
    CacheHelper.saveData(key: Constants.refreshToken.toString(), value: entity.data!.refreshToken);
    CacheHelper.saveData(key: Constants.isLogged.toString(), value: true);
    final jwtData = jwtDecode(entity.data!.token.toString());
    log(jwtData.payload["Id"]);
    CacheHelper.saveData(key: Constants.customerID.toString(), value: jwtData.payload["Id"]);
    CacheHelper.saveData(key: Constants.countryID.toString(), value: jwtData.payload["CountryId"]);
    CacheHelper.saveData(key: Constants.dexefCountryId.toString(), value: jwtData.payload["DexefCountryId"]);
    CacheHelper.saveData(key: Constants.customerEmail.toString(), value: jwtData.payload["email"]);
    CacheHelper.saveData(key: Constants.customerPhone.toString(), value: jwtData.payload["Mobile"]);
    CacheHelper.saveData(key: Constants.customerName.toString(), value: jwtData.payload["Name"]);
    String customerName =CacheHelper.getData(key: Constants.customerName.toString());
    CacheHelper.saveData(key: Constants.activeStatus.toString(), value: jwtData.payload["StatusId"]);

    List<String> customerNameSeperate = customerName.split(" ");
    String customerFirstName = customerNameSeperate[0];
    String customerLastName = customerNameSeperate.length > 1 ? customerNameSeperate.sublist(1).join(" ") : "Dexef Customer";

    CacheHelper.saveData(key: Constants.customerFirstName.toString(), value: customerFirstName);
    CacheHelper.saveData(key: Constants.customerLastName.toString(), value:customerLastName);
    DioHelper.init();
  }
///////////////////////////////////////////////////////////////////////////////////

  resendCodeSms({required int mobileId}) async {
    emit(ResendLoadingState());
      final result = await resendForgetPasswordCodeUseCase(mobileId,CacheHelper.getData(key: Constants.isWhatsApp.toString()) ?? true);
      result.fold(
              (failure) => emit(ResendCodeFailed(failure.errorMessage)),
              (resendCode) {
                if(resendCode.isSuccess == true){
                  emit(ResendCodeSuccess());
                }else{
                  try{
                  errorMessage = resendCode.errors?.first.message;
                  emit(ResendCodeError(resendCode.errors?.first.message));
                  }catch(e){
                    print('eeeeeeeeeeee$e');
                  }
                }
          });
  }
}




//     verifyCodeSmsForGoogleAndFacebook({
//     required int mobileId,
//     required String code,
//     required bool isFromGoogle,
//     required bool isFromFacebook,
//   }) async {
//     emit(VerifyCodeGoogleFaceLoading());
//     final result = await verifyCodeUseCase(mobileId,code);
//     result.fold((failure) {
//       errorMessage = failure.errorMessage;
//       emit(VerifyCodeGoogleFaceFailure(failure.errorMessage));
//       }, (verifyCode) {
//           if(verifyCode.isSuccess == true) {
//             if(isFromGoogle){
//               loginWithGoogle(token: CacheHelper.getData(key: Constants.tokenGoogle.toString()));
//               emit(VerifyCodeGoogleSuccess(verifyCode));
//             }else if (isFromFacebook){
//               loginWithFacebook(token: CacheHelper.getData(key: Constants.facebookToken.toString()));
//               emit(VerifyCodeFaceSuccess(verifyCode));
//             }
//           }else{
//             errorMessage = verifyCode.errors?.first.message;
//             emit(VerifyCodeGoogleFaceError(verifyCode));
//           }
//         });
//   }