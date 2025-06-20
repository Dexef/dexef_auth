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
import '../../../../main.dart';
import '../../domain/entity/login_normal_entity.dart';
import '../../domain/entity/validate_email_entity.dart';
import '../../domain/useCase/login_apple_useCase.dart';
import '../../domain/useCase/login_google_useCase.dart';
import '../../domain/useCase/login_normal_useCase.dart';
import '../../domain/useCase/validate_email_use_case.dart';
import 'login_state.dart';
import 'dart:html' as html;

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(
    this.loginUseCase,
    this.googleSignInUseCase,
    this.appleSignInUseCase,
    this.validateEmailUseCase)
    : super(LoginInitial()
  );
  static LoginCubit get(context) => BlocProvider.of(context);
  static final LoginCubit _loginCubit = BlocProvider.of<LoginCubit>(navigatorKey.currentState!.context);
  static LoginCubit get instance => _loginCubit;
////////////////////////////////////////////////////////////////////////////////
  final LoginUseCase loginUseCase;
  final GoogleSignInUseCase googleSignInUseCase;
  final AppleSignInUseCase appleSignInUseCase;
  final ValidateEmailUseCase validateEmailUseCase;
  String? errorMessage;
  bool isLoading = false;
  bool writePassword = false;
/////////////////////////////////////////////////////////////////////////////////////////////// validate email
///////////////////////////////////////////////////////////////////////////////////////////////
  String? loginType;
  ValidateEmailEntity? validateEmailEntity;
  validateEmail({required String userName}) async {
    isLoading = true;
    emit(ValidateEmailLoading());
    final result = await validateEmailUseCase(userName);
    result.fold((failure) {
      errorMessage = failure.errorMessage;
      isLoading = false;
      emit(ValidateEmailFailure(failure.errorMessage));
    },(validate) {
      if (validate.isSuccess == true) {
        loginType = null;
        validateEmailEntity = validate;
        if(validateEmailEntity?.data?.type != null && validateEmailEntity?.data?.type != ""){
          loginType = validateEmailEntity?.data?.type;
          CacheHelper.saveData(key: Constants.emailType.toString(), value: loginType);
        }
        isLoading = false;
        emit(ValidateEmailSuccess(validateEmailEntity: validate));
      }else{
        isLoading = false;
        errorMessage = validate.errors?.first.message;
        emit(ValidateEmailError(validate.errors?.first.message));
      }
    });
  }
////////////////////////////////////////////////////////////////////////////////
  validateEmailNormal(String emailOrPhone) async {
    if (emailOrPhone.startsWith('0')) {
      emailOrPhone = emailOrPhone.replaceFirst('0', '');
    }
    try {
      isLoading = false;
      emit(ValidateEmailLoading());
      String? dialCode;
      dialCode = CacheHelper.getData(key: Constants.selectedCountryCode.toString()) ?? await lookupUserCountry();
      if (emailOrPhone.contains('@')) {
        validateEmail(userName: emailOrPhone);
      } else {
        bool rememberMeChecker = CacheHelper.getData(key: Constants.rememberMeChecker.toString()) ?? false;
        if (rememberMeChecker) {
          validateEmail(userName: '+$dialCode$emailOrPhone');
        }else{
          debugPrint('dialCode $dialCode');
          validateEmail(userName: '+$dialCode$emailOrPhone',);
        }
      }
    }catch(e){
      errorMessage = e.toString();
      debugPrint('error :${e.toString()}');
      isLoading = false;
      emit(ValidateEmailError(e.toString()));
    }
  }
/////////////////////////////////////////////////////////////////////////////////////////////// country code with IP
///////////////////////////////////////////////////////////////////////////////////////////////
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
        emit(GetIPForCountryError(response.statusMessage));
      }
    }catch(e){
      isLoading = false;
      emit(GetIPForCountryFailure(e.toString()));
    }
  }
///////////////////////////////////////////////////////////////////////////////////////////////  normal login
///////////////////////////////////////////////////////////////////////////////////////////////
  Future<void> loginNormal(
    BuildContext context,{
    required String emailOrPhone,
    required String passwordText,
  })async{
    try {
      if (emailOrPhone.startsWith('0')) {
        emailOrPhone = emailOrPhone.replaceFirst('0', '');
      }
      isLoading = true;
      emit(GettingDialCode());
      String? dialCode;
      dialCode = CacheHelper.getData(key: Constants.selectedCountryCode.toString());
      if (emailOrPhone.contains('@')) {
        normalLogin(context, emailOrPhone: emailOrPhone, password: passwordText);
      } else {
        bool rememberMeChecker = CacheHelper.getData(key: Constants.rememberMeChecker.toString()) ?? false;
        if (rememberMeChecker) {
          normalLogin(context, emailOrPhone: '+$dialCode${(emailOrPhone)}', password: passwordText);
        } else {
          normalLogin(context, emailOrPhone: '+$dialCode${(emailOrPhone)}', password: passwordText);
        }
      }
    } catch (e) {
      isLoading = false;
      errorMessage = e.toString();
      debugPrint(e.toString());
      emit(AdminSignDialCodeError());
    }
  }
////////////////////////////////////////////////////////////////////////////////
  LoginEntity? loginEntity;
  Future<void> normalLogin(
    BuildContext context,{
    required String emailOrPhone,
    required String password
  })async{
    isLoading = true;
    emit(LoginLoading());
    final login = await loginUseCase(emailOrPhone, password);
    login.fold((failure) {
      isLoading = false;
      errorMessage = failure.errorMessage;
      emit(LoginFailure(failure.errorMessage));
    }, (loginObject) {
      if (loginObject.isSuccess!) {
        loginEntity = loginObject;
        saveSocialData(loginObject, context);
        debugPrint("token = ${loginEntity?.data?.token}");
        saveEmailAndPasswordInShared(emailOrPhone, password);
        isLoading = false;
        emit(LoginSuccess(loginObject));
      } else {
        errorMessage = loginObject.errors?.first.message;
        isLoading = false;
        emit(LoginError(loginObject.errors!.first.message!));
      }
    });
  }
////////////////////////////////////////////////////////////////////////////////
  void saveSocialData(entity, BuildContext context){
    CacheHelper.saveData(key: Constants.token.toString(), value: entity.data!.token);
    CacheHelper.saveData(key: Constants.refreshToken.toString(), value: entity.data!.refreshToken);
    CacheHelper.saveData(key: Constants.isLogged.toString(), value: true);
    final jwtData = jwtDecode(entity.data!.token.toString());
    CacheHelper.saveData(key: Constants.customerID.toString(), value: jwtData.payload["Id"]);
    CacheHelper.saveData(key: Constants.countryID.toString(), value: jwtData.payload["CountryId"]);
    CacheHelper.saveData(key: Constants.dexefCountryId.toString(), value: jwtData.payload["DexefCountryId"]);
    CacheHelper.saveData(key: Constants.customerCurrency.toString(), value: getString(title: jwtData.payload["Currency"], context: context));
    CacheHelper.saveData(key: Constants.customerEmail.toString(), value: jwtData.payload["email"]);
    CacheHelper.saveData(key: Constants.customerPhone.toString(), value: jwtData.payload["Mobile"]);
    CacheHelper.saveData(key: Constants.customerName.toString(), value: jwtData.payload["Name"]);
    String customerName = CacheHelper.getData(key: Constants.customerName.toString());
    CacheHelper.saveData(key: Constants.activeStatus.toString(), value: jwtData.payload["StatusId"]);
    List<String> customerNameSeparate = customerName.split(" ");
    String customerFirstName = customerNameSeparate[0];
    String customerLastName = customerNameSeparate.length > 1 ? customerNameSeparate.sublist(1).join(" ") : "Dexef Customer";
    CacheHelper.saveData(key: Constants.customerFirstName.toString(), value: customerFirstName);
    CacheHelper.saveData(key: Constants.customerLastName.toString(), value: customerLastName);
    DioHelper.init();
  }
////////////////////////////////////////////////////////////////////////////////
  void saveEmailAndPasswordInShared(String emailOrPhone, String password) {
    bool rememberMeChecker = CacheHelper.getData(key: Constants.rememberMeChecker.toString()) ?? false;
    if (rememberMeChecker) {
      CacheHelper.saveData(key: Constants.emailOrPhone.toString(), value: emailOrPhone);
      CacheHelper.saveData(key: Constants.password.toString(), value: password);
    }
  }
/////////////////////////////////////////////////////////////////////////////////////////////// sign in with google mobile firebase
//////////////////////////////////////////////////////////////////////////////// sign in with google mobile firebase
  UserCredential? credGoogle;
  AuthCredential? credentialGoogle;
  Future<void> signInWithGoogle() async {
    isLoading = true;
    emit(SignInWithGoogleMobileLoading());
    try {
      credentialGoogle = await DefaultSignInGoogle();
      credGoogle = await FirebaseAuth.instance.signInWithCredential(credentialGoogle!);
      debugPrint('Sign in With Google Success');
      isLoading = false;
      if(googleAuth?.accessToken != null){
        loginWithGoogle(token: "${googleAuth?.accessToken}");
      }
    } catch (e) {
      log('error is ${e.toString()}');
      errorMessage = e.toString();
      isLoading = false;
      emit(SignInWithGoogleMobileError(e.toString()));
    }
  }
////////////////////////////////////////////////////////////////////////////////  sign in with google web firebase
  UserCredential? credGoogleWeb;
  signInWithGoogleWeb(bool isSignIn) async {
    isLoading = true;
    emit(SignInWithGoogleWebLoading());
    try {
      if(isSignIn){
        clearCookies();
      }
      handleSignOut();
      GoogleAuthProvider googleProvider = GoogleAuthProvider();
      googleProvider.addScope('https://www.googleapis.com/auth/contacts.readonly');
      googleProvider.setCustomParameters({'prompt': 'select_account'});
      credGoogleWeb = await FirebaseAuth.instance.signInWithPopup(googleProvider);
      isLoading = false;
      if(credGoogleWeb?.credential?.accessToken != null){
        loginWithGoogle(token: credGoogleWeb!.credential!.accessToken!);
      }
    }catch(e){
      errorMessage = e.toString();
      log('${e.hashCode} Error Google web is ${e.toString()}');
      if (e.toString().contains(AppConstants.loginPopupCanceledByUser) ||
          e.toString().contains(AppConstants.loginBeforeFinalizingOperation) ||
          e.toString().contains('popup-closed-by-user') || e.toString().contains('cancelled-popup-request')) {
        debugPrint('Canceled By User');
        errorMessage = '';
        isLoading = false;
        emit(CanceledByUserWebGoogle());
      } else{
        isLoading = false;
        emit(SignInWithGoogleWebError(e.toString()));
      }
    }
  }
////////////////////////////////////////////////////////////////////////////////
  void clearCookies() {
    html.document.cookie = "";
    debugPrint("Cookies cleared.");
  }
////////////////////////////////////////////////////////////////////////////////
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  Future<void> handleSignOut() async {
    try {
      await _googleSignIn.disconnect();
      debugPrint("User disconnected successfully.");
    } catch (error) {
      debugPrint("Error disconnecting: $error");
    }
  }
//////////////////////////////////////////////////////////////////////////////// login in with google
  loginWithGoogle({required String token, context}) async {
    isLoading = true;
    emit(LoginWithGoogleLoading());
    final result = await googleSignInUseCase(token);
    result.fold((failure) {
      errorMessage = failure.toString();
      isLoading = false;
      emit(LoginWithGoogleFailure(failure.errorMessage));
    }, (signInGoogle) async {
      if (signInGoogle.isSuccess == true) {
        log('Success = true');
        saveSocialData(signInGoogle, context);
        isLoading = false;
        emit(LoginWithGoogleSuccess(signInGoogle));
      } else {
        log('Success = false');
        log('Success = ${signInGoogle.errors?.first.message}');
        if (signInGoogle.errors!.first.message.toString().contains('غير موجود') ||
            signInGoogle.errors!.first.message.toString().contains('Not Found') ||
            signInGoogle.errors!.first.message.toString().contains('This mobile is not verified') ||
            signInGoogle.errors!.first.message.toString().contains('هذا الرقم غير مفعل')) {
          errorMessage = null;
        }
        isLoading = false;
        emit(LoginWithGoogleError(signInGoogle.errors?.first.message));
      }
    });
  }
/////////////////////////////////////////////////////////////////////////////////////////////// sign in with apple mobile firebase
///////////////////////////////////////////////////////////////////////////////////////////////
  UserCredential? appleCredential;
  String? idToken;
  signInWithAppleWeb(BuildContext context) async {
    isLoading = true;
    emit(SignInAppleLoadingFirebase());
    try {
      final provider = OAuthProvider("apple.com")..addScope('email')..addScope('name');
      appleCredential = await FirebaseAuth.instance.signInWithPopup(provider);
      idToken = await appleCredential?.user?.getIdToken();
      isLoading = false;
      if(idToken != null){
        loginWithApple(token: idToken!, context: context);
      }
    } catch (e) {
      debugPrint("error apple =  $e");
      isLoading = false;
      emit(SignInAppleErrorFirebase(e.toString()));
    }
  }
//////////////////////////////////////////////////////////////////////////////// login with apple
  loginWithApple({required String token, context}) async {
    isLoading = true;
    emit(LoginWithAppleLoading());
    final result = await appleSignInUseCase(token);
    result.fold((failure) {
      isLoading = false;
      emit(LoginWithAppleFailure(failure.errorMessage));
    }, (appleSignIn) async {
      try {
        if (appleSignIn.isSuccess == true) {
          log('Success = true');
          saveSocialData(appleSignIn, context);
          isLoading = false;
          emit(LoginWithAppleSuccess(appleSignIn));
        } else {
          log('Success = false');
          errorMessage = appleSignIn.errors?.first.message;
          if (appleSignIn.errors!.first.message.toString().contains('غير موجود') ||
              appleSignIn.errors!.first.message.toString().contains('Not Found') ||
              appleSignIn.errors!.first.message.toString().contains('This mobile is not verified') ||
              appleSignIn.errors!.first.message.toString().contains('هذا الرقم غير مفعل')) {
            errorMessage = null;
          }
          isLoading = false;
          emit(LoginWithAppleError(appleSignIn.errors!.first.message!));
        }
      } catch (e) {
        isLoading = false;
        emit(LoginWithAppleError(appleSignIn.errors!.first.message!));
      }
    });
  }
/////////////////////////////////////////////////////////////////////////////////////////////// sign out with google
///////////////////////////////////////////////////////////////////////////////////////////////
  GoogleSignIn googleSignInNew = GoogleSignIn(
    clientId: '585255872109-ltgp15tmg6ptjm08h3vg5o93ss0gukn6.apps.googleusercontent.com'
  );
  Future<void> signOut() async {
    emit(SignOutGoogleLoading());
    try {
      if (kIsWeb) {
        await googleSignInNew.signOut().then((value){
          FirebaseAuth.instance.signOut();
          emit(SignOutGoogleWebSuccess());
        }).catchError((error) {
          debugPrint('Error sign out ${error.toString()}');
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
///////////////////////////////////////////////////////////////////////////////////////////// public
/////////////////////////////////////////////////////////////////////////////////////////////
  changeErrorMessageState(){
    emit(ChangeMessageErrorState());
  }
//////////////////////////////////////////////////////////////////////////////// modify data
  modifyData(){
    validateEmailEntity?.data = null;
    errorMessage = null;
    CacheHelper.saveData(key: Constants.emailType.toString(), value: '');
    loginType = CacheHelper.getData(key: Constants.emailType.toString());
    changeErrorMessageState();
    emit(ModifyDataState());
  }
//////////////////////////////////////////////////////////////////////////////// search
  List<Country> searchInCountries = [];
  searchCountries(String text) {
    emit(SearchStartingLoading());
    searchInCountries.clear();
    if(text.isNotEmpty){
      searchInCountries.addAll(countries.where((element) => element.name.toLowerCase().contains(text.toLowerCase()) || element.nameTranslations['ar']!.toLowerCase().contains(text.toLowerCase())));
    }
    emit(SearchEndState());
  }
}
