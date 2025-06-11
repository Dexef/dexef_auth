// import 'package:dart_ipify/dart_ipify.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:jwt_decode_full/jwt_decode_full.dart';
// import '../../../../../rest/dio_helper.dart';
// import '../../../../../utils/cash_helper.dart';
// import '../../../../../utils/constants.dart';
// import '../../../domain/use_case/create_new_password_use_case.dart';
// import '../../../domain/use_case/resend_forget_pass_code_use_case.dart';
// import '../../../domain/use_case/reset_password_use_case.dart';
// import '../../../domain/use_case/google_signIn_use_case.dart';
// import '../../../domain/use_case/verify_code_use_case.dart';
// import '../../../domain/use_case/verify_forget_pass_use_case.dart';
// import 'reset_password_states.dart';
//
//
// class ResetPasswordCubit extends Cubit<ResetPasswordStates>{
//
//   ResetPasswordCubit(this.resetPasswordUseCase,this.verifyForgetPasswordUseCase,this.verifyCodeUseCase,
//       this.resendForgetPasswordCodeUseCase,this.createNewPasswordUseCase, this.signInWithGoogleUseCase,) : super(ResetPasswordInitialState());
//
//   static ResetPasswordCubit get(context) => BlocProvider.of(context);
//
//   ResetPasswordUseCase? resetPasswordUseCase;
//   VerifyForgetPasswordUseCase? verifyForgetPasswordUseCase;
//   VerifyCodeUseCase? verifyCodeUseCase;
//   ResendForgetPasswordCodeUseCase? resendForgetPasswordCodeUseCase;
//   CreateNewPasswordUseCase? createNewPasswordUseCase;
//   SignInWithGoogleUseCase? signInWithGoogleUseCase;
//   // SignInWithFacebookUseCase? signInWithFacebookUseCase;
// ///////////////////////////////////////////////////////////////////////////////////// reset password
//   String? dialCode;
//   resetPassword ({required String emailOrPhone}) async {
//     emit(LoadingState());
//     dialCode = await lookupUserCountry();
//     final result = await resetPasswordUseCase!(emailOrPhone);
//     result.fold((failure) => emit(ResetPasswordError(failure.errorMessage)),
//             (resetPassword) {
//           print(resetPassword.isSuccess);
//           if(resetPassword.isSuccess!){
//             print(resetPassword.data!.mobileId!);
//             emit(ResetPasswordSuccess(resetPassword.data!.mobileId!));
//           }
//           else{
//             emit(ResetPasswordFailed(resetPassword.errors!.first.message!));
//           }
//
//         });
//   }
// //////////////////////////////////////////////////////////////////////////////////// verify forget password
//   Future<void> resetPasswordEmailOrPhone(String emailOrPhone) async {
//     print(emailOrPhone);
//     if (emailOrPhone.contains('@')){
//       resetPassword (emailOrPhone: emailOrPhone);
//     }
//     else if(emailOrPhone.contains("+")){
//       resetPassword (emailOrPhone: emailOrPhone);
//     }
//     else{
//       String? dialCode;
//       dialCode = await lookupUserCountry();
//       String? emailOrPhone1 = emailOrPhone.startsWith('0') ? emailOrPhone.replaceFirst('0', '') : emailOrPhone;
//       resetPassword (emailOrPhone: '+$dialCode$emailOrPhone1');
//       print('$dialCode$emailOrPhone1');
//     }
//   }
// ////////////////////////////////////////////////////////////////////////////////////
//   verifyForgetPassword ({required String code,required int mobileID}) async {
//     emit(LoadingStateVerifyCode());
//     final result = await verifyForgetPasswordUseCase!(mobileID,code);
//     result.fold((failure) => emit(ResetPasswordError(failure.errorMessage)),
//             (verifyForgetPassword) {
//           print(verifyForgetPassword.isSuccess);
//           if(verifyForgetPassword.isSuccess!){
//
//             emit(VerifyForgetPasswordSuccess());
//           }
//           else{
//
//             emit(VerifyForgetPasswordFailed(verifyForgetPassword.errors!.first.message!));
//           }
//
//         });
//   }
// /////////////////////////////////////////////////////////////////////////////////// resend code sms
//   resendCodeSms ({required int mobileId}) async {
//     emit(LoadingState());
//     final result = await resendForgetPasswordCodeUseCase!(mobileId);
//     result.fold((failure) => emit(ResendCodeFailed(failure.errorMessage)),
//             (resendCode) {
//           print(resendCode.isSuccess);
//           emit(ResendCodeSuccess());
//         });
//   }
// /////////////////////////////////////////////////////////////////////////////////// verify code for google
//     verifyCodeSmsForGoogleAndFacebook({
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
//               // loginWithFacebook(token: CacheHelper.getData(key: Constants.facebookToken.toString()));
//               emit(VerifyCodeSuccessFacebook());
//             }
//           }else{
//             print('eeeeee ${verifyCode.errors!.first.message.toString()}');
//             emit(VerifyCodeFailed(verifyCode.errors!.first.message.toString()));
//           }
//         });
//   }
// /////////////////////////////////////////////////////////////////////////////////// Login google
//   loginWithGoogle({required String token, context}) async {
//   emit(SignInWithGoogleLoading());
//   final result = await signInWithGoogleUseCase!(token);
//   result.fold(
//           (failure) => emit(SignInWithGoogleStateFailure(failure.errorMessage)),
//           (signInGoogle) {
//         if (signInGoogle.isSuccess == true) {
//           print('Success = true');
//           CacheHelper.saveData(key: Constants.token.toString(), value: signInGoogle.data!.token);
//           CacheHelper.saveData(key: Constants.refreshToken.toString(), value: signInGoogle.data!.refreshToken);
//           final jwtData = jwtDecode(signInGoogle.data!.token.toString());
//           CacheHelper.saveData(key: Constants.customerID.toString(), value: jwtData.payload["Id"]);
//           CacheHelper.saveData(key: Constants.countryID.toString(), value: jwtData.payload["DexefCountryId"]);
//           DioHelper.init();
//           emit(SignInWithGoogleStateSuccess(signInGoogle));
//         } else {
//           print('Success = false');
//           emit(SignInWithGoogleStateError(signInGoogle));
//         }
//       });
// }
// /////////////////////////////////////////////////////////////////////////////////// login facebook
// //   loginWithFacebook({required String token, context}) async {
// //   emit(LoginWithFacebookLoading());
// //   final result = await signInWithFacebookUseCase!(token);
// //   result.fold(
// //           (failure) => emit(LoginWithFacebookFailure(failure.errorMessage)),
// //           (signInFacebook) {
// //         if (signInFacebook.isSuccess == true) {
// //           print('Success = true');
// //           saveFaceBookLoginDataInShared(signInFacebook);
// //           emit(LoginWithFacebookSuccess(signInFacebook));
// //         } else {
// //           print('Success = false');
// //           print('Error = ${signInFacebook.errors?.first.message}');
// //           emit(LoginWithFacebookError(signInFacebook));
// //         }
// //       });
// // }
// /////////////////////////////////////////////////////////////////////////////////// create new password
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
// /////////////////////////////////////////////////////////////////////////////////////
// //   void saveFaceBookLoginDataInShared(SignInFacebookEntity signInFacebook) {
// //     CacheHelper.saveData(key: Constants.token.toString(), value: signInFacebook.data!.token);
// //     CacheHelper.saveData(key: Constants.refreshToken.toString(), value: signInFacebook.data!.refreshToken);
// //     CacheHelper.saveData(key: Constants.isLogged.toString(), value: true);
// //     final jwtData = jwtDecode(signInFacebook.data!.token.toString());
// //     print(jwtData.payload["Id"]);
// //     CacheHelper.saveData(key: Constants.customerID.toString(), value: jwtData.payload["Id"]);
// //     CacheHelper.saveData(key: Constants.countryID.toString(), value: jwtData.payload["DexefCountryId"]);
// //     DioHelper.init();
// //   }
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
//
// }
//
//
