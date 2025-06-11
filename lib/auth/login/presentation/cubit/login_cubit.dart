import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_ip_address/get_ip_address.dart' as ip;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:jwt_decode_full/jwt_decode_full.dart';
import '../../../../core/rest/app_constants.dart';
import '../../../../core/rest/cash_helper.dart';
import '../../../../core/rest/constants.dart';
import '../../../../core/rest/dio_helper.dart';
import '../../../../core/rest/firebase_auth.dart';
import '../../../../core/rest/methods.dart';
import '../../data/model/LoginModel.dart';
import '../../domain/entity/login_entity.dart';
import '../../domain/entity/validate_email_entity.dart';
import '../../domain/useCase/apple_signIn_useCase.dart';
import '../../domain/useCase/google_signIn_use_case.dart';
import '../../domain/useCase/login_use_case.dart';
import '../../domain/useCase/sign_in_with_facebook_use_case.dart';
import '../../domain/useCase/validate_email_use_case.dart';
import 'login_state.dart';
import 'dart:html' as html;

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(
    this.loginUseCase,
    this.googleSignInUseCase,
    this.signInWithFaceBookUseCase,
    this.appleSignInUseCase,
    this.validateEmailUseCase)
    : super(LoginInitial()
  );
  static LoginCubit get(context) => BlocProvider.of(context);
  final LoginUseCase loginUseCase;
  GoogleSignInUseCase googleSignInUseCase;
  SignInWithFaceBookUseCase signInWithFaceBookUseCase;
  AppleSignInUseCase appleSignInUseCase;
  ValidateEmailUseCase validateEmailUseCase;
  LoginEntity? loginEntity;
  bool isLoading = false;
  bool modifyDataFromPassword = false;

/////////////////////////////////////////////////////////////////////////////////////////////// country code with IP
  Dio dio = Dio();
  String? userCountryCode;
  lookupUserCountry() async {
    try{
      emit(GetIPForCountryLoading());
      isLoading = true;
      final ipAddress = ip.IpAddress(type: ip.RequestType.text);
      final ipv4 = await ipAddress.getIpAddress();
      final response = await dio.get('https://api.ipregistry.co/$ipv4?key=tz3om0lor45w6ec6');
      if (response.statusCode == 200) {
        userCountryCode =  response.data['location']['country']['code'];
        isLoading = false;
        emit(GetIPForCountrySuccessful());
        return response.data['location']['country']['calling_code'];
      } else {
        isLoading = false;
        emit(GetIPForCountryError());
      }
    }catch(e){
      isLoading = false;
      emit(GetIPForCountryFailure());
    }
  }

/////////////////////////////////////////////////////////////////////////////////////////////// sign in normal
  Future<void> signInNormal(
      String emailOrPhone, String passwordText, BuildContext context) async {
    try {
      if (emailOrPhone.startsWith('0')) {
        emailOrPhone = emailOrPhone.replaceFirst('0', '');
      }
      isLoading = true;
      emit(GettingDialCode());
      String? dialCode;
      dialCode = CacheHelper.getData(key: Constants.selectedCountryCode.toString());
      if (emailOrPhone.contains('@')) {
        normalLogin(emailOrPhone, passwordText, context);
      } else {
        bool rememberMeChecker =
            CacheHelper.getData(key: Constants.rememberMeChecker.toString()) ??
                false;
        if (rememberMeChecker) {
          // normalLogin(emailOrPhone, passwordText);
          normalLogin('+$dialCode${(emailOrPhone)}', passwordText, context);
        } else {
          normalLogin('+$dialCode${(emailOrPhone)}', passwordText, context);
        }
      }
    } catch (e) {
      isLoading = false;
      errorMessage = e.toString();
      debugPrint(e.toString());
      emit(AdminSignDialCodeError());
    }
  }

/////////////////////////////////////////////////////////////////////////////////////////////// normal login
  String? errorMessage;

  Future<void> normalLogin(
      String emailOrPhone, String password, BuildContext context) async {
    isLoading = true;
    emit(LoginLoading());
    final login = await loginUseCase(emailOrPhone, password);
    login.fold((failure) {
      isLoading = false;
      errorMessage = failure.errorMessage;
      emit(LoginNetworkFailed(failure.errorMessage));
    }, (loginObject) {
      if (loginObject.isSuccess!) {
        loginEntity = loginObject;
        saveTokenInShared(loginObject.data!, context);
        print("token = ${loginEntity?.data?.token}");
        saveEmailAndPasswordInShared(emailOrPhone, password);
        DioHelper.init();
        isLoading = false;
        emit(LoginSuccess(loginObject));
      } else {
        errorMessage = loginObject.errors?.first.message;
        isLoading = false;
        emit(LoginUnSuccess(loginObject.errors!.first.message!));
      }
    });
  }

/////////////////////////////////////////////////////////////////////////////////////////////// save token in shared
  void saveTokenInShared(LoginData loginData, BuildContext context) {
    CacheHelper.saveData(
        key: Constants.token.toString(), value: loginData.token);

    CacheHelper.saveData(
        key: Constants.refreshToken.toString(), value: loginData.refreshToken);
    CacheHelper.saveData(key: Constants.isLogged.toString(), value: true);
    final jwtData = jwtDecode(loginData.token.toString());
    print(jwtData.payload["Id"]);
    CacheHelper.saveData(
        key: Constants.customerID.toString(), value: jwtData.payload["Id"]);
    CacheHelper.saveData(
        key: Constants.countryID.toString(),
        value: jwtData.payload["CountryId"]);
    CacheHelper.saveData(
        key: Constants.dexefCountryId.toString(),
        value: jwtData.payload["DexefCountryId"]);

    CacheHelper.saveData(
        key: Constants.customerCurrency.toString(),
        value: getString(title: jwtData.payload["Currency"], context: context));
    CacheHelper.saveData(
        key: Constants.activeStatus.toString(),
        value: jwtData.payload["StatusId"]);
    CacheHelper.saveData(
        key: Constants.customerEmail.toString(),
        value: jwtData.payload["email"]);
    CacheHelper.saveData(
        key: Constants.customerPhone.toString(),
        value: jwtData.payload["Mobile"]);
    CacheHelper.saveData(
        key: Constants.customerName.toString(), value: jwtData.payload["Name"]);

    String customerName =
        CacheHelper.getData(key: Constants.customerName.toString());

    List<String> customerNameSeperate = customerName.split(" ");
    String customerFirstName = customerNameSeperate[0];
    String customerLastName = customerNameSeperate.length > 1
        ? customerNameSeperate.sublist(1).join(" ")
        : "Dexef Customer";

    CacheHelper.saveData(
        key: Constants.customerFirstName.toString(), value: customerFirstName);
    CacheHelper.saveData(
        key: Constants.customerLastName.toString(), value: customerLastName);
  }

/////////////////////////////////////////////////////////////////////////////////////////////// save email and password in shared
//   void saveEmailAndPasswordInShared(String emailOrPhone, String password) {
//     bool rememberMeChecker = CacheHelper.getData(key: Constants.rememberMeChecker.toString()) ?? false;
//     if (rememberMeChecker) {
//       CacheHelper.saveData(key: Constants.emailOrPhone.toString(), value: emailOrPhone);
//       CacheHelper.saveData(key: Constants.password.toString(), value: password);
//     }
//   }
  void saveEmailAndPasswordInShared(String emailOrPhone, String password) {
    bool rememberMeChecker =
        CacheHelper.getData(key: Constants.rememberMeChecker.toString()) ??
            false;
    print('Remember Me Checker: $rememberMeChecker');
    if (rememberMeChecker) {
      CacheHelper.saveData(
          key: Constants.emailOrPhone.toString(), value: emailOrPhone);
      CacheHelper.saveData(key: Constants.password.toString(), value: password);
      print(
          'Saved Email/Phone: >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>$emailOrPhone');
      print(
          'Saved Password: >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>$password');
    } else {
      print('Remember Me is not checked, data not saved');
    }
  }

/////////////////////////////////////////////////////////////////////////////////////////////// sign in with google android & ios
  UserCredential? credGoogle;
  AuthCredential? credentialGoogle;

  Future<void> signInWithGoogle() async {
    emit(SignInWithGoogleLoading());
    try {
      credentialGoogle = await DefaultSignInGoogle();
      credGoogle = await FirebaseAuth.instance.signInWithCredential(credentialGoogle!);
      debugPrint('Sign in With Google Success');
      emit(SignInWithGoogleSuccess());
    } catch (e) {
      print('error is ${e.toString()}');
      errorMessage = e.toString();
      emit(SignInWithGoogleError());
    }
  }

//////////////////////////////////////////////////// sign in with google web
  UserCredential? credGoogleWeb;
  FirebaseAuth firebaseAuthGoogle = FirebaseAuth.instance;
  String socialLogin = '';

  final GoogleSignIn _googleSignIn = GoogleSignIn();


  void clearCookies() {
    html.document.cookie = "";
    print("Cookies cleared.");
  }
  Future<void> handleSignOut() async {
    try {
      // Disconnect the account to clear session
      await _googleSignIn.disconnect();
      print("User disconnected successfully.");
    } catch (error) {
      print("Error disconnecting: $error");
    }
  }
  signInWithGoogleWeb() async {
    emit(SignInWithGoogleWebLoading());
    try {
      clearCookies();
      handleSignOut();
      GoogleAuthProvider googleProvider = GoogleAuthProvider();
      googleProvider
          .addScope('https://www.googleapis.com/auth/contacts.readonly');

      // googleProvider.setCustomParameters({'login_hint': 'user@example.com'});

      // Set custom parameters to force account selection
      googleProvider.setCustomParameters({
        'prompt': 'select_account', // Ensures user selects or enters a new account
      });
      // credGoogleWeb = await firebaseAuthGoogle.signInWithPopup(googleProvider);
      credGoogleWeb =
          await FirebaseAuth.instance.signInWithPopup(googleProvider);

      // GoogleAuthProvider googleProvider = GoogleAuthProvider();
      // googleProvider
      //     .addScope('https://www.googleapis.com/auth/contacts.readonly');
      // googleProvider.setCustomParameters({'login_hint': 'user@example.com'});
      // credGoogleWeb =
      // await FirebaseAuth.instance.signInWithPopup(googleProvider);
      socialLogin =  AppConstants.googleString;
      print('sssssssss$socialLogin');
      print('sssssssss$googleOrAppleLogin');
      emit(SignInWithGoogleWebSuccess());
    }
    catch (e) {
      errorMessage = e.toString();
      log('${e.hashCode} Error Google web is ${e.toString()}');
      if (e.toString().contains(popupCanceledByUser) ||
          e.toString().contains(beforeFinalizingOperation) ||
          e.toString().contains('popup-closed-by-user') ||
      e.toString().contains('cancelled-popup-request')) {
        debugPrint('Canceled By User');
        errorMessage = '';
        emit(CanceledByUserWebGoogle());
      } else{
        emit(SignInWithGoogleWebError());
      }
    }
  }

  String popupCanceledByUser = 'by the user before finalizing the operation';
  String beforeFinalizingOperation =
      'The popup has been closed by the user before finalizing the operation';

///////////////////////////////////////////////////////////////////////////////////////////////

  signUpWithGoogleWeb() async {
    emit(SignUpGoogleWebLoading());
    try {
      handleSignOut();
      GoogleAuthProvider googleProvider = GoogleAuthProvider();
      googleProvider
          .addScope('https://www.googleapis.com/auth/contacts.readonly');
      // googleProvider.setCustomParameters({'login_hint': 'user@example.com'});
      googleProvider.setCustomParameters({
        'prompt': 'select_account', // Ensures user selects or enters a new account
      });

      // credGoogleWeb = await FirebaseAuth.instance.signInWithPopup(googleProvider);
      debugPrint('Google token ${credGoogleWeb!.credential!.accessToken!}');

      emit(SignUpFirstGoogleWebSuccess());
    } catch (e) {
      print('Error Google web is ${e.toString()}');
      errorMessage = e.toString();
      if (e.toString().contains(popupCanceledByUser) ||
          e.toString().contains(beforeFinalizingOperation)) {
        debugPrint('Canceled By User');
        errorMessage = '';
        emit(CanceledSignUpByUserWebGoogle(e.toString()));
      } else {
        emit(SignUpGoogleWebError(e.toString()));
      }
    }
  }

/////////////////////////////////////////////////////////////////////////////////////////////// login in with google

  loginWithGoogle({required String token, context}) async {
    isLoading = true;
    emit(LoginWithGoogleLoading());
    final result = await googleSignInUseCase(token);
    result.fold((failure) {
      errorMessage = failure.toString();
      emit(LoginWithGoogleFailure(failure.errorMessage));
    }, (signInGoogle) async {
      if (signInGoogle.isSuccess == true) {
        log('Success = true');
        saveSocialData(signInGoogle);
        emit(LoginWithGoogleSuccess(signInGoogle));
      } else {
        log('Success = false');
        log('Success = ${signInGoogle.errors?.first.message}');
        if (signInGoogle.errors!.first.message
                .toString()
                .contains('غير موجود') ||
            signInGoogle.errors!.first.message
                .toString()
                .contains('Not Found') ||
            signInGoogle.errors!.first.message
                .toString()
                .contains('This mobile is not verified') ||
            signInGoogle.errors!.first.message
                .toString()
                .contains('هذا الرقم غير مفعل')) {
          errorMessage = null;
          // await signUpWithGoogleWeb();
        }
        // errorMessage = signInGoogle.errors!.first.message;
        emit(LoginWithGoogleError(signInGoogle));
      }
    });
  }

////////////////////////////////////////////////////////////////////////////////
  UserCredential? appleCredential;
  String? idToken;
  String? appleEmail;

  signUpWithApple() async {
    try {
      emit(SignUpAppleLoading());
      final provider = OAuthProvider("apple.com")
        ..addScope('email')
        ..addScope('name');
      appleCredential = await FirebaseAuth.instance.signInWithPopup(provider);
      idToken = await appleCredential?.user?.getIdToken();
      appleEmail = appleCredential?.user?.email;
      socialLogin = AppConstants.appleString;
      emit(SignUpAppleSuccess());
    } catch (e) {
      debugPrint("error apple =  $e");
      // errorMessage = e.toString();
      emit(SignUpAppleError());
    }
  }

  // signUpWithAppleFirstTime() async {
  //   try{
  //     emit(SignUpAppleLoading());
  //     final provider = OAuthProvider("apple.com")..addScope('email')..addScope('name');
  //     // appleCredential =  await FirebaseAuth.instance.signInWithPopup(provider);
  //     idToken = await appleCredential?.user?.getIdToken();
  //
  //     emit(SignUpAppleFirstSuccess());
  //   }catch(e){
  //     debugPrint("error apple =  $e");
  //     errorMessage = e.toString();
  //     emit(SignUpAppleError());
  //   }
  // }

  appleSignIn({required String token, context}) async {
    emit(AppleSignInLoading());
    final result = await appleSignInUseCase(token);
    result.fold((failure) {
      emit(AppleSignInFailure(failure.errorMessage));
    }, (appleSignIn) async {
      try {
        if (appleSignIn.isSuccess == true) {
          log('Success = true');
          saveSocialData(appleSignIn);
          DioHelper.init();
          emit(AppleSignInSuccess(appleSignIn));
        } else {
          log('Success = false');
          errorMessage = appleSignIn.errors?.first.message;
          if (appleSignIn.errors!.first.message
                  .toString()
                  .contains('غير موجود') ||
              appleSignIn.errors!.first.message
                  .toString()
                  .contains('Not Found') ||
              appleSignIn.errors!.first.message
                  .toString()
                  .contains('This mobile is not verified') ||
              appleSignIn.errors!.first.message
                  .toString()
                  .contains('هذا الرقم غير مفعل')) {
            errorMessage = null;
          }
          emit(AppleSignInError(appleSignIn.errors!.first.message!));
        }
      } catch (e) {
        print('eeeeeeeeeeeeeeeeeeeee${e.toString()}');
      }
    });
  }

////////////////////////////////////////////////////////////////////////////////
  void saveSocialData(entity) {
    CacheHelper.saveData(
        key: Constants.token.toString(), value: entity.data!.token);
    CacheHelper.saveData(
        key: Constants.refreshToken.toString(),
        value: entity.data!.refreshToken);
    CacheHelper.saveData(key: Constants.isLogged.toString(), value: true);
    final jwtData = jwtDecode(entity.data!.token.toString());
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
        key: Constants.customerName.toString(), value: jwtData.payload["Name"]);
    String customerName =
        CacheHelper.getData(key: Constants.customerName.toString());
    CacheHelper.saveData(
        key: Constants.activeStatus.toString(),
        value: jwtData.payload["StatusId"]);

    List<String> customerNameSeperate = customerName.split(" ");
    String customerFirstName = customerNameSeperate[0];
    String customerLastName = customerNameSeperate.length > 1
        ? customerNameSeperate.sublist(1).join(" ")
        : "Dexef Customer";

    CacheHelper.saveData(
        key: Constants.customerFirstName.toString(), value: customerFirstName);
    CacheHelper.saveData(
        key: Constants.customerLastName.toString(), value: customerLastName);
    DioHelper.init();
  }

////////////////////////////////////////////////////////////////////////////////////////////// google sign in data
//   void saveGoogleLoginData(GoogleSignInEntity googleSignInEntity) {
//     CacheHelper.saveData(
//         key: Constants.token.toString(), value: googleSignInEntity.data!.token);
//     CacheHelper.saveData(
//         key: Constants.refreshToken.toString(),
//         value: googleSignInEntity.data!.refreshToken);
//     CacheHelper.saveData(key: Constants.isLogged.toString(), value: true);
//     final jwtData = jwtDecode(googleSignInEntity.data!.token.toString());
//     log(jwtData.payload["Id"]);
//     CacheHelper.saveData(
//         key: Constants.customerID.toString(), value: jwtData.payload["Id"]);
//     CacheHelper.saveData(
//         key: Constants.countryID.toString(),
//         value: jwtData.payload["CountryId"]);
//     CacheHelper.saveData(
//         key: Constants.dexefCountryId.toString(),
//         value: jwtData.payload["DexefCountryId"]);
//     CacheHelper.saveData(
//         key: Constants.customerCurrency.toString(),
//         value: getString(title: jwtData.payload["Currency"],));
//     CacheHelper.saveData(
//         key: Constants.customerEmail.toString(),
//         value: jwtData.payload["email"]);
//     CacheHelper.saveData(
//         key: Constants.customerPhone.toString(),
//         value: jwtData.payload["Mobile"]);
//     CacheHelper.saveData(
//         key: Constants.customerName.toString(),
//         value: jwtData.payload["Name"]);
//     String customerName =CacheHelper.getData(key: Constants.customerName.toString());
//     CacheHelper.saveData(
//         key: Constants.activeStatus.toString(),
//         value: jwtData.payload["StatusId"]);
//
//     List<String> customerNameSeperate = customerName.split(" ");
//     String customerFirstName = customerNameSeperate[0];
//     String customerLastName = customerNameSeperate.length > 1 ? customerNameSeperate.sublist(1).join(" ") : "Dexef Customer";
//
//     CacheHelper.saveData(
//         key: Constants.customerFirstName.toString(),
//         value: customerFirstName);
//     CacheHelper.saveData(
//         key: Constants.customerLastName.toString(),
//         value:customerLastName);
//     DioHelper.init();
//   }

/////////////////////////////////////////////////////////////////////////////////////////////// sign In With Google API
//   Future<void> signInWithGoogleAPI(String token) async {
//     isLoading = true;
//     emit(LoginLoading());
//     final login = await signInWithGoogleUseCase(token);
//     login.fold((failure) {
//       isLoading = false;
//       emit(LoginNetworkFailed());
//     }, (signInWithGoogleEntity) {
//       if (signInWithGoogleEntity.isSuccess!) {
//         saveTokenInShared(signInWithGoogleEntity.data!);
//         DioHelper.init();
//         isLoading = false;
//         debugPrint('Login With Google Api Success');
//         emit(LoginSuccess());
//       } else {
//         isLoading = false;
//         emit(LoginUnSuccess(signInWithGoogleEntity.errors!.first.message!));
//       }
//     });
//   }
////////////////////////////////////////////// login with facebook
//   loginWithFacebook(String token) async {
//     isLoading = true;
//     emit(LoginWithFacebookLoading());
//     final result = await signInWithFaceBookUseCase(token);
//     result.fold((failure) {
//       isLoading = false;
//       debugPrint(failure.errorMessage);
//       emit(LoginWithFacebookFailure(failure.errorMessage));
//     }, (signInFacebook) {
//       if (signInFacebook.isSuccess!) {
//         isLoading = false;
//         saveSocialData(signInFacebook.data!);
//         Fluttertoast.showToast(msg: signInFacebook.data!.token!);
//         Fluttertoast.showToast(msg: signInFacebook.data!.refreshToken!);
//         emit(LogInWithFacebookSuccess());
//       } else {
//         isLoading = false;
//         print('Success = false');
//         print('Error = ${signInFacebook.errors?.first.message}');
//         String notExistAccount = '7002';
//         if (signInFacebook.errors?.first.code == notExistAccount) {
//           emit(LoginWithFacebookError('You Must Sign Up First!'));
//           errorMessage = 'You Must Sign Up First!';
//         } else {
//           errorMessage = signInFacebook.errors?.first.message;
//           emit(LoginWithFacebookError(signInFacebook.errors!.first.message!));
//         }
//       }
//     });
//   }

/////////////////////////////////////////////////////////////////////////////////////////////// facebook sign in data
//   void saveFaceBookLoginDataInShared(SignInFacebookData signInFacebook) {
//     CacheHelper.saveData(
//         key: Constants.token.toString(), value: signInFacebook.token);
//     CacheHelper.saveData(
//         key: Constants.refreshToken.toString(),
//         value: signInFacebook.refreshToken);
//     CacheHelper.saveData(key: Constants.isLogged.toString(), value: true);
//     final jwtData = jwtDecode(signInFacebook.token.toString());
//     print(jwtData.payload["Id"]);
//     CacheHelper.saveData(
//         key: Constants.customerID.toString(), value: jwtData.payload["Id"]);
//     CacheHelper.saveData(
//         key: Constants.countryID.toString(),
//         value: jwtData.payload["CountryId"]);
//     CacheHelper.saveData(
//         key: Constants.dexefCountryId.toString(),
//         value: jwtData.payload["DexefCountryId"]);
//     CacheHelper.saveData(
//         key: Constants.customerCurrency.toString(),
//         value: getString(title: jwtData.payload["Currency"],));
//     CacheHelper.saveData(
//         key: Constants.customerEmail.toString(),
//         value: jwtData.payload["email"]);
//     CacheHelper.saveData(
//         key: Constants.customerPhone.toString(),
//         value: jwtData.payload["Mobile"]);
//     CacheHelper.saveData(
//         key: Constants.customerName.toString(),
//         value: jwtData.payload["Name"]);
//     CacheHelper.saveData(
//         key: Constants.activeStatus.toString(),
//         value: jwtData.payload["StatusId"]);
//     String customerName =CacheHelper.getData(key: Constants.customerName.toString());
//
//     List<String> customerNameSeparated = customerName.split(" ");
//     String customerFirstName = customerNameSeparated[0];
//     String customerLastName = customerNameSeparated.length > 1 ? customerNameSeparated.sublist(1).join(" ") : "Dexef Customer";
//
//     CacheHelper.saveData(
//         key: Constants.customerFirstName.toString(),
//         value: customerFirstName);
//     CacheHelper.saveData(
//         key: Constants.customerLastName.toString(),
//         value:customerLastName);
//     DioHelper.init();
//   }

/////////////////////////////////////////////////////////////////////////////////////////////// sign In With Facebook Web
//   UserCredential? credFace;
//   LoginResult? loginResult;
//
//   Future<UserCredential> signInWithFacebookWeb() async {
//     FacebookAuthProvider facebookProvider = FacebookAuthProvider();
//     facebookProvider.addScope('email');
//     facebookProvider.setCustomParameters({
//       'display': 'popup',
//     });
//     return await FirebaseAuth.instance.signInWithPopup(facebookProvider);
//     // try {
//     //   credFace = await FirebaseAuth.instance.signInWithPopup(facebookProvider);
//     //   emit(SignInWithFacebookSuccess());
//     // } catch (e) {
//     //   print('error is ${e}');
//     //   emit(SignInWithFacebookError());
//     // }
//   }

/////////////////////////////////////////////////////////////////////////////////////////////// sign In With Facebook android & ios
//   Future<void> signInWithFacebook() async {
//     emit(SignInWithFacebookLoading());
//     try {
//       loginResult = await FacebookAuth.instance.login();
//       final OAuthCredential facebookAuthCredential =
//           FacebookAuthProvider.credential(loginResult!.accessToken!.token);
//       credFace = await FirebaseAuth.instance
//           .signInWithCredential(facebookAuthCredential);
//       emit(SignInWithFacebookSuccess());
//     } catch (e) {
//       print('error is ${e}');
//       errorMessage = e.toString();
//       emit(SignInWithFacebookError());
//     }
//   }

/////////////////////////////////////////////////////////////////////////////////////////////// sign out with google
  GoogleSignIn googleSignInNew = GoogleSignIn(
      clientId:
          '585255872109-ltgp15tmg6ptjm08h3vg5o93ss0gukn6.apps.googleusercontent.com');

  Future<void> signOut() async {
    emit(SignOutGoogleLoading());
    try {
      if (kIsWeb) {
        await googleSignInNew.signOut().then((value) {
          FirebaseAuth.instance.signOut();
          emit(SignOutGoogleWebSuccess());
        }).catchError((error) {
          print('wala ${error.toString()}');
          emit(SignOutGoogleWebError());
        });
      } else {
        if (Platform.isIOS) {
          await googleSignInIOS.signOut().then((value) {
            emit(SignOutGoogleSuccess());
          }).catchError((error) {
            emit(SignOutGoogleError());
          });
        } else {
          await googleSignIn.signOut().then((value) {
            emit(SignOutGoogleSuccess());
          }).catchError((error) {
            emit(SignOutGoogleError());
          });
        }
      }
    } catch (e) {
      emit(SignOutGoogleError());
    }
  }

/////////////////////////////////////////////////////////////////////////////////////////////
  ValidateEmailEntity? validateEmailEntity;
  bool googleOrAppleLogin = false;
  bool validateSuccess = false;

  validateEmailNormal(String emailOrPhone) async {
    if (emailOrPhone.startsWith('0')) {
      emailOrPhone = emailOrPhone.replaceFirst('0', '');
    }
    try {
      validateSuccess = true;
      isLoading = true;
      emit(ValidateEmailLoading());
      String? dialCode;
      dialCode = CacheHelper.getData(key: Constants.selectedCountryCode.toString()) ?? await lookupUserCountry();
      if (emailOrPhone.contains('@')) {
        validateEmail(
          userName: emailOrPhone,
        );
      } else {
        bool rememberMeChecker =
            CacheHelper.getData(key: Constants.rememberMeChecker.toString()) ??
                false;
        if (rememberMeChecker) {
          // normalLogin(emailOrPhone, passwordText);
          validateEmail(
            userName: '+$dialCode$emailOrPhone',
          );
        } else {
          debugPrint('aaaacccccccc$dialCode');
          validateEmail(
            userName: '+$dialCode$emailOrPhone',
          );
        }
      }
      // emit(ValidateEmailSuccess());
    } catch (e) {
      isLoading = false;
      validateSuccess = false;
      debugPrint('error :${e.toString()}');
    }
  }

  validateEmail({required String userName}) async {
    googleOrAppleLogin = false;
    isLoading = true;
    emit(ValidateEmailLoading());
    final result = await validateEmailUseCase(userName);
    result.fold((failure) {
      errorMessage = failure.errorMessage;
      isLoading = false;
      emit(ValidateEmailFailure());
    }, (validate) {
      // if (userName.contains('@')) {
      //   validateEmail(userName: userName);
      // } else {
      //   bool rememberMeChecker = CacheHelper.getData(key: Constants.rememberMeChecker.toString()) ?? false;
      //   if (rememberMeChecker) {
      //     // normalLogin(emailOrPhone, passwordText);
      //     validateEmail(userName: '+$dialCode${(userName)}');
      //   } else {
      //     validateEmail(userName: '+$dialCode${(userName)}');
      //   }
      // }
      if (validate.isSuccess == true) {
        validateEmailEntity = validate;
        if (validateEmailEntity?.data?.type == AppConstants.googleString ||
            validateEmailEntity?.data?.type == AppConstants.appleString) {
          googleOrAppleLogin = true;
        } else {
          googleOrAppleLogin = false;
        }
        isLoading = false;
        emit(ValidateEmailSuccess(validateEmailEntity: validate));
      } else {
        isLoading = false;
        validateSuccess = false;
        if (socialLogin == AppConstants.appleString || socialLogin == AppConstants.googleString){
          errorMessage = null;
        } else if (googleOrAppleLogin == false) {
          errorMessage = validate.errors?.first.message;
        }
        emit(ValidateEmailError(validateEmailEntity: validate));
      }
    });
  }
////////////////////////////////////////////////////////////////////////////////
  String emailType = '';
  getEmailType(){
    emailType = validateEmailEntity?.data?.type ?? CacheHelper.getData(key: Constants.emailType.toString())??'';
    return emailType;
  }
  changeErrorMessageState(){
    emit(ChangeMessageErrorState());
  }
////////////////////////////////////////////////////////////////////////////////
  modifyData(){
    validateEmailEntity?.data = null;
    googleOrAppleLogin = false;
    errorMessage = null;
    CacheHelper.saveData(key: Constants.emailType.toString(), value: '');
    emailType = CacheHelper.getData(key: Constants.emailType.toString());
    changeErrorMessageState();
    modifyDataFromPassword = true;
    emit(ModifyDataState());
  }
////////////////////////////////////////////////////////////////////////////////
  List<Country> searchInCountries = [];
  searchCountries(String text) {
    emit(SearchStartingLoading());
    searchInCountries.clear();
    if(text.isNotEmpty){
      searchInCountries.addAll(countries.where((element) => element.name.toLowerCase().contains(text.toLowerCase()) || element.nameTranslations['ar']!.toLowerCase().contains(text.toLowerCase())));
    }
    emit(SearchEndState());
  }
////////////////////////////////////////////////////////////////////////////////
//   List<CountryCustom> countriesCodeList = [];
//   Box? booksBox = Hive.box('countryCode');
//   Future<void> getCountriesCode() async {
//     bool dataSavedBefore = CacheHelper.getData(key: Constants.countryCodeSaved.toString()) ?? false;
//     emit(CountryCodeLoadingState());
//     if (dataSavedBefore == false) {
//       final String response = await rootBundle.loadString('assets/jsonFiles/countries.json');
//       final List<dynamic> data = json.decode(response);
//       for (var item in data) {
//         final countryDetails = CountryCustom.fromJson(item);
//         await booksBox?.add(countryDetails);
//       }
//     }
//     countriesCodeList = booksBox!.values.cast<CountryCustom>().toList();
//     CacheHelper.saveData(key: Constants.countryCodeSaved.toString(), value: true);
//     emit(CountryCodeSuccessState());
//   }
}
