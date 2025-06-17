import 'package:auth_dexef/features/login/presentation/cubit/login_cubit.dart';
import 'package:auth_dexef/features/resetPassword/presentation/cubit/reset_password_state.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/rest/cash_helper.dart';
import '../../../../core/rest/constants.dart';
import '../../../../main.dart';
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
  static final ResetPasswordCubit _resetPasswordCubit = BlocProvider.of<ResetPasswordCubit>(navigatorKey.currentState!.context);
  static ResetPasswordCubit get instance => _resetPasswordCubit;
////////////////////////////////////////////////////////////////////////////////
  String? errorMessage;
  Duration? differenceTime = const Duration(seconds: 0);
  DateTime now = DateTime.now().toUtc();
  DateTime? parsedDate;
  String? dialCode;
/////////////////////////////////////////////////////////////////////////////////////////////// create new password
////////////////////////////////////////////////////////////////////////////////
  final CreateNewPasswordUseCase createNewPasswordUseCase;
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
        emit(CreateNewPasswordError(createNewPassword.errors!.first.message));
      }
    });
  }
/////////////////////////////////////////////////////////////////////////////////////////////// resend code sms
////////////////////////////////////////////////////////////////////////////////
  final ResendForgetPasswordCodeUseCase resendForgetPasswordCodeUseCase;
  resendCodeSms ({required int mobileId}) async {
    emit(ResendForgetPasswordLoading());
    try{
      final result = await resendForgetPasswordCodeUseCase(mobileId,CacheHelper.getData(key: Constants.isWhatsApp.toString()) ?? true);
      result.fold((failure) => emit(ResendForgetPasswordFailure(failure.errorMessage)),
        (resendCode) {
          if(resendCode.isSuccess == true){
            CacheHelper.saveData(key: Constants.resetExpireDate.toString(), value: resendCode.data?.expiryDate??'');
            CacheHelper.saveData(key: Constants.resetBlockedDate.toString(), value: resendCode.data?.blockTillDate ?? '');
            checkDate();
            emit(ResendForgetPasswordSuccess(resendCode));
          }else{
            emit(ResendForgetPasswordError(resendCode.errors?.first.message));
          }
        });
    }catch(e){
      emit(ResendForgetPasswordError(e.toString()));
    }
  }
/////////////////////////////////////////////////////////////////////////////////////////////// reset password
////////////////////////////////////////////////////////////////////////////////
  final ResetPasswordUseCase resetPasswordUseCase;
  resetPassword({required String emailOrPhone,required bool isWhatsapp}) async {
    emit(ResetPasswordLoading());
    dialCode = await LoginCubit.instance.lookupUserCountry();
    final result = await resetPasswordUseCase(emailOrPhone,isWhatsapp);
    result.fold((failure) => emit(ResetPasswordFailure(failure.errorMessage)),
      (resetPassword) {
        debugPrint("${resetPassword.isSuccess}");
      if (resetPassword.isSuccess == true){
        debugPrint("${resetPassword.data!.mobileId!}");
        emit(ResetPasswordSuccess(resetPassword));
      } else {
        emit(ResetPasswordError(resetPassword.errors!.first.message!));
      }
    });
  }
////////////////////////////////////////////////////////////////////////////////
  Future<void> resetPasswordEmailOrPhone(String emailOrPhone,bool isWhatsapp) async {
    debugPrint(emailOrPhone);
    if (emailOrPhone.contains('@')) {
       resetPassword (emailOrPhone: emailOrPhone,isWhatsapp: isWhatsapp);
    } else if (emailOrPhone.contains("+")) {
        resetPassword (emailOrPhone: emailOrPhone,isWhatsapp: isWhatsapp);
    } else {
      String? dialCode;
      dialCode = await LoginCubit.instance.lookupUserCountry();
      String? emailOrPhone1 = emailOrPhone.startsWith('0')
          ? emailOrPhone.replaceFirst('0', '')
          : emailOrPhone;
        resetPassword (emailOrPhone: '+$dialCode$emailOrPhone1',isWhatsapp: isWhatsapp);
      debugPrint('$dialCode$emailOrPhone1');
    }
  }
/////////////////////////////////////////////////////////////////////////////////////////////// verify Forget Password
////////////////////////////////////////////////////////////////////////////////
  final VerifyForgetPasswordUseCase verifyForgetPasswordUseCase;
  verifyForgetPassword({required String code, int? mobileID}) async {
    emit(VerifyMobileForgetLoading());
    final result = await verifyForgetPasswordUseCase(mobileID!, code);
    result.fold((failure) {
      errorMessage = failure.errorMessage;
      emit(VerifyMobileForgetFailure(failure.errorMessage));
    },(verifyForgetPassword) {
      if (verifyForgetPassword.isSuccess!) {
        checkDate();
        emit(VerifyMobileForgetSuccess(verifyForgetPassword));
      } else {
        errorMessage = verifyForgetPassword.errors?.first.message;
        emit(VerifyMobileForgetError(verifyForgetPassword.errors!.first.message!));
      }
    });
  }
/////////////////////////////////////////////////////////////////////////////////////////////// public
////////////////////////////////////////////////////////////////////////////////
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
