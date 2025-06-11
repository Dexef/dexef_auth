import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mydexef/features/auth/domain/use_case/verify_forget_pass_use_case.dart';
import 'package:mydexef/features/auth/presentation/cubit/reset_password/reset_password_state.dart';

import '../../../../../utils/cash_helper.dart';
import '../../../../../utils/constants.dart';
import '../../../resetPassword/domain/useCase/resend_forget_pass_code_use_case.dart';

class ResetVerifyCodeCubit extends Cubit<ResetPasswordStates> {
  ResetVerifyCodeCubit(this.verifyForgetPasswordUseCase,this.resendForgetPasswordCodeUseCase)
      : super(ResetPasswordInitialState());

  static ResetVerifyCodeCubit get(context) => BlocProvider.of(context);

  VerifyForgetPasswordUseCase verifyForgetPasswordUseCase;
  ResendForgetPasswordCodeUseCase resendForgetPasswordCodeUseCase;
  String? errorMessage;
  ////////////////////////////////////////////////////////////////////////////////////
  verifyForgetPassword({required String code, int? mobileID}) async {
    emit(LoadingStateVerifyCode());
    final result = await verifyForgetPasswordUseCase(mobileID!, code);
    result.fold((failure) {
      errorMessage = failure.errorMessage;
    emit(VerifyForgetPasswordFailed(failure.errorMessage));
    },
        (verifyForgetPassword) {
      if (verifyForgetPassword.isSuccess!) {
        checkDate();
        emit(VerifyForgetPasswordSuccess());
      } else {
        errorMessage = verifyForgetPassword.errors?.first.message;
        emit(VerifyForgetPasswordError(
            verifyForgetPassword.errors!.first.message!));
      }
    });
  }

//////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////////////////// resend code sms
  resendCodeSms ({required int mobileId}) async {
  emit(LoadingState());
  try{
    final result = await resendForgetPasswordCodeUseCase(mobileId,CacheHelper.getData(key: Constants.isWhatsApp.toString()) ?? true);
    result.fold((failure) => emit(ResendCodeFailed(failure.errorMessage)),
            (resendCode) {
            CacheHelper.saveData(key: Constants.resetExpireDate.toString(), value: resendCode.data?.expiryDate??'');
            CacheHelper.saveData(key: Constants.resetBlockedDate.toString(), value: resendCode.data?.blockTillDate ?? '');
            print(resendCode.isSuccess);
            checkDate();
            emit(ResendCodeSuccess());

        });
  }catch(e){
    print('eeeeeeeeeeeeeeeeeeeeeeeeeee${e.toString()}');
  }

  }
///////////////////////////////////////////////////////////////////////////////////


  Duration? differenceTime = Duration(seconds: 0);
  DateTime now = DateTime.now().toUtc();
  DateTime? parsedDate;

  checkDate() {
    DateTime now = DateTime.now().toUtc();
    final isFirstTimeCheck = CacheHelper.getData(key: 'isFirstTimeCheck') ?? true;

    // Determine which date to parse
    String? storedBlockedDate = CacheHelper.getData(key: Constants.resetBlockedDate.toString());
    String? storedExpireDate = CacheHelper.getData(key: Constants.resetExpireDate.toString());

    if (storedBlockedDate != null && storedBlockedDate != '') {

      if (isFirstTimeCheck) {

        parsedDate = now.add(const Duration(minutes: 2));


        Future.delayed(const Duration(minutes: 2), () {
          parsedDate = DateTime.parse(storedBlockedDate).subtract(const Duration(minutes: 2));
          emit(CheckDifferenceState());
        });


        CacheHelper.saveData(key: 'isFirstTimeCheck', value: false);
      } else {

        parsedDate = DateTime.parse(storedBlockedDate).subtract(const Duration(minutes: 2));
      }
    } else if (storedExpireDate != null) {
      parsedDate = DateTime.parse(storedExpireDate);
    }

    // Calculate the difference only if the current time is before the stored date
    if (parsedDate != null && now.isBefore(parsedDate!)) {
      differenceTime = parsedDate!.difference(now);
    }

    // CacheHelper.removeData(key: Constants.resetBlockedDate.toString());
    // CacheHelper.removeData(key: Constants.resetExpireDate.toString());

    // emit(CheckDifferenceState());
  }

  defaultDate(){
    differenceTime = Duration.zero;
    emit(RemoveDateState());
  }
/////////////////////////////////////////////////////////////////////////////////// verify code for google
//   verifyCodeSmsForGoogleAndFacebook({
//     required int mobileId,
//     required String code,
//     required bool isFromGoogle,
//     required bool isFromFacebook,
//   }) async {
//     emit(LoadingState());
//     final result = await verifyCodeUseCase!(mobileId,code);
//     result.fold((failure) => emit(VerifyCodeError(failure.errorMessage)),
//             (verifyCode) {
//           if(verifyCode.isSuccess == true) {
//             if(isFromGoogle){
//               print('tttt ${CacheHelper.getData(key: Constants.tokenGoogle.toString())}');
//               loginWithGoogle(token: CacheHelper.getData(key: Constants.tokenGoogle.toString()));
//               emit(VerifyCodeSuccessGoogle());
//             }else if (isFromFacebook){
//               loginWithFacebook(token: CacheHelper.getData(key: Constants.facebookToken.toString()));
//               emit(VerifyCodeSuccessFacebook());
//             }
//           }else{
//             print('eeeeee ${verifyCode.errors!.first.message.toString()}');
//             emit(VerifyCodeFailed(verifyCode.errors!.first.message.toString()));
//           }
//         });
//   }

/////////////////////////////////////////////////////////////////////////////////// Login google
//   loginWithGoogle({required String token, context}) async {
//     emit(SignInWithGoogleLoading());
//     final result = await signInWithGoogleUseCase!(token);
//     result.fold(
//             (failure) => emit(SignInWithGoogleStateFailure(failure.errorMessage)),
//             (signInGoogle) {
//           if (signInGoogle.isSuccess == true) {
//             print('Success = true');
//             CacheHelper.saveData(key: Constants.token.toString(), value: signInGoogle.data!.token);
//             CacheHelper.saveData(key: Constants.refreshToken.toString(), value: signInGoogle.data!.refreshToken);
//             final jwtData = jwtDecode(signInGoogle.data!.token.toString());
//             CacheHelper.saveData(key: Constants.customerID.toString(), value: jwtData.payload["Id"]);
//             CacheHelper.saveData(key: Constants.countryID.toString(), value: jwtData.payload["DexefCountryId"]);
//             DioHelper.init();
//             emit(SignInWithGoogleStateSuccess(signInGoogle));
//           } else {
//             print('Success = false');
//             emit(SignInWithGoogleStateError(signInGoogle));
//           }
//         });
//   }

/////////////////////////////////////////////////////////////////////////////////// login facebook
//   loginWithFacebook({required String token, context}) async {
//     emit(LoginWithFacebookLoading());
//     final result = await signInWithFacebookUseCase!(token);
//     result.fold(
//             (failure) => emit(LoginWithFacebookFailure(failure.errorMessage)),
//             (signInFacebook) {
//           if (signInFacebook.isSuccess == true) {
//             print('Success = true');
//             saveFaceBookLoginDataInShared(signInFacebook);
//             emit(LoginWithFacebookSuccess(signInFacebook));
//           } else {
//             print('Success = false');
//             print('Error = ${signInFacebook.errors?.first.message}');
//             emit(LoginWithFacebookError(signInFacebook));
//           }
//         });
//   }

/////////////////////////////////////////////////////////////////////////////////// create new password
//   createNewPassword ({
//     required String code,
//     required int mobileID,
//     required String password})
//   async {
//     emit(LoadingState());
//     final result = await createNewPasswordUseCase!(mobileID,code,password);
//     result.fold((failure) => emit(ResetPasswordError(failure.errorMessage)),
//             (createNewPassword) {
//           print(createNewPassword.isSuccess);
//           if(createNewPassword.isSuccess!){
//
//             emit(CreateNewPasswordSuccess());
//           }
//           else{
//             print(createNewPassword.errors!.first.message);
//             emit(CreateNewPasswordFailed(createNewPassword.errors!.first.message!));
//           }
//         });
//   }

/////////////////////////////////////////////////////////////////////////////////////
//   void saveFaceBookLoginDataInShared(SignInFacebookEntity signInFacebook) {
//     CacheHelper.saveData(key: Constants.token.toString(), value: signInFacebook.data!.token);
//     CacheHelper.saveData(key: Constants.refreshToken.toString(), value: signInFacebook.data!.refreshToken);
//     CacheHelper.saveData(key: Constants.isLogged.toString(), value: true);
//     final jwtData = jwtDecode(signInFacebook.data!.token.toString());
//     print(jwtData.payload["Id"]);
//     CacheHelper.saveData(key: Constants.customerID.toString(), value: jwtData.payload["Id"]);
//     CacheHelper.saveData(key: Constants.countryID.toString(), value: jwtData.payload["DexefCountryId"]);
//     DioHelper.init();
//   }
// ///////////////////////////////////////////////////////////////////////////////////////
//   Dio dio = Dio();
//   Future<String> lookupUserCountry() async {
//     final ipv4 = await Ipify.ipv4();
//     print(ipv4);
//     final response = await dio.get('https://api.ipregistry.co/$ipv4?key=tz3om0lor45w6ec6');
//     print(response.data['location']['country']['calling_code']);
//     if (response.statusCode == 200) {
//       return response.data['location']['country']['calling_code'];
//     } else {
//       throw Exception('Failed to get user country from IP address');
//     }
//   }
}
