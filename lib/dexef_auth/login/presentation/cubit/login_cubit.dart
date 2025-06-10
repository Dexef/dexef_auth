import 'package:auth_dexef/dexef_auth/login/presentation/cubit/login_states.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
import '../../data/model/LoginModel.dart';
import '../../domain/entity/login_entity.dart';
import '../../domain/entity/validate_email_entity.dart';
import '../../domain/useCase/apple_signIn_useCase.dart';
import '../../domain/useCase/google_signIn_use_case.dart';
import '../../domain/useCase/login_use_case.dart';
import 'package:flutter/material.dart';
import 'package:get_ip_address/get_ip_address.dart' as ip;
import '../../domain/useCase/validate_email_use_case.dart';
import 'dart:html' as html;

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(
    this.loginUseCase,
    this.googleSignInUseCase,
    this.appleSignInUseCase,
    this.validateEmailUseCase
  ):super(LoginInitial());
  static final LoginCubit _loginCubit = BlocProvider.of<LoginCubit>(navigatorKey.currentState!.context);
  static LoginCubit get instance => _loginCubit;
////////////////////////////////////////////////////////////////////////////////
  final LoginUseCase loginUseCase;
  bool isLoading = false;
  String? errorMessage;
  LoginEntity? loginEntity;
  Future<void> normalLogin(String emailOrPhone, String password, BuildContext context) async {
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
        saveTokenInShared(loginObject.data!, context);
        debugPrint("token = ${loginEntity?.data?.token}");
        saveEmailAndPasswordInShared(emailOrPhone, password);
        DioHelper.init();
        isLoading = false;
        emit(LoginSuccess(loginObject));
      } else {
        errorMessage = loginObject.errors?.first.message;
        isLoading = false;
        emit(LoginError(loginObject.errors!.first.message));
      }
    });
  }
////////////////////////////////////////////////////////////////////////////////
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
////////////////////////////////////////////////////////////////////////////////
  void saveTokenInShared(LoginData loginData, BuildContext context) {
    CacheHelper.saveData(key: Constants.token.toString(), value: loginData.token);
    CacheHelper.saveData(key: Constants.refreshToken.toString(), value: loginData.refreshToken);
    CacheHelper.saveData(key: Constants.isLogged.toString(), value: true);
    final jwtData = jwtDecode(loginData.token.toString());
    CacheHelper.saveData(key: Constants.customerID.toString(), value: jwtData.payload["Id"]);
    CacheHelper.saveData(key: Constants.countryID.toString(), value: jwtData.payload["CountryId"]);
    CacheHelper.saveData(key: Constants.dexefCountryId.toString(), value: jwtData.payload["DexefCountryId"]);
    CacheHelper.saveData(key: Constants.customerCurrency.toString(), value: getString(title: jwtData.payload["Currency"], context: context));
    CacheHelper.saveData(key: Constants.activeStatus.toString(), value: jwtData.payload["StatusId"]);
    CacheHelper.saveData(key: Constants.customerEmail.toString(), value: jwtData.payload["email"]);
    CacheHelper.saveData(key: Constants.customerPhone.toString(), value: jwtData.payload["Mobile"]);
    CacheHelper.saveData(key: Constants.customerName.toString(), value: jwtData.payload["Name"]);
    String customerName = CacheHelper.getData(key: Constants.customerName.toString());
    List<String> customerNameSeparate = customerName.split(" ");
    String customerFirstName = customerNameSeparate[0];
    String customerLastName = customerNameSeparate.length > 1 ? customerNameSeparate.sublist(1).join(" ") : "Dexef Customer";
    CacheHelper.saveData(key: Constants.customerFirstName.toString(), value: customerFirstName);
    CacheHelper.saveData(key: Constants.customerLastName.toString(), value: customerLastName);
  }
////////////////////////////////////////////////////////////////////////////////
  void saveEmailAndPasswordInShared(String emailOrPhone, String password) {
    bool rememberMeChecker = CacheHelper.getData(key: Constants.rememberMeChecker.toString()) ?? false;
    if (rememberMeChecker) {
      CacheHelper.saveData(key: Constants.emailOrPhone.toString(), value: emailOrPhone);
      CacheHelper.saveData(key: Constants.password.toString(), value: password);
    } else {
      debugPrint('Remember Me is not checked, data not saved');
    }
  }
////////////////////////////////////////////////////////////////////////////////
  GoogleSignInUseCase googleSignInUseCase;
  loginWithGoogle({required String token, context}) async {
    isLoading = true;
    emit(GoogleLoginLoading());
    final result = await googleSignInUseCase(token);
    result.fold((failure) {
      errorMessage = failure.toString();
      emit(GoogleLoginFailure(failure.errorMessage));
    }, (signInGoogle) async {
      if (signInGoogle.isSuccess == true) {
        saveSocialData(signInGoogle);
        emit(GoogleLoginSuccess(signInGoogle));
      } else {
        if (signInGoogle.errors!.first.message.toString().contains('غير موجود') ||
            signInGoogle.errors!.first.message.toString().contains('Not Found') ||
            signInGoogle.errors!.first.message.toString().contains('This mobile is not verified') ||
            signInGoogle.errors!.first.message.toString().contains('هذا الرقم غير مفعل')) {
          errorMessage = null;
        }
        emit(GoogleLoginError(signInGoogle.errors!.first.message));
      }
    });
  }
////////////////////////////////////////////////////////////////////////////////
  void saveSocialData(entity) {
    CacheHelper.saveData(key: Constants.token.toString(), value: entity.data!.token);
    CacheHelper.saveData(key: Constants.refreshToken.toString(), value: entity.data!.refreshToken);
    CacheHelper.saveData(key: Constants.isLogged.toString(), value: true);
    final jwtData = jwtDecode(entity.data!.token.toString());
    CacheHelper.saveData(key: Constants.customerID.toString(), value: jwtData.payload["Id"]);
    CacheHelper.saveData(key: Constants.countryID.toString(), value: jwtData.payload["CountryId"]);
    CacheHelper.saveData(key: Constants.dexefCountryId.toString(), value: jwtData.payload["DexefCountryId"]);
    CacheHelper.saveData(key: Constants.customerEmail.toString(), value: jwtData.payload["email"]);
    CacheHelper.saveData(key: Constants.customerPhone.toString(), value: jwtData.payload["Mobile"]);
    CacheHelper.saveData(key: Constants.customerName.toString(), value: jwtData.payload["Name"]);
    String customerName =
    CacheHelper.getData(key: Constants.customerName.toString());
    CacheHelper.saveData(key: Constants.activeStatus.toString(), value: jwtData.payload["StatusId"]);
    List<String> customerNameSeparate = customerName.split(" ");
    String customerFirstName = customerNameSeparate[0];
    String customerLastName = customerNameSeparate.length > 1 ? customerNameSeparate.sublist(1).join(" ") : "Dexef Customer";
    CacheHelper.saveData(key: Constants.customerFirstName.toString(), value: customerFirstName);
    CacheHelper.saveData(key: Constants.customerLastName.toString(), value: customerLastName);
    DioHelper.init();
  }
////////////////////////////////////////////////////////////////////////////////
  AppleSignInUseCase appleSignInUseCase;
  appleSignIn({required String token, context}) async {
    emit(AppleLoginLoading());
    final result = await appleSignInUseCase(token);
    result.fold((failure) {
      emit(AppleLoginFailure(failure.errorMessage));
    }, (appleSignIn) async {
      try {
        if (appleSignIn.isSuccess == true) {
          saveSocialData(appleSignIn);
          DioHelper.init();
          emit(AppleLoginSuccess(appleSignIn));
        } else {
          errorMessage = appleSignIn.errors?.first.message;
          if (appleSignIn.errors!.first.message.toString().contains('غير موجود') ||
              appleSignIn.errors!.first.message.toString().contains('Not Found') ||
              appleSignIn.errors!.first.message.toString().contains('This mobile is not verified') ||
              appleSignIn.errors!.first.message.toString().contains('هذا الرقم غير مفعل')) {
            errorMessage = null;
          }
          emit(AppleLoginError(appleSignIn.errors!.first.message!));
        }
      } catch (e) {
        debugPrint('appleSignIn error ${e.toString()}');
      }
    });
  }
////////////////////////////////////////////////////////////////////////////////
  ValidateEmailUseCase validateEmailUseCase;
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
        bool rememberMeChecker = CacheHelper.getData(key: Constants.rememberMeChecker.toString()) ?? false;
        if (rememberMeChecker) {
          validateEmail(userName: '+$dialCode$emailOrPhone');
        } else {
          validateEmail(userName: '+$dialCode$emailOrPhone');
        }
      }
    } catch (e) {
      isLoading = false;
      validateSuccess = false;
      debugPrint('error :${e.toString()}');
    }
  }
////////////////////////////////////////////////////////////////////////////////
  ValidateEmailEntity? validateEmailEntity;
  bool googleOrAppleLogin = false;
  String socialLogin = '';
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
        emit(ValidateEmailError(validate.errors?.first.message));
      }
    });
  }
////////////////////////////////////////////////////////////////////////////////
  String? userCountryCode;
  lookupUserCountry() async {
    Dio dio = Dio();
    try{
      emit(GetIPForCountryLoading());
      isLoading = true;
      final ipAddress = ip.IpAddress(type: ip.RequestType.text);
      final ipv4 = await ipAddress.getIpAddress();
      final response = await dio.get('https://api.ipregistry.co/$ipv4?key=tz3om0lor45w6ec6');
      if (response.statusCode == 200) {
        userCountryCode =  response.data['location']['country']['code'];
        isLoading = false;
        emit(GetIPForCountrySuccess());
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
////////////////////////////////////////////////////////////////////////////////
  UserCredential? credGoogleWeb;
  googleFirebaseLoginWeb() async {
    emit(GoogleFirebaseLoginWebLoading());
    try {
      clearCookies();
      handleSignOut();
      GoogleAuthProvider googleProvider = GoogleAuthProvider();
      googleProvider.addScope('https://www.googleapis.com/auth/contacts.readonly');
      googleProvider.setCustomParameters({
        'prompt': 'select_account', // Ensures user selects or enters a new account
      });
      credGoogleWeb =
      await FirebaseAuth.instance.signInWithPopup(googleProvider);
      socialLogin = AppConstants.googleString;
      emit(GoogleFirebaseLoginWebSuccess());
    }
    catch (e) {
      errorMessage = e.toString();
      debugPrint('${e.hashCode} Error Google web is ${e.toString()}');
      if (e.toString().contains(AppConstants.popupCanceledByUser) ||
          e.toString().contains(AppConstants.beforeFinalizingOperation) ||
          e.toString().contains('popup-closed-by-user') ||
          e.toString().contains('cancelled-popup-request')) {
        debugPrint('Canceled By User');
        errorMessage = '';
        emit(CanceledByUserWebGoogle());
      } else{
        emit(GoogleFirebaseLoginWebError());
      }
    }
  }
////////////////////////////////////////////////////////////////////////////////
  void clearCookies() {
    html.document.cookie = "";
    debugPrint("Cookies cleared.");
  }
////////////////////////////////////////////////////////////////////////////////
  Future<void> handleSignOut() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    try {
      await googleSignIn.disconnect();
      debugPrint("User disconnected successfully.");
    } catch (error) {
      debugPrint("Error disconnecting: $error");
    }
  }
////////////////////////////////////////////////////////////////////////////////
  String emailType = '';
  getEmailType(){
    emailType = validateEmailEntity?.data?.type ?? CacheHelper.getData(key: Constants.emailType.toString())??'';
    return emailType;
  }
////////////////////////////////////////////////////////////////////////////////
  bool modifyDataFromPassword = false;
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
  changeErrorMessageState(){
    emit(ChangeMessageErrorState());
  }
////////////////////////////////////////////////////////////////////////////////
  String? appleEmail;
  UserCredential? appleCredential;
  String? idToken;
  appleLoginFirebaseWeb() async {
    try {
      emit(AppleLoginFirebaseWebLoading());
      final provider = OAuthProvider("apple.com")
        ..addScope('email')
        ..addScope('name');
      appleCredential = await FirebaseAuth.instance.signInWithPopup(provider);
      idToken = await appleCredential?.user?.getIdToken();
      appleEmail = appleCredential?.user?.email;
      socialLogin = AppConstants.appleString;
      emit(AppleLoginFirebaseWebSuccess());
    } catch (e) {
      debugPrint("error apple =  $e");
      // errorMessage = e.toString();
      emit(AppleLoginFirebaseWebError());
    }
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
  UserCredential? credGoogle;
  AuthCredential? credentialGoogle;
  Future<void> googleFirebaseLoginMobile() async {
    emit(GoogleFirebaseLoginMobileLoading());
    try {
      credentialGoogle = await DefaultSignInGoogle();
      credGoogle = await FirebaseAuth.instance.signInWithCredential(credentialGoogle!);
      debugPrint('Sign in With Google Success');
      emit(GoogleFirebaseLoginMobileSuccess());
    } catch (e) {
      errorMessage = e.toString();
      emit(GoogleFirebaseLoginMobileError());
    }
  }
////////////////////////////////////////////////////////////////////////////////
}