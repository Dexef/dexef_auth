import 'package:auth_dexef/core/rest/app_constants.dart';
import 'package:auth_dexef/core/rest/error_model.dart';
import 'package:auth_dexef/features/login/presentation/cubit/login_cubit.dart';
import 'package:auth_dexef/features/register/presentation/cubit/register_states.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../../core/rest/app_localizations.dart';
import '../../../../core/rest/cash_helper.dart';
import '../../../../core/rest/constants.dart';
import '../../../../core/rest/firebase_auth.dart';
import '../../../../main.dart';
import '../../../login/domain/entity/validate_email_entity.dart';
import '../../domain/entity/register_apple_entity.dart';
import '../../domain/entity/register_google_entity.dart';
import '../../domain/entity/register_normal_entity.dart';
import '../../domain/useCase/change_phone_number.dart';
import '../../domain/useCase/register_apple_useCase.dart';
import '../../domain/useCase/resend_code_use_case.dart';
import '../../domain/useCase/register_google_useCase.dart';
import '../../domain/useCase/register_normal_useCase.dart';
import '../../../login/domain/useCase/validate_email_use_case.dart';
import '../../../../core/rest/sign_up_errors_values.dart';
import 'package:get_ip_address/get_ip_address.dart' as ip;
import 'dart:html' as html;

import '../../domain/useCase/send_sms_use_case.dart';
import '../../domain/useCase/verify_code_use_case.dart';

class RegisterCubit extends Cubit<RegisterStates> {
  RegisterCubit(
    this.registerNormalUseCase,
    this.validateEmailUseCase,
    this.resendCodeUseCase,
    this.registerByGoogleUseCase,
    this.sendSmsUseCase,
    this.verifyCodeUseCase,
    this.changePhoneNumberUseCase,
    this.registerAppleUseCase
  ):super(RegisterInitialState());

  static RegisterCubit get(context) => BlocProvider.of(context);
  static final RegisterCubit _registerCubit = BlocProvider.of<RegisterCubit>(navigatorKey.currentState!.context);
  static RegisterCubit get instance => _registerCubit;
/////////////////////////////////////////////////////////////////////////////////////////////// register normal
////////////////////////////////////////////////////////////////////////////////
  String? errorMessage;
  RegisterNormalEntity? registerNormalEntity;
  final RegisterNormalUseCase registerNormalUseCase;
  registerNormal({
    required String email,
    required String name,
    required String phoneNumber,
    required String password,
    required String countryCode
  })async {
    emit(RegisterNormalLoading());
    final result = await registerNormalUseCase(email, name, phoneNumber, password, countryCode, "default");
    result.fold((failure) {
      errorMessage = failure.errorMessage;
      emit(RegisterNormalFailure(failure.errorMessage));
    },(registerNormal) {
      if (registerNormal.isSuccess == true) {
        registerNormalEntity = registerNormal;
        if (registerNormal.data!.status == 4) {
          saveSignUpDataInShared(registerNormal);
          emit(RegisterNormalSuccess(registerNormal.data!.mobileId!.toInt()));
        } else {
          emit(RegisterNormalError(AppLocalizations.of(currentContext)!.translate('an_error')));
        }
      }else{
        errorMessage = registerNormal.errors!.map((e) => e.message).join(', ');
        emit(RegisterNormalError(registerNormal.errors!.first.message!));
      }
    });
  }
//////////////////////////////////////////////////////////////////////////////// phone error
  bool hasPhoneError(String? errorMessage){
    if(errorMessage != null){
      if(errorMessage.contains(SignUpErrorConstants.mobileFoundAr)
          || errorMessage.contains(SignUpErrorConstants.mobileFoundEn
      )){
        return true;
      }
    }
    return false;
  }
//////////////////////////////////////////////////////////////////////////////// email error
  bool hasEmailError(String? errorMessage) {
    if(errorMessage != null){
      if(
        errorMessage.contains(SignUpErrorConstants.emailFoundAr)
        || errorMessage.contains(SignUpErrorConstants.emailFoundEn)
        || errorMessage.contains(SignUpErrorConstants.emailBelongedAr)
        || errorMessage.contains(SignUpErrorConstants.emailBelongedEn)
      ){
        return true;
      }
    }
    return false;
  }
/////////////////////////////////////////////////////////////////////////////////////////////// register google
//////////////////////////////////////////////////////////////////////////////// register google mobile firebase
  UserCredential? credGoogle;
  AuthCredential? credentialGoogle;
  signUpWithGoogle(context) async {
    emit(SignUpGoogleLoading());
    try {
      handleSignOut();
      credentialGoogle = await DefaultSignInGoogle();
      credGoogle = await FirebaseAuth.instance.signInWithCredential(credentialGoogle!);
      debugPrint('google token ${credentialGoogle!.accessToken!}');
      emit(SignUpGoogleSuccess());
    } catch (e) {
      errorMessage = e.toString();
      debugPrint('error is ${e.toString()}');
      emit(SignUpGoogleError(e.toString()));
    }
  }
//////////////////////////////////////////////////////////////////////////////// sign out
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  void clearCookies() {
    html.document.cookie = "";
    debugPrint("Cookies cleared.");
  }

  Future<void> handleSignOut() async {
    try {
      await _googleSignIn.disconnect();
    } catch (error) {
      debugPrint("Error disconnecting: $error");
    }
  }

  Future<void> signOut() async {
    emit(SignOutGoogleLoading());
    try {
      googleSignIn.signOut().then((value) {
        emit(SignOutGoogleSuccess());
      }).catchError((error) {
        emit(SignOutGoogleError());
      });
    } catch (e) {
      emit(SignOutGoogleError());
    }
  }
//////////////////////////////////////////////////////////////////////////////// register google web firebase
  UserCredential? credGoogleWeb;
  signUpWithGoogleWeb() async {
    emit(SignUpGoogleWebLoading());
    try {
      clearCookies();
      await handleSignOut();
      GoogleAuthProvider googleProvider = GoogleAuthProvider();
      googleProvider
          .addScope('https://www.googleapis.com/auth/contacts.readonly');
      googleProvider.setCustomParameters({
        'prompt': 'select_account',
        // Ensures user selects or enters a new account
      });
      credGoogleWeb = await FirebaseAuth.instance.signInWithPopup(googleProvider);
      debugPrint('Google token ${credGoogleWeb!.credential!.accessToken!}');
      emit(SignUpGoogleWebSuccess());
    } catch (e) {
      debugPrint('Error Google web is ${e.toString()}');
      errorMessage = e.toString();
      if (e.toString().contains(AppConstants.registerPopupCanceledByUser) ||
          e.toString().contains(AppConstants.registerBeforeFinalizingOperation) ||
          e.toString().contains('popup-closed-by-user') ||
          e.toString().contains('cancelled-popup-request')) {
        debugPrint('Canceled By User');
        errorMessage = '';
        emit(CanceledSignUpByUserWebGoogle(''));
      } else {
        emit(SignUpGoogleWebError(e.toString()));
      }
    }
  }
//////////////////////////////////////////////////////////////////////////////// register google
  final RegisterByGoogleUseCase registerByGoogleUseCase;
  RegisterGoogleEntity? registerGoogleEntity;
  registerGoogle({
    required String token,
    required String email,
    required String mobile,
    required String countryId,
    required int sourceId,
  })async{
    emit(RegisterGoogleLoading());
    final result = await registerByGoogleUseCase(token, email, mobile, countryId, sourceId);
    result.fold((failure) {
      errorMessage = failure.errorMessage;
      emit(RegisterGoogleFailure(failure.errorMessage));
    },(registerGoogle) {
      if (registerGoogle.isSuccess == true) {
        registerGoogleEntity = registerGoogle;
        emit(RegisterGoogleSuccess(registerGoogle));
      }else{
        errorMessage = registerGoogle.errors!.first.message;
        emit(RegisterGoogleError(registerGoogle.errors!.first.message));
      }
    });
  }
/////////////////////////////////////////////////////////////////////////////////////////////// register apple web firebase
///////////////////////////////////////////////////////////////////////////////////////////////
  UserCredential? appleCredential;
  String? idToken;
  signUpWithApple() async {
    try {
      emit(SignUpAppleLoading());
      final provider = OAuthProvider("apple.com")
        ..addScope('email')
        ..addScope('name');
      appleCredential = await FirebaseAuth.instance.signInWithPopup(provider);
      debugPrint("token ${appleCredential?.credential?.accessToken}");
      idToken = await appleCredential?.user?.getIdToken();
      debugPrint("token $idToken");
      emit(SignUpAppleSuccess());
    } catch (e) {
      errorMessage = e.toString();
      debugPrint("error apple =  $e");
      if (e.toString().contains(AppConstants.registerPopupCanceledByUser) ||
          e.toString().contains(AppConstants.registerBeforeFinalizingOperation) ||
          e.toString().contains('popup-closed-by-user') ||
          e.toString().contains('cancelled-popup-request')) {
        debugPrint('Canceled By User');
        errorMessage = '';
      }
      emit(SignUpAppleError());
    }
  }
////////////////////////////////////////////////////////////////////////////////
  final RegisterAppleUseCase registerAppleUseCase;
  RegisterAppleEntity? registerAppleEntity;
  registerApple({
    required String token,
    required String email,
    required String mobile,
    required String countryId,
    required int sourceId,
  })async{
    emit(RegisterAppleLoading());
    final result = await registerAppleUseCase(token, email, mobile, countryId, sourceId);
    result.fold((failure) {
      errorMessage = failure.errorMessage;
      emit(RegisterAppleFailure(failure.errorMessage));
    },(registerApple) {
      if (registerApple.isSuccess == true) {
        registerAppleEntity = registerApple;
        emit(RegisterAppleSuccess(registerApple));
      }else{
        errorMessage = registerApple.errors!.first.message;
        emit(RegisterAppleError(registerApple.errors!.first.message));
      }
    });
  }
/////////////////////////////////////////////////////////////////////////////////////////////// validate email
//////////////////////////////////////////////////////////////////////////////// select phone or email
  validateEmailNormal(String emailOrPhone) async {
    if (emailOrPhone.startsWith('0')) {
      emailOrPhone = emailOrPhone.replaceFirst('0', '');
    }
    try {
      emit(ValidateEmailLoading());
      String? dialCode;
      dialCode = await LoginCubit.instance.lookupUserCountry();
      if (emailOrPhone.contains('@')) {
        validateEmail(userName: emailOrPhone,);
      } else {
        bool rememberMeChecker = CacheHelper.getData(key: Constants.rememberMeChecker.toString()) ?? false;
        if (rememberMeChecker) {
          validateEmail(userName: '+$dialCode$emailOrPhone',);
        } else {
          validateEmail(userName: '+$dialCode$emailOrPhone',);
        }
      }
    } catch (e) {
      debugPrint('error :${e.toString()}');
    }
  }
//////////////////////////////////////////////////////////////////////////////// validate email
  ValidateEmailEntity? validateEmailEntity;
  final ValidateEmailUseCase validateEmailUseCase;
  validateEmail({required String userName}) async {
    emit(ValidateEmailLoading());
    final result = await validateEmailUseCase(userName);
    result.fold((failure) {
      errorMessage = failure.errorMessage;
      emit(ValidateEmailFailure());
    }, (validate) {
      if (validate.isSuccess == true) {
        validateEmailEntity = validate;
        emit(ValidateEmailSuccess(validateEmailEntity: validate));
      } else {
        emit(ValidateEmailError());
      }
    });
  }
/////////////////////////////////////////////////////////////////////////////////////////////// resend code
////////////////////////////////////////////////////////////////////////////////
  final ResendCodeUseCase resendCodeUseCase;
  resendCodeSms ({required int mobileId}) async {
    emit(ResendCodeLoading());
    final result = await resendCodeUseCase(mobileId,CacheHelper.getData(key: Constants.isWhatsApp.toString()) ?? true);
    result.fold((failure) => emit(ResendCodeFailure(failure.errorMessage)),
        (resendCode) {
      if(resendCode.isSuccess == true){
        emit(ResendCodeSuccess(resendCode));
      }else{
        emit(ResendCodeError(resendCode.errors?.first.message));
      }
    });
  }
/////////////////////////////////////////////////////////////////////////////////////////////// public methods
//////////////////////////////////////////////////////////////////////////////// change password
  bool isPasswordVisible = true;
  bool isConfirmPasswordVisible = true;
  changePasswordVisibility(bool isVisible) {
    isPasswordVisible = !isVisible;
    emit(ChangePasswordVisible());
  }
  changeConfirmPasswordVisibility(bool isVisible) {
    isConfirmPasswordVisible = !isVisible;
    emit(ChangePasswordVisible());
  }
//////////////////////////////////////////////////////////////////////////////// save data in shared
  void saveSignUpDataInShared(RegisterNormalEntity signup) {
    CacheHelper.saveData(key: Constants.resetExpireDate.toString(), value: signup.data?.expiryDate ?? '');
    CacheHelper.saveData(key: Constants.resetBlockedDate.toString(), value: signup.data?.blockTillDate ?? '');
  }
/////////////////////////////////////////////////////////////////////////////////////////////// send code
////////////////////////////////////////////////////////////////////////////////
  final SendSmsUseCase sendSmsUseCase;
  sendCodeSms ({required int mobileId}) async {
    emit(SendCodeLoading());
    final result = await sendSmsUseCase(mobileId, CacheHelper.getData(key: Constants.isWhatsApp.toString()) ?? true);
    result.fold((failure) => emit(SendCodeFailure(failure.errorMessage)),
        (sendCode) {
      if(sendCode.isSuccess == true){
        emit(SendCodeSuccess(sendCode));
      }else{
        emit(SendCodeError(sendCode.errors?.first.message));
      }
    });
  }
/////////////////////////////////////////////////////////////////////////////////////////////// verify mobile
////////////////////////////////////////////////////////////////////////////////
  final VerifyCodeUseCase verifyCodeUseCase;
  verifyMobile ({required int mobileId, required String code}) async {
    emit(VerifyMobileLoading());
    final result = await verifyCodeUseCase(mobileId, code);
    result.fold((failure) => emit(VerifyMobileFailure(failure.errorMessage)),
        (verifyMobile) {
      if(verifyMobile.isSuccess == true){
        emit(VerifyMobileSuccess(verifyMobile));
      }else{
        emit(VerifyMobileError(verifyMobile.errors?.first.message));
      }
    });
  }
/////////////////////////////////////////////////////////////////////////////////////////////// change mobile
////////////////////////////////////////////////////////////////////////////////
  final ChangePhoneNumberUseCase changePhoneNumberUseCase;
  changeMobile ({required String phoneNumber,required String countryCode, required int mobileID, required bool isWhatsapp}) async {
    emit(ChangeMobileLoading());
    final result = await changePhoneNumberUseCase(phoneNumber, countryCode, mobileID, isWhatsapp);
    result.fold((failure) => emit(ChangeMobileFailure(failure.errorMessage)),
        (changeMobile) {
      if(changeMobile.isSuccess == true){
        emit(ChangeMobileSuccess(changeMobile));
      }else{
        emit(ChangeMobileError(changeMobile.errors?.first.message));
      }
    });
  }
}
