import 'package:auth_dexef/core/rest/error_model.dart';
import 'package:auth_dexef/features/register/presentation/cubit/sign_up_states.dart';
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
import '../../domain/entity/register_normal_entity.dart';
import '../../domain/useCase/reend_code_use_case.dart';
import '../../domain/useCase/register_normal_useCase.dart';
import '../../../login/domain/useCase/validate_email_use_case.dart';
import '../../../../core/rest/sign_up_errors_values.dart';
import 'package:get_ip_address/get_ip_address.dart' as ip;
import 'dart:html' as html;

class RegisterCubit extends Cubit<RegisterStates> {
  RegisterCubit(
    this.registerNormalUseCase,
    this.validateEmailUseCase,
    this.resendCodeUseCase
  ):super(RegisterInitialState());

  static RegisterCubit get(context) => BlocProvider.of(context);
  static final RegisterCubit _registerCubit = BlocProvider.of<RegisterCubit>(navigatorKey.currentState!.context);
  static RegisterCubit get instance => _registerCubit;
////////////////////////////////////////////////////////////////////////////////

  final ResendCodeUseCase resendCodeUseCase;
  final ValidateEmailUseCase validateEmailUseCase;
/////////////////////////////////////////////////////////////////////////////////////////////// register normal
///////////////////////////////////////////////////////////////////////////////////////////////
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
////////////////////////////////////////////////////////////////////////////////
  bool hasPhoneError(List<Errors> errors){
    final uniqueErrors = <String>{}; // A set to store unique error messages
    return errors.any((error) {
      // If the message is not already in the set, add it
      if (uniqueErrors.add(error.message!)) {
        // Check if the error message matches the ones you want to handle
        return error.message == SignUpErrorConstants.mobileFoundAr ||
            error.message == SignUpErrorConstants.mobileFoundEn;
      }
      return false;
    });
  }

  bool hasEmailError(List<Errors> errors) {
    return errors.any((error) =>
        error.message == SignUpErrorConstants.emailFoundAr ||
        error.message == SignUpErrorConstants.emailFoundEn ||
        error.message == SignUpErrorConstants.emailBelongedAr ||
        error.message == SignUpErrorConstants.emailBelongedEn);
  }

  ////////////////////  sign Up with google android & IOS
  dynamic credGoogle;
  AuthCredential? credentialGoogle;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  void clearCookies() {
    html.document.cookie = "";
    print("Cookies cleared.");
  }

  Future<void> handleSignOut() async {
    try {
      await _googleSignIn.disconnect();
    } catch (error) {
      print("Error disconnecting: $error");
    }
  }

  signUpWithGoogle(context) async {
    emit(SignUpGoogleLoading());
    try {
      handleSignOut();
      credentialGoogle = await DefaultSignInGoogle();
      credGoogle = await FirebaseAuth.instance.signInWithCredential(credentialGoogle!);
      socialLogin = 'Google';
      debugPrint('google token ' + credentialGoogle!.accessToken!);
      emit(SignUpGoogleSuccess());
    } catch (e) {
      errorMessage = e.toString();
      print('error is ${e.toString()}');
      emit(SignUpGoogleError(e.toString()));
    }
  }

  ////////////////////////// Sign Up with google web
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
      credGoogleWeb =
          await FirebaseAuth.instance.signInWithPopup(googleProvider);
      debugPrint('Google token ${credGoogleWeb!.credential!.accessToken!}');
      socialLogin = 'Google';
      emit(SignUpGoogleWebSuccess());
    } catch (e) {
      print('Error Google web is ${e.toString()}');
      errorMessage = e.toString();
      if (e.toString().contains(popupCanceledByUser) ||
          e.toString().contains(beforeFinalizingOperation) ||
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

  String popupCanceledByUser =
      'This operation has been cancelled due to another conflicting popup being opened';
  String beforeFinalizingOperation =
      'The popup has been closed by the user before finalizing the operation';

  /////////////// sign out from google
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
  /////////////////  sign up with facebook android & IOS
  // dynamic credFace;
  // LoginResult? loginResult;
  // signUpWithFacebook() async {
  //   emit(SignUpFaceBookLoading());
  //   try {
  //     loginResult = await FacebookAuth.instance.login();
  //     final OAuthCredential facebookAuthCredential =
  //         FacebookAuthProvider.credential(loginResult!.accessToken!.token);
  //     credFace = FirebaseAuth.instance
  //         .signInWithCredential(facebookAuthCredential)
  //         .then((value) {
  //       log('token ${loginResult?.accessToken?.token}');
  //       emit(SignUpFaceBookSuccess());
  //     }).catchError((error) {
  //       log('error is $error');
  //       emit(SignUpFaceBookError());
  //     });
  //   } catch (e) {
  //     errorMessage = e.toString();
  //     log('error is $e');
  //     emit(SignUpFaceBookError());
  //   }
  // }
  ////////////////////////////////////// sign up with facebook web
  // UserCredential? credFaceWeb;
  // Future<UserCredential> signUpWithFacebookWeb() async {
  //   await FirebaseAuth.instance.signOut();
  //   // Sign out from Firebase
  //   AccessToken? accessToken = await FacebookAuth.instance.accessToken;
  //
  //   if (accessToken != null) {
  //     // Log out from Facebook if already logged in
  //     await FacebookAuth.instance.logOut();
  //   }
  //
  //   FacebookAuthProvider facebookProvider = FacebookAuthProvider();
  //   facebookProvider.addScope('email');
  //   facebookProvider.setCustomParameters({
  //     'display': 'popup',
  //   });
  //
  //   return await FirebaseAuth.instance.signInWithPopup(facebookProvider);
  // }

  // signUpWithFacebookWeb() async {
  //   emit(SignUpFaceBookWebLoading());
  //   try {
  //     FacebookAuthProvider? facebookProvider = FacebookAuthProvider();
  //     facebookProvider.addScope('email');
  //     facebookProvider.setCustomParameters({
  //       'display': 'popup',
  //     });
  //     credFaceWeb = await FirebaseAuth.instance
  //         .signInWithPopup(facebookProvider)
  //         .then((value) async {
  //         //  debugPrint('token is ' + credFaceWeb!.credential!.accessToken!.toString());
  //          // printObject(credFaceWeb!);
  //      emit(SignUpFaceBookWebSuccess());
  //       Fluttertoast.showToast(msg: "alaa = success");
  //     }).catchError((error) {
  //       Fluttertoast.showToast(msg: "error1 = $error");
  //       debugPrint('error1 ' + error );
  //       emit(SignUpFaceBookWebError(message: error.toString()));
  //     });
  //   } catch (e) {
  //     log('error facebook $e');
  //   //  debugPrint('hassan token is ' + credFaceWeb!.credential!.accessToken!.toString());
  //     debugPrint('error2 ' + e.toString() );
  //     Fluttertoast.showToast(msg: "error2 = $e");
  //     emit(SignUpFaceBookWebError(message: e.toString()));
  //   }
  // }

  // Future<UserCredential> signUpWithFacebookWeb() async {
  //   FacebookAuthProvider facebookProvider = FacebookAuthProvider();
  //   facebookProvider.addScope('email');
  //   facebookProvider.setCustomParameters({
  //     'display': 'popup',
  //   });
  //   return await FirebaseAuth.instance.signInWithPopup(facebookProvider);
  // }
  //////////////////////////////

  bool isPasswordVisible = true;

  changePasswordVisibility(bool isVisible) {
    isPasswordVisible = !isVisible;
    emit(ChangePasswordVisible());
  }

  bool isConfirmPasswordVisible = true;

  changeConfirmPasswordVisibility(bool isVisible) {
    isConfirmPasswordVisible = !isVisible;
    emit(ChangePasswordVisible());
  }

  ///////////////////
  UserCredential? appleCredential;
  String? idToken;
  String? appleEmail;
  String socialLogin = '';

  signUpWithApple() async {
    try {
      emit(SignUpAppleLoading());
      final provider = OAuthProvider("apple.com")
        ..addScope('email')
        ..addScope('name');
      appleCredential = await FirebaseAuth.instance.signInWithPopup(provider);
      debugPrint("token ${appleCredential?.credential?.accessToken}");
      appleEmail = appleCredential?.user?.email;
      idToken = await appleCredential?.user?.getIdToken();
      socialLogin = 'apple';
      debugPrint("token $idToken");
      emit(SignUpAppleSuccess());
    } catch (e) {
      errorMessage = e.toString();
      debugPrint("error apple =  $e");
      if (e.toString().contains(popupCanceledByUser) ||
          e.toString().contains(beforeFinalizingOperation) ||
          e.toString().contains('popup-closed-by-user') ||
          e.toString().contains('cancelled-popup-request')) {
        debugPrint('Canceled By User');
        errorMessage = '';
      }
      emit(SignUpAppleError());
    }
  }

  ///////////////////////////////////


  validateEmailNormal(String emailOrPhone) async {
    if (emailOrPhone.startsWith('0')) {
      emailOrPhone = emailOrPhone.replaceFirst('0', '');
    }
    try {
      emit(ValidateEmailLoading());
      String? dialCode;
      dialCode = await lookupUserCountry();
      if (emailOrPhone.contains('@')) {
        validateEmail(
          userName: emailOrPhone,
        );
      } else {
        bool rememberMeChecker = CacheHelper.getData(key: Constants.rememberMeChecker.toString()) ?? false;
        if (rememberMeChecker) {
          // normalLogin(emailOrPhone, passwordText);
          validateEmail(
            userName: '+$dialCode$emailOrPhone',
          );
        } else {
          validateEmail(
            userName: '+$dialCode$emailOrPhone',
          );
        }
      }
      // emit(ValidateEmailSuccess());
    } catch (e) {
      debugPrint('error :${e.toString()}');
    }
  }

  ValidateEmailEntity? validateEmailEntity;

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

  Dio dio = Dio();

  String? userCountryCode;
  Future<String> lookupUserCountry() async {
    final ipAddress = ip.IpAddress(type: ip.RequestType.text);
    final ipv4 = await ipAddress.getIpAddress();
    final response =
        await dio.get('https://api.ipregistry.co/$ipv4?key=tz3om0lor45w6ec6');
    if (response.statusCode == 200) {
      userCountryCode =  response.data['location']['country']['code'];
      print('user code=========$userCountryCode ${response.data['location']['country']['calling_code']}');
      emit(LookUpUserSuccess());

      return response.data['location']['country']['calling_code'];

    } else {
      throw Exception('Failed to get user country from IP address');
    }

  }

  void saveSignUpDataInShared(RegisterNormalEntity signup) {
    CacheHelper.saveData(
        key: Constants.resetExpireDate.toString(),
        value: signup.data?.expiryDate ?? '');
    CacheHelper.saveData(
        key: Constants.resetBlockedDate.toString(),
        value: signup.data?.blockTillDate ?? '');
  }
////////////////////////////////////////////////////////////////////////////////
  resendCodeSms ({required int mobileId}) async {
    emit(LoadingState());
    final result = await resendCodeUseCase!(mobileId,CacheHelper.getData(key: Constants.isWhatsApp.toString()) ?? true);
    result.fold((failure) => emit(ResendCodeFailure(failure.errorMessage)),
    (resendCode) {
      if(resendCode.isSuccess == true){
        emit(ResendCodeSuccess(resendCode));
      }else{
        emit(ResendCodeError(resendCode.errors?.first.message));
      }
    });
  }
////////////////////////////////////////////////////////////////////////////////
}
