import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jwt_decode_full/jwt_decode_full.dart';
import '../../../../../core/class_constants/constants_methods.dart';
import '../../../../../rest/dio_helper.dart';
import '../../../../../utils/cash_helper.dart';
import '../../../../../utils/constants.dart';
import '../../../../Profile_Info/domain/entity/update_mobile_entity.dart';
import '../../../../Profile_Info/domain/useCase/updatePhone_useCase.dart';
import '../../../../Profile_Info/domain/useCase/verifyMobile_usecase.dart';
import '../../../login/data/model/LoginModel.dart';
import '../../../register/domain/entity/change_mobile_entity.dart';
import '../../../login/domain/entity/login_entity.dart';
import '../../../register/domain/entity/send_sms_entity.dart';
import '../../../register/domain/useCase/change_phone_number.dart';
import '../../../domain/use_case/login_use_case.dart';
import '../../../register/domain/useCase/reend_code_use_case.dart';
import '../../../domain/use_case/reset_password_use_case.dart';
import '../../../register/domain/useCase/send_sms_use_case.dart';
import '../../../domain/use_case/verify_code_use_case.dart';
import 'verify_code_states.dart';
import 'package:get_ip_address/get_ip_address.dart' as ip;

class VerifyCodeCubit extends Cubit<VerifyCodeStates> {
  VerifyCodeUseCase? verifyCodeUseCase;
  ResendCodeUseCase? resendCodeUseCase;
  ChangePhoneNumberUseCase? changePhoneNumberUseCase;
  LoginUseCase? loginUseCase;
  SendSmsUseCase sendSmsUseCase;
  ResetPasswordUseCase resetPasswordUseCase;

  VerifyCodeCubit(this.verifyCodeUseCase, this.resendCodeUseCase,
      this.changePhoneNumberUseCase, this.loginUseCase , this.sendSmsUseCase,this.resetPasswordUseCase,this.updateMobileNumberUseCase,this.verifyMobileUseCase)
      : super(VerifyCodeInitialState());

  static VerifyCodeCubit get(context) => BlocProvider.of(context);

////////////////////////////////////////////////////////////////////////////////////////////// verify code sms
  String? errorMessage;
  verifyCodeSms({
    required int mobileId,
    required String code,
    String? email,
    String? password,
  }) async {
    emit(VerifyLoadingState());
    final result = await verifyCodeUseCase!(
      mobileId,
      code,
    );
    result.fold((failure) {
      errorMessage = failure.errorMessage;
      emit(VerifyCodeError(failure.errorMessage));
    },
            (verifyCode) {
          if (verifyCode.isSuccess == true) {
            signInNormal(email!, password!);
            emit(VerifyCodeSuccess(verifyCode));
          } else {
            errorMessage = verifyCode.errors?.first.message;
            emit(VerifyCodeFailed(verifyCode.errors!.first.message.toString()));
          }
        });
  }

///////////////////////////////////////////////////////////////////////////////////////////////// resend cde sms
  bool isLoading = false;
  resendCodeSms({required int mobileId ,required bool isWhatsapp}) async {
    CacheHelper.removeData(key: Constants.expireDate.toString());
    CacheHelper.removeData(key: Constants.blockedDate.toString());
    ///
    // CacheHelper.saveData(key: 'isFirstTimeCheck', value: true);
    isLoading = true;
    emit(ResendCodeLoading());
    final result = await resendCodeUseCase!(mobileId,isWhatsapp);
    result.fold((failure) => emit(ResendCodeFailed(failure.errorMessage)),
            (resendCode)async {
          if(resendCode.isSuccess == true){
            CacheHelper.saveData(key: Constants.expireDate.toString(), value: resendCode.data?.expiryDate ??'');
            CacheHelper.saveData(key: Constants.blockedDate.toString(), value: resendCode.data?.blockTillDate?? '');
            // await getTime();
            await checkDate();

            isLoading = false;
            emit(ResendCodeSuccess(resendCode));
          }else {
            emit(ResendCodeError(resendCode.errors?.first.message));
          }
        });
  }

///////////////////////////////////////////////////////////////////////////////////////////////// change phone number
//   ChangeMobileEntity? changeMobileEntity;
  changePhoneNumber(
      {required int mobileId,
        required String phoneNumber,
        required String countryCode,required bool isWhatsapp}) async {
    CacheHelper.removeData(key: Constants.expireDate.toString());
    CacheHelper.removeData(key: Constants.blockedDate.toString());
    ///
    // CacheHelper.saveData(key: 'isFirstTimeCheck', value: true);
    emit(ChangePhoneLoadingState());
    final result =
    await changePhoneNumberUseCase!(phoneNumber, countryCode, mobileId,isWhatsapp);
    result.fold((failure) {
      errorMessage = failure.errorMessage;
      emit(ChangePhoneNumberFailed(failure.errorMessage));
    }, (changePhoneNumber) async{
          if (changePhoneNumber.isSuccess == true) {
            // changeMobileEntity = changePhoneNumber;
            CacheHelper.saveData(key: Constants.expireDate.toString(), value: changePhoneNumber.data?.expiryDate ??'');
            CacheHelper.saveData(key: Constants.blockedDate.toString(), value: changePhoneNumber.data?.blockTillDate?? '');
            await getTime();
            await checkDate();

            emit(ChangePhoneNumberSuccess(
                changePhoneNumber.data!.mobileId!.toInt()));
          } else {
            errorMessage = changePhoneNumber.errors?.first.message;
            emit(ChangePhoneNumberError(
                changePhoneNumber.errors!.first.message.toString()));
          }
        });
  }

  // void validateField(String value) {
  //   if (value.isEmpty) {
  //     // errorMessage = 'sssssssssssssssssssssssssssssss';
  //     emit(ChangePhoneNumberFailed('errror'));
  //   } else if(state is ChangePhoneNumberFailed) {
  //     // errorMessage = 'sssssssssssssssssssssssssssssss';
  //     emit(ChangePhoneNumberFailed('errror'));
  //   }
  // }

///////////////////////////////////////////////////////////////////////////////////////////////// change phone number
  Future<void> signInNormal(String emailOrPhone, String passwordText) async {
    try {
      String? dialCode;
      dialCode = await lookupUserCountry();
      if (emailOrPhone.contains('@')) {
        normalLogin(emailOrPhone, passwordText);
      } else {
        bool rememberMeChecker =
            CacheHelper.getData(key: Constants.rememberMeChecker.toString()) ??
                false;
        if (rememberMeChecker) {
          normalLogin(emailOrPhone, passwordText);
        } else {
          normalLogin('+$dialCode${(emailOrPhone).replaceFirst('0', '')}',
              passwordText);
        }
      }
    } catch (e) {
      emit(AdminSignDialCodeError());
    }
  }

/////////////////////////////////////////////////////////////////////////////////////////////// normal login
  LoginEntity? loginEntity;

  Future<void> normalLogin(String emailOrPhone, String password) async {
    isLoading = true;
    emit(LoginLoading());
    final login = await loginUseCase!(emailOrPhone, password);
    login.fold((failure) {
      isLoading = false;
      emit(LoginNetworkFailed());
    }, (loginObject) {
      if (loginObject.isSuccess!) {
        loginEntity = loginObject;
        saveTokenInShared(loginObject.data!,);
        saveEmailAndPasswordInShared(emailOrPhone, password);
        DioHelper.init();
        isLoading = false;
        emit(LoginSuccess());
      } else {
        isLoading = false;
        emit(LoginUnSuccess());
      }
    });
  }

/////////////////////////////////////////////////////////////////////////////////////////////// normal login
  Dio dio = Dio();

  Future<String> lookupUserCountry() async {
    // final ipv4 = await Ipify.ipv4();
    final ipAddress = ip.IpAddress(type: ip.RequestType.text);
    final ipv4 = await ipAddress.getIpAddress();
    print('IP Address: $ipv4');
    final response =
    await dio.get('https://api.ipregistry.co/$ipv4?key=tz3om0lor45w6ec6');
    if (response.statusCode == 200) {
      return response.data['location']['country']['calling_code'];
    } else {
      throw Exception('Failed to get user country from IP address');
    }
  }

/////////////////////////////////////////////////////////////////////////////////////////////// normal login
  void saveTokenInShared(LoginData loginData,) {
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
        value: getString(title: jwtData.payload["Currency"],));
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
        key: Constants.customerName.toString(),
        value: jwtData.payload["Name"]);

    String customerName =CacheHelper.getData(key: Constants.customerName.toString());

    List<String> customerNameSeperate = customerName.split(" ");
    String customerFirstName = customerNameSeperate[0];
    String customerLastName = customerNameSeperate.length > 1 ? customerNameSeperate.sublist(1).join(" ") : "Dexef Customer";

    CacheHelper.saveData(
        key: Constants.customerFirstName.toString(),
        value: customerFirstName);
    CacheHelper.saveData(
        key: Constants.customerLastName.toString(),
        value:customerLastName);


  }


/////////////////////////////////////////////////////////////////////////////////////////////// save email and password in shared
  void saveEmailAndPasswordInShared(String emailOrPhone, String password) {
    bool rememberMeChecker =
        CacheHelper.getData(key: Constants.rememberMeChecker.toString()) ??
            false;
    if (rememberMeChecker) {
      CacheHelper.saveData(
          key: Constants.emailOrPhone.toString(), value: emailOrPhone);
      CacheHelper.saveData(key: Constants.password.toString(), value: password);
    }
  }
///////////////////////////////////////////////////////////////////////////////////////////////
  bool isWhatsAppSelected = true;
  void handleWhatsAppChanged(bool? value) {
    isWhatsAppSelected = true;
    CacheHelper.saveData(key: Constants.isWhatsApp.toString(), value: true);
    errorMessage = null;
    emit(WhatsappCodeChecked());
  }
  void handleSmsChanged(bool? value) {
    isWhatsAppSelected = false;
    CacheHelper.saveData(key: Constants.isWhatsApp.toString(), value: false);
    errorMessage = null;
    emit(SmsCodeChecked());
  }
///////////////////////////////////////////////////////////////////////////////////////////////
  SendSmsEntity? sendSmsEntity;
  bool _isGetTimeExecuted = false;

  sendSmsVerification({
    required int mobileId,
    required bool isWhatsApp }) async
  {
    CacheHelper.removeData(key: Constants.expireDate.toString());
    CacheHelper.removeData(key: Constants.blockedDate.toString());
    CacheHelper.saveData(key: 'isFirstTimeCheck', value: true);
    emit(SendSmsLoading());
    final result =
    await sendSmsUseCase.call(mobileId, isWhatsApp);
    result.fold((failure) {
      errorMessage = failure.errorMessage;
      emit(SendSmsFailure(failure.errorMessage));
    }, (sendSms) async{
      if (sendSms.isSuccess == true) {
        CacheHelper.saveData(key: Constants.expireDate.toString(), value: sendSms.data?.expiryDate ??'');
        CacheHelper.saveData(key: Constants.blockedDate.toString(), value: sendSms.data?.blockTillDate ?? '');
        await getTime();
        await checkDate();

        emit(SendSmsSuccess());
      } else {
        errorMessage = sendSms.errors!.first.message;
        emit(SendSmsError(sendSms.errors!.first.message.toString()));
      }
    });
  }
///////////////////////////////////////////////////////////////////////////////////////////////
  String? dialCode;
  resetPassword({required String emailOrPhone,required bool isWhatsapp}) async {
    emit(ResetPasswordLoadingState());
    CacheHelper.removeData(key: Constants.resetExpireDate.toString());
    CacheHelper.removeData(key: Constants.resetBlockedDate.toString());
    CacheHelper.saveData(key: 'isFirstTimeCheck', value: true);
    dialCode = await lookupUserCountry();
    final result = await resetPasswordUseCase(emailOrPhone,isWhatsapp);
    result.fold((failure){
      errorMessage = failure.errorMessage;
      emit(ResetPasswordFailure(failure.errorMessage));
    }, (resetPassword) async{
      print(resetPassword.isSuccess);
      if (resetPassword.isSuccess!) {
        print(resetPassword.data!.mobileId!);
        CacheHelper.saveData(key: Constants.resetExpireDate.toString(), value: resetPassword.data?.expiryDate ??'');
        CacheHelper.saveData(key: Constants.resetBlockedDate.toString(), value: resetPassword.data?.blockTillDate?? '');
        await getTime();
        await checkDate();
        emit(ResetPasswordSuccess(resetPassword));
      } else {
        errorMessage = resetPassword.errors?.first.message;
        emit(ResetPasswordError(resetPassword.errors!.first.message!));
      }
    });
  }
///////////////////////////////////////////////////////////////////////////////////////////////
  Future<void> resetPasswordEmailOrPhone(String emailOrPhone,bool isWhatsapp) async {
    print(emailOrPhone);
    if (emailOrPhone.contains('@')) {
      resetPassword (emailOrPhone: emailOrPhone,isWhatsapp: isWhatsapp);
    } else if (emailOrPhone.contains("+")) {
      resetPassword (emailOrPhone: emailOrPhone,isWhatsapp: isWhatsapp);
    } else {
      String? dialCode;
      dialCode = await lookupUserCountry();
      String? emailOrPhone1 = emailOrPhone.startsWith('0')
          ? emailOrPhone.replaceFirst('0', '')
          : emailOrPhone;
      resetPassword (emailOrPhone: '+$dialCode$emailOrPhone1',isWhatsapp: isWhatsapp);
      print('$dialCode$emailOrPhone1');
    }
  }
///////////////////////////////////////////////////////////////////////////////////////////////

  String? expireDate = CacheHelper.getData(key: Constants.expireDate.toString());
  String? blockedDate = CacheHelper.getData(key: Constants.blockedDate.toString());
  Duration? differenceTime = Duration(seconds: 0);
  DateTime now = DateTime.now().toUtc() ;

  DateTime? parsedDate;
  Future<void> getTime() async {
    try {
      var res = await Dio().get('https://mydexefcustomerapilive.azurewebsites.net/api/Customer/GetInternationalDate');
      String utcDatetime = res.data;
      now = DateTime.parse(utcDatetime).toUtc();
      // CacheHelper.saveData(key: 'isFirstTimeCheck', value: false);
    } catch (e) {
      // Handle error or fallback to device time
      print('Error fetching time: $e');
      now = DateTime.now().toUtc();
    }
  }

  checkDate() async {
    try{
      final isFirstTimeCheck = CacheHelper.getData(key: 'isFirstTimeCheck') ?? true;
      // if (isFirstTimeCheck) {
      //   await getTime();
      // }

      String? storedBlockedDate = CacheHelper.getData(key: Constants.blockedDate.toString());
      String? storedExpireDate = CacheHelper.getData(key: Constants.expireDate.toString());

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

      if (parsedDate != null && now.isBefore(parsedDate!)) {
        differenceTime = parsedDate!.difference(now);
        expireDate = storedExpireDate;
        blockedDate = storedBlockedDate;
      }

    }catch(e){
      print('eeeeeeeeeeeeeee${e.toString()}');
    }

    emit(CheckDifferenceState());
    // print('expireDate: $storedExpireDate');
    // print('blockedDate: $storedBlockedDate');
    // print('Time difference: $differenceTime');
  }

  defaultDate(){
    differenceTime = Duration.zero;
    emit(RemoveDateState());
  }

///////////////////////////////////////////////////////////////////////////////////////////////
  UpdateMobileNumberUseCase updateMobileNumberUseCase;
  UpdateMobileEntity? updateMobileEntity;
  Future updateMobile({required int mobileID,required String phoneNumber,required String countryCode,required bool isWhatsApp}) async {
    CacheHelper.removeData(key: Constants.expireDate.toString());
    CacheHelper.removeData(key: Constants.blockedDate.toString());
    CacheHelper.saveData(key: 'isFirstTimeCheck', value: true);
    emit(UpdateMobileLoading());
    isLoading = true;
    final profileInfo = await updateMobileNumberUseCase(mobileID,phoneNumber,countryCode,isWhatsApp);
    profileInfo.fold((failure) {
      errorMessage = failure.errorMessage;
      emit(UpdateMobileFailure(failure.errorMessage));
    }, (updateMobile)async {
      if (updateMobile.isSuccess == true) {
        try{
        updateMobileEntity = updateMobile;
        isLoading = false;
          CacheHelper.saveData(key: Constants.expireDate.toString(), value: updateMobile.data?.expiryDate??'');
          CacheHelper.saveData(key: Constants.blockedDate.toString(), value: updateMobile.data?.blockTillDate ?? '');
          CacheHelper.saveData(key: Constants.newPasswordId.toString(), value: updateMobile.data?.mobileId);
        await getTime();
        }catch(e){
          print('eeeeeeeeeeeeeeee${e.toString()}');
        }
        emit(UpdateMobileSuccess());

      } else {
        isLoading = false;
        errorMessage = updateMobile.errors?.first.message;
        emit(UpdateMobileError(updateMobile.errors!.first.message!));
      }
    });
  }
  ///////////////////////////////////////////////////////////////////////////////////////////////
  VerifyMobileUseCase verifyMobileUseCase;

  Future verifyMobile({required int mobileId,required int oldMobileId,required String code}) async {
    emit(VerifyMobileLoading());
    final profileInfo = await verifyMobileUseCase(mobileId,oldMobileId,code);
    profileInfo.fold((failure) {
      errorMessage = failure.errorMessage;
      emit(VerifyMobileFailure(failure.errorMessage));
    }, (verifyMobile) {
      if (verifyMobile.isSuccess == true) {
        emit(VerifyMobileSuccess());
      } else {
        errorMessage = verifyMobile.errors?.first.message;
        emit(VerifyMobileError(verifyMobile.errors!.first.message!));
      }
    });
  }
}
