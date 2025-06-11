import 'package:auth_dexef/auth/resetPassword/presentation/cubit/reset_password_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_ip_address/get_ip_address.dart' as ip;
import '../../domain/useCase/create_new_password_use_case.dart';
import '../../domain/useCase/reset_password_use_case.dart';

class ResetPasswordCubit extends Cubit<ResetPasswordStates> {
  ResetPasswordCubit(
    this.resetPasswordUseCase,
    this.createNewPasswordUseCase
  ):super(ResetPasswordInitialState());

  static ResetPasswordCubit get(context) => BlocProvider.of(context);
  ResetPasswordUseCase resetPasswordUseCase;
  CreateNewPasswordUseCase createNewPasswordUseCase;

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
}
