import 'package:auth_dexef/auth/resetPassword/presentation/cubit/reset_password_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_ip_address/get_ip_address.dart' as ip;
import '../../../../core/rest/cash_helper.dart';
import '../../../../core/rest/constants.dart';
import '../../domain/useCase/create_new_password_use_case.dart';
import '../../domain/useCase/resend_forget_pass_code_use_case.dart';
import '../../domain/useCase/reset_password_use_case.dart';
import '../../domain/useCase/verify_forget_pass_use_case.dart';

class ResetPasswordCubit extends Cubit<ResetPasswordStates> {
  ResetPasswordCubit(
    this.resetPasswordUseCase,
    this.createNewPasswordUseCase,
    this.resendForgetPasswordCodeUseCase,
    this.verifyForgetPasswordUseCase
  ):super(ResetPasswordInitialState());

  static ResetPasswordCubit get(context) => BlocProvider.of(context);
  final ResetPasswordUseCase resetPasswordUseCase;
  final CreateNewPasswordUseCase createNewPasswordUseCase;
  final VerifyForgetPasswordUseCase verifyForgetPasswordUseCase;
  final ResendForgetPasswordCodeUseCase resendForgetPasswordCodeUseCase;
  Duration? differenceTime = const Duration(seconds: 0);
  DateTime now = DateTime.now().toUtc();
  DateTime? parsedDate;

//////////////////////////////////////////////////////////////////////////////// reset password
  String? dialCode;
  resetPassword({required String emailOrPhone,required bool isWhatsapp}) async {
    emit(LoadingState());
    dialCode = await lookupUserCountry();
    final result = await resetPasswordUseCase(emailOrPhone,isWhatsapp);
    result.fold((failure) => emit(ResetPasswordFailed(failure.errorMessage)),
        (resetPassword) {
      debugPrint("${resetPassword.isSuccess}");
      if (resetPassword.isSuccess!) {
        debugPrint("${resetPassword.data!.mobileId!}");
        emit(ResetPasswordSuccess(resetPassword.data!.mobileId!));
      } else {
        emit(ResetPasswordError(resetPassword.errors!.first.message!));
      }
    });
  }
//////////////////////////////////////////////////////////////////////////////// verify forget password
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
      debugPrint('$dialCode$emailOrPhone1');
    }
  }
////////////////////////////////////////////////////////////////////////////////
  Dio dio = Dio();
  Future<String> lookupUserCountry() async {
    // final ipv4 = await Ipify.ipv4();
    final ipAddress = ip.IpAddress(type: ip.RequestType.text);
    final ipv4 = await ipAddress.getIpAddress();
    debugPrint('IP Address: $ipv4');
    debugPrint(ipv4);
    final response = await dio.get('https://api.ipregistry.co/$ipv4?key=tz3om0lor45w6ec6');
    debugPrint(response.data['location']['country']['calling_code']);
    if (response.statusCode == 200) {
      return response.data['location']['country']['calling_code'];
    } else {
      throw Exception('Failed to get user country from IP address');
    }
  }
////////////////////////////////////////////////////////////////////////////////
  String? errorMessage;
  createNewPassword ({
    required String code,
    required int mobileID,
    required String password})
  async {
    emit(CreateNewPasswordLoading());
    final result = await createNewPasswordUseCase(mobileID,code,password);
    result.fold((failure){
      errorMessage = failure.errorMessage;
      emit(CreateNewPasswordFailure(failure.errorMessage));
    },(createNewPassword) {
      if(createNewPassword.isSuccess!){
        emit(CreateNewPasswordSuccess(createNewPassword));
      }
      else{
        errorMessage = createNewPassword.errors!.first.message;
        emit(CreateNewPasswordError(createNewPassword));
      }
    });
  }
////////////////////////////////////////////////////////////////////////////////
  verifyForgetPassword({required String code, int? mobileID}) async {
    emit(LoadingStateVerifyCode());
    final result = await verifyForgetPasswordUseCase(mobileID!, code);
    result.fold((failure) {
      errorMessage = failure.errorMessage;
      emit(VerifyForgetPasswordFailed(failure.errorMessage));
    },(verifyForgetPassword) {
      if (verifyForgetPassword.isSuccess!) {
        checkDate();
        emit(VerifyForgetPasswordSuccess());
      } else {
        errorMessage = verifyForgetPassword.errors?.first.message;
        emit(VerifyForgetPasswordError(verifyForgetPassword.errors!.first.message!));
      }
    });
  }
/////////////////////////////////////////////////////////////////////////////////// resend code sms
  resendCodeSms ({required int mobileId}) async {
    emit(LoadingState());
    try{
      final result = await resendForgetPasswordCodeUseCase(mobileId,CacheHelper.getData(key: Constants.isWhatsApp.toString()) ?? true);
      result.fold((failure) => emit(ResendCodeFailed(failure.errorMessage)),
      (resendCode) {
        CacheHelper.saveData(key: Constants.resetExpireDate.toString(), value: resendCode.data?.expiryDate??'');
        CacheHelper.saveData(key: Constants.resetBlockedDate.toString(), value: resendCode.data?.blockTillDate ?? '');
        checkDate();
        emit(ResendCodeSuccess());
      });
    }catch(e){
      debugPrint('resendCodeSms${e.toString()}');
    }
  }
///////////////////////////////////////////////////////////////////////////////////
  checkDate() {
    DateTime now = DateTime.now().toUtc();
    final isFirstTimeCheck = CacheHelper.getData(key: 'isFirstTimeCheck') ?? true;
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
      }else{
        parsedDate = DateTime.parse(storedBlockedDate).subtract(const Duration(minutes: 2));
      }
    } else if (storedExpireDate != null) {
      parsedDate = DateTime.parse(storedExpireDate);
    }
    if(parsedDate != null && now.isBefore(parsedDate!)) {
      differenceTime = parsedDate!.difference(now);
    }
  }
////////////////////////////////////////////////////////////////////////////////
  defaultDate(){
    differenceTime = Duration.zero;
    emit(RemoveDateState());
  }
////////////////////////////////////////////////////////////////////////////////
}
